public protocol IAnimal: class {

    var name: String { get }

    func scream() -> String
}

public enum IAnimalKeys {
    static let name = "name"
}
