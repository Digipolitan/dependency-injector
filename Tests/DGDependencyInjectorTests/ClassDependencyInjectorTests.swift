import XCTest
@testable import DGDependencyInjector

class ClassDependencyInjectorTests: XCTestCase {

    private var injector: DependencyInjector?
    private var otherInjector: DependencyInjector?

    override func setUp() {
        super.setUp()
        let injector = DependencyInjector()
        let module = DependencyModule()
        module.register(type: IAnimal.self) { (_, arguments) -> IAnimal? in
            if let name = arguments?["name"] as? String {
                return Dog(name: name)
            }
            return nil
        }
        injector.register(module: module)
        self.injector = injector

        let otherInjector = DependencyInjector()
        let otherModule = DependencyModule()
        otherModule.register(type: IAnimal.self) { (_, arguments) -> IAnimal? in
            if let name = arguments?["name"] as? String {
                return Cat(name: name)
            }
            return nil
        }
        otherInjector.register(module: otherModule)
        self.otherInjector = otherInjector
    }

    func testDogInjection() {
        let dog = self.injector?.inject(type: IAnimal.self, arguments: [
            "name": "Athina"
            ])
        XCTAssertNotNil(dog)
        XCTAssert(type(of: dog!) == Dog.self, "Error during the Animal injection")
    }

    func testFailDogInjection() {
        let dog = self.injector?.inject(type: IAnimal.self)
        XCTAssertNil(dog)
    }

    func testCatInjection() {
        let cat = self.otherInjector?.inject(type: IAnimal.self, arguments: [
            "name": "Billy"
            ])
        XCTAssertNotNil(cat)
        XCTAssert(cat!.name == "Billy", "Error during the Animal injection")
    }
}
