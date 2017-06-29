/**
 * This class inject a new instance
 * @author Benoit BRIATTE http://www.digipolitan.com
 * @copyright 2017 Digipolitan. All rights reserved.
 */
open class Provider<T> {

    public typealias ProviderHandler = (Injector, [String: Any]?) throws -> T?

    private let handler: ProviderHandler

    /**
     * Init the provider using a handler
     */
    public init(handler: @escaping ProviderHandler) {
        self.handler = handler
    }

    /**
     * Init the provider using an injectable type
     */
    public convenience init(type: Injectable.Type) {
        self.init { (injector, arguments) -> T? in
            if let res = try type.init(injector: injector, arguments: arguments) as? T {
                return res
            }
            return nil
        }
    }

    /**
     * This method retrieve a new instance
     * @param injector The injector
     * @param arguments Arguments to the initializer
     */
    public func get(injector: Injector, arguments: [String: Any]?) throws -> T? {
        return try self.handler(injector, arguments)
    }
}

/**
 * Singleton provider, provide only one instance
 * @author Benoit BRIATTE http://www.digipolitan.com
 * @copyright 2017 Digipolitan. All rights reserved.
 */
public final class SingletonProvider<T>: Provider<T> {

    private var cache: T?

    public convenience init(object: T) {
        self.init { _, _ -> T? in
            return object
        }
    }

    public override func get(injector: Injector, arguments: [String: Any]?) throws -> T? {
        if self.cache != nil {
            return self.cache!
        }
        let object = try super.get(injector: injector, arguments: arguments)
        self.cache = object
        return object
    }
}
