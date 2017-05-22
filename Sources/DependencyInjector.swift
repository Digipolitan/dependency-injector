/**
 * Lightweight dependency injector
 * Register modules and inject objects, use the singleton to share the injector inside your application
 * @author Benoit BRIATTE http://www.digipolitan.com
 * @copyright 2016 Digipolitan. All rights reserved.
 */
open class DependencyInjector {

    /** Retrieves the list of DependencyModule */
    public private(set) var modules: [DependencyModule]

    /** Retrieves the shared instance */
    open static let `default` = DependencyInjector.instance(key: DependencyInjector.defaultKey)

    private static var registry = [String: DependencyInjector]()

    /** The default key */
    private static let defaultKey = "_"

    open static func instance(key: String) -> DependencyInjector {
        if let stored = self.registry[key] {
            return stored
        }
        let injector = DependencyInjector()
        self.registry[key] = injector
        return injector
    }

    private init() {
        self.modules = []
    }

    /**
     * Registers a new module into the dependency injector
     * As a best practice you should register all modules during the application launch, but you can add dynamically a module whenever in the lifecycle of your application
     * @param module The dependency module to register
     * @return True on success, otherwise false
     */
    @discardableResult
    open func register(module: DependencyModule) -> Self {
        if self.modules.index(of: module) == nil {
            self.modules.insert(module, at: 0)
        }
        return self
    }

    /**
     * Removes the given module from the dependency injector
     * @param module The dependency module to be removed
     */
    @discardableResult
    open func remove(module: DependencyModule) -> Bool {
        if let i = self.modules.index(of: module) {
            self.modules.remove(at: i)
            return true
        }
        return false
    }

    /**
     * Creates a new instance conforming the input Type
     * The injector search the first module that can provide the injection
     * @param type The given Type you want to inject
     * @param scope Custom scope, give nil to use default scope
     * @param arguments Used by the provider (Such as nonnull parameters for initializers)
     * @return An injected object, nil if an error occurred
     */
    open func inject<T>(type: T.Type, scope: String? = nil, arguments: [String: Any]? = nil) throws -> T {
        for module in self.modules {
            if let provider = module.provider(type: type, scope: scope) {
                if let res = try provider.provide(injector: self, arguments: arguments) {
                    return res
                }
            }
        }
        if scope != nil {
            return try self.inject(type: type, scope: nil, arguments: arguments)
        }
        throw DependencyError.noDependencyProvided
    }
}

public enum DependencyError: Error {
    case noDependencyProvided
}

extension DependencyInjector: CustomStringConvertible {
    open var description: String {
        return "[\(type(of: self)) modules=\(self.modules)]"
    }
}

extension DependencyInjector: Equatable {

    public static func == (lhs: DependencyInjector, rhs: DependencyInjector) -> Bool {
        if lhs === rhs {
            return true
        }
        return lhs.modules == rhs.modules
    }
}
