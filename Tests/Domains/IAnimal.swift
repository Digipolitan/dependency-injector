public protocol IAnimal {

    var name: String { get }

    func scream() -> String

}

public extension IAnimal where Self: Equatable { }

public func == (lhs: IAnimal, rhs: IAnimal) -> Bool {
    return lhs.name == rhs.name
}
