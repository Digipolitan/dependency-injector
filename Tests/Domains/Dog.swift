@testable import DGDependencyInjector

open class Dog: IAnimal, Injectable {

    public required convenience init(injector: Injector, arguments: [String : Any]?) throws {
        guard let name = arguments?["name"] as? String else {
            throw DependencyError.initializationFailed
        }
        self.init(name: name)
    }

    public var name: String

    public init(name: String) {
        self.name = name
    }

    public func scream() -> String {
        return "Barking"
    }
}
