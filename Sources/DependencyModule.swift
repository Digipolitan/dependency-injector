/**
 * Dependency module is a registry of provider which provides the possibility to register providers for a specific class, struct or protocol
 * @author Benoit BRIATTE http://www.digipolitan.com
 * @copyright 2016 Digipolitan. All rights reserved.
 */
open class DependencyModule {

    /** The default scope */
    open static let defaultScope = "_"

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
    fileprivate var records: [String: [String: Any]]

    public init() {
        self.records = [:]
    }

    @discardableResult
    open func register<T>(type: T.Type, scope: String = DependencyModule.defaultScope, provider: DependencyProvider<T>) -> Self {
        let reference = String(describing: type)
        var record = self.records[reference] ?? [:]
        record[scope] = provider
        self.records[reference] = record
        return self
    }

    /**
     * Registers a provider for the given Type
     * @param type The Type used for injection
     * @param scope The custom scope, give nil to use default scope
     * @param provider The provider used to inject an object of Type T
     */
    @discardableResult
    open func register<T>(type: T.Type, scope: String = DependencyModule.defaultScope, handler: @escaping DependencyProvider<T>.DependencyHandler) -> Self {
        return self.register(type: type, scope: scope, provider: DependencyProvider(handler: handler))
    }

    /**
     * Registers a provider for the given Type
     * @param type The Type used for injection
     * @param scope The custom scope, give nil to use default scope
     * @param provider The provider used to inject an object of Type T
     */
    @discardableResult
    open func register<T>(type: T.Type, scope: String = DependencyModule.defaultScope, injectedType: Injectable.Type) -> Self {
        return self.register(type: type, scope: scope, provider: DependencyProvider(injectedType: injectedType))
    }

    /**
     * Retrieves a provider using a Type and a scope
     * @param type The Type used for injection
     * @param scope The scope, give nil to use default scope
     * @return The provider or nil if no provider are registered with the given type and scope
     */
    open func provider<T>(type: T.Type, scope: String? = nil) -> DependencyProvider<T>? {
        let reference = String(describing: type)
        if let record = self.records[reference] {
            return record[scope ?? DependencyModule.defaultScope] as? DependencyProvider<T>
        }
        return nil
    }
}

extension DependencyModule: CustomStringConvertible {

    open var description: String {
        return "[\(type(of: self)) entries=\(self.records)]"
    }
}

extension DependencyModule: Equatable {

    public static func == (lhs: DependencyModule, rhs: DependencyModule) -> Bool {
        if lhs === rhs {
            return true
        }
        if lhs.records.count != rhs.records.count {
            return false
        }
        for (key, lhsub) in lhs.records {
            if let rhsub = rhs.records[key] {
                if lhsub.count != rhsub.count {
                    return false
                }
                for (subKey, _) in lhsub {
                    if rhsub[subKey] == nil {
                        return false
                    }
                }
            } else {
                return false
            }
        }
        return true
    }
}
