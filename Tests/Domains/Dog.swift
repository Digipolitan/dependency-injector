@testable import DGDependencyInjector

public struct Dog: IAnimal {

    public var name: String

    public init(name: String) {
        self.name = name
    }

    public func scream() -> String {
        return "Barking"
    }
}

extension Dog: Injectable {
    public init(injector: Injector, arguments: [String : Any]?) throws {
        guard let name = arguments?["name"] as? String else {
            throw DependencyError.initializationFailed
        }
        self.init(name: name)
    }
}
