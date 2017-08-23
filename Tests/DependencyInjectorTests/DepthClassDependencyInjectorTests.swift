import XCTest

@testable import DependencyInjector

class DepthClassDependencyInjectorTests: XCTestCase {

    override func setUp() {
        super.setUp()

        let injector = Injector.default
        let module = Module()
        module.bind(IAnimal.self).with { return Dog(name: $1?["name"] as? String ?? "Athina") }
        module.bind(PetOwner.self).with { (injector, arguments) -> PetOwner? in
            if let name = arguments?["name"] as? String {
                if let petArguments = arguments?["pet"] as? [String: Any] {
                    return PetOwner(name: name, pet: try? injector.inject(IAnimal.self, arguments: petArguments))
                }
                return PetOwner(name: name)
            }
            return nil
        }
        module.bind(IAnimal.self).to(Dog.self)
        injector.register(module: module, with: "ID")
    }

    override func tearDown() {
        super.tearDown()
        Injector.default.modules.forEach { Injector.default.remove(module: $0.key) }
    }

    func testPetOwnerInjection() {
        let po = try? Injector.default.inject(PetOwner.self, arguments: [
            "name": "Bala"
        ])
        XCTAssertNotNil(po)
        XCTAssert(po!.name == "Bala", "Error during the PetOwner injection")
        XCTAssertNil(po!.pet)
    }

    func testPetOwnerInjectionWithAnimal() {
        let po = try? Injector.default.inject(PetOwner.self, arguments: [
            "name": "Benoit",
            "pet": [
                "name": "Athina"
            ]
        ])
        XCTAssertNotNil(po)
        XCTAssert(po!.name == "Benoit", "Error during the PetOwner injection")
        XCTAssertNotNil(po!.pet)
        XCTAssert(type(of: po!.pet!) == Dog.self, "Error during the Animal injection")
        XCTAssert(po!.pet!.name == "Athina", "Error during the Animal injection")
    }
}
