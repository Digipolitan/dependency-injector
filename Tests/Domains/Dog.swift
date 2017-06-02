@testable import DGDependencyInjector

open class Dog: IAnimal, Injectable {

    public required init(injector: Injector, arguments: [String : Any]?) throws {
        if let name = arguments?[IAnimalKeys.name] as? String {
            self.name = name
        } else {
            throw DependencyError.initializationFailed
        }
    }

    public var name: String

    public init(name: String) {
        self.name = name
    }

    public func scream() -> String {
        return "Barking"
    }
}
