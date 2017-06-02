import XCTest

@testable import DGDependencyInjector

class DepthClassDependencyInjectorTests: XCTestCase {

    override func setUp() {
        super.setUp()

        let injector = Injector.default
        let module = Module()
        module.bind(PetOwner.self).with { (injector, arguments) -> PetOwner? in
            if let name = arguments?[PetOwnerKeys.name] as? String {
                if let petArguments = arguments?[PetOwnerKeys.pet] as? [String: Any] {
                    return PetOwner(name: name, pet: try? injector.inject(IAnimal.self, arguments: petArguments))
                }
                return PetOwner(name: name)
            }
            return nil
        }
        module.bind(IAnimal.self).to(type: Dog.self)
        injector.register(module: module)
    }

    override func tearDown() {
        super.tearDown()

        Injector.default.modules.forEach { (m) in
            Injector.default.remove(module: m)
        }
    }

    func testPetOwnerInjection() {
        let po = try? Injector.default.inject(PetOwner.self, arguments: [
            PetOwnerKeys.name: "Bala"
        ])
        XCTAssertNotNil(po)
        XCTAssert(po!.name == "Bala", "Error during the PetOwner injection")
        XCTAssertNil(po!.pet)
    }

    func testPetOwnerInjectionWithAnimal() {
        let po = try? Injector.default.inject(PetOwner.self, arguments: [
            PetOwnerKeys.name: "Benoit",
            PetOwnerKeys.pet: [
                IAnimalKeys.name: "Athina"
            ]
        ])
        XCTAssertNotNil(po)
        XCTAssert(po!.name == "Benoit", "Error during the PetOwner injection")
        XCTAssertNotNil(po!.pet)
        XCTAssert(type(of: po!.pet!) == Dog.self, "Error during the Animal injection")
        XCTAssert(po!.pet!.name == "Athina", "Error during the Animal injection")
    }
}
