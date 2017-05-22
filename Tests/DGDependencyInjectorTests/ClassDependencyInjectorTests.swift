import XCTest

@testable import DGDependencyInjector

class ClassDependencyInjectorTests: XCTestCase {

    override func setUp() {
        super.setUp()

        let injector = DependencyInjector.default
        let module = DependencyModule()
        module.register(type: IAnimal.self) { (_, arguments) -> IAnimal? in
            if let name = arguments?["name"] as? String {
                return Dog(name: name)
            }
            return nil
        }
        module.register(type: IAnimal.self, scope: "singleton", provider: SingletonDependencyProvider(injectedType: Dog.self))

        injector.register(module: module)

        let otherInjector = DependencyInjector.instance(key: "random")
        let otherModule = DependencyModule()
        otherModule.register(type: IAnimal.self) { (_, arguments) -> IAnimal? in
            if let name = arguments?["name"] as? String {
                return Cat(name: name)
            }
            return nil
        }
        otherInjector.register(module: otherModule)
    }

    func testDogInjection() {
        let dog = try? DependencyInjector.default.inject(type: IAnimal.self, arguments: [
            "name": "Athina"
            ])
        XCTAssertNotNil(dog)
        XCTAssert(type(of: dog!) == Dog.self, "Error during the Animal injection")
    }

    func testFailDogInjection() {
        let dog = try? DependencyInjector.default.inject(type: IAnimal.self)
        XCTAssertNil(dog)
    }

    func testCatInjection() {
        let cat = try? DependencyInjector.instance(key: "random").inject(type: IAnimal.self, arguments: [
            "name": "Billy"
            ])
        XCTAssertNotNil(cat)
        XCTAssert(cat!.name == "Billy", "Error during the Animal injection")
    }

    func testSingletonInjection() {
        let animal = try? DependencyInjector.default.inject(type: IAnimal.self, scope: "singleton")
        let animal2 = try? DependencyInjector.default.inject(type: IAnimal.self, scope: "singleton")
        XCTAssertNotNil(animal)
        XCTAssertTrue(animal! === animal2!)
    }
}
