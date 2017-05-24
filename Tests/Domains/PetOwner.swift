open class PetOwner {

    public var pet: IAnimal?

    public var name: String

    convenience init(name: String) {
        self.init(name: name, pet: nil)
    }

    init(name: String, pet: IAnimal?) {
        self.name = name
        self.pet = pet
    }
}

public enum PetOwnerKeys {
    static let name = "name"
    static let pet = "pet"
}
