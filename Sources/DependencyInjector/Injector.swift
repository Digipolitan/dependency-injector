/**
 * Lightweight dependency injector
 * Register modules and inject objects, use the singleton to share the injector inside your application
 * @author Benoit BRIATTE http://www.digipolitan.com
 * @copyright 2017 Digipolitan. All rights reserved.
 */
open class Injector {

    /** Retrieves the list of Module */
    public private(set) var modules: [String: Module]

    /** Retrieves the shared instance */
    public static let `default` = Injector.instance(scope: Injector.defaultScope)

    private static var registry = [String: Injector]()

    /** The default key */
    private static let defaultScope = "_"

    public static func instance(scope: String) -> Injector {
        if let stored = self.registry[scope] {
            return stored
        }
        let injector = Injector()
        self.registry[scope] = injector
        return injector
    }

    private init() {
        self.modules = [:]
    }

    /**
     * Registers a new module into the dependency injector
     * As a best practice you should register all modules during the application launch, but you can add dynamically a module whenever in the lifecycle of your application
     * @param module The dependency module to register
     * @return True on success, otherwise false
     */
    @discardableResult
    open func register(module: Module, with identifier: String) -> Self {
        if self.modules[identifier] == nil {
            self.modules[identifier] = module
        }
        return self
    }

    /**
     * Removes the given module from the dependency injector
     * @param module The dependency module to be removed
     */
    @discardableResult
    open func remove(module identifier: String) -> Bool {
        if self.modules[identifier] != nil {
            self.modules[identifier] = nil
            return true
        }
        return false
    }

    /**
     * Creates a new instance conforming the input Type
     * The injector search the first module that can provide the injection
     * @param type The given Type you want to inject
     * @param arguments Used by the provider (Such as nonnull parameters for initializers)
     * @return An injected object
     */
    open func inject<T>(_ type: T.Type, arguments: [String: Any]? = nil) throws -> T {
        for module in self.modules.values {
            if let provider = module.provider(for: type) {
                if let res = try provider.get(injector: self, arguments: arguments) {
                    return res
                }
            }
        }
        throw DependencyError.noDependencyProvided
    }
}

/**
 * Dependency errors
 */
public enum DependencyError: Error {
    case noDependencyProvided
    case initializationFailed
}

extension Injector: CustomStringConvertible {
    open var description: String {
        return "[\(type(of: self)) modules=\(self.modules)]"
    }
}
