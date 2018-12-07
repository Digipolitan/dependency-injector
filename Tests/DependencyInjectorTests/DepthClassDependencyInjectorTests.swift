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
        let petOwner = try? Injector.default.inject(PetOwner.self, arguments: [
            "name": "Bala"
        ])
        XCTAssertNotNil(petOwner)
        XCTAssert(petOwner!.name == "Bala", "Error during the PetOwner injection")
        XCTAssertNil(petOwner!.pet)
    }

    func testPetOwnerInjectionWithAnimal() {
        let petOwner = try? Injector.default.inject(PetOwner.self, arguments: [
            "name": "Benoit",
            "pet": [
                "name": "Athina"
            ]
        ])
        XCTAssertNotNil(petOwner)
        XCTAssert(petOwner!.name == "Benoit", "Error during the PetOwner injection")
        XCTAssertNotNil(petOwner!.pet)
        XCTAssert(type(of: petOwner!.pet!) == Dog.self, "Error during the Animal injection")
        XCTAssert(petOwner!.pet!.name == "Athina", "Error during the Animal injection")
    }
}
