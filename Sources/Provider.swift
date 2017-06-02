/**
 */
open class Provider<T> {

    public typealias ProviderHandler = (Injector, [String: Any]?) throws -> T?

    private let handler: ProviderHandler

    public init(handler: @escaping ProviderHandler) {
        self.handler = handler
    }

    public convenience init(type: Injectable.Type) {
        self.init { (injector, arguments) -> T? in
            if let res = try type.init(injector: injector, arguments: arguments) as? T {
                return res
            }
            return nil
        }
    }

    public func get(injector: Injector, arguments: [String: Any]?) throws -> T? {
        return try self.handler(injector, arguments)
    }
}

public final class SingletonProvider<T>: Provider<T> {

    private var cache: T?

    public convenience init(object: T) {
        self.init { (_) -> T? in
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
