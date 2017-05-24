/**
 * Dependency module is a registry of provider which provides the possibility to register providers for a specific class, struct or protocol
 * @author Benoit BRIATTE http://www.digipolitan.com
 * @copyright 2016 Digipolitan. All rights reserved.
 */
open class Module {

    /**
     * All registrations are stored in this dictionary
     * The first key contains the Type and the value is a dictionary of (scope : provider)
     * Example :
     * module.register(type: String.self, provider: p)
     * module.register(type: String.self, scope: "my-special-scope", provider: p2)
     * records will be : [
     *  "String" : [
     *      "_" : p,
     *      "my-special-scope" : p2
     *  ]
     * ]
     */
    fileprivate var records: [String: Any]

    public init() {
        self.records = [:]
    }

    open func bind<T>(_ type: T.Type) -> Binder<T> {
        let reference = String(describing: type)
        if let binder = self.records[reference] as? Binder<T> {
            return binder
        }
        let binder = Binder<T>()
        self.records[reference] = binder
        return binder
    }

    /**
     * Retrieves a provider using a Type and a scope
     * @param type The Type used for injection
     * @param scope The scope, give nil to use default scope
     * @return The provider or nil if no provider are registered with the given type and scope
     */
    open func provider<T>(for type: T.Type) -> Provider<T>? {
        let reference = String(describing: type)
        if let binder = self.records[reference] as? Binder<T> {
            return binder.provider()
        }
        return nil
    }
}

extension Module: CustomStringConvertible {

    open var description: String {
        return "[\(type(of: self)) entries=\(self.records)]"
    }
}

extension Module: Equatable {

    public static func == (lhs: Module, rhs: Module) -> Bool {
        if lhs === rhs {
            return true
        }
        if lhs.records.count != rhs.records.count {
            return false
        }
        return true
    }
}
