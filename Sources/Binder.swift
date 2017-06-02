/**
 */
public final class Binder<T> {

    private var _singleton: Bool
    private var _provider: Provider<T>?
    private var _type: Injectable.Type?
    private var _handler: Provider<T>.ProviderHandler?

    public init() {
        self._singleton = false
    }

    @discardableResult
    public func to(type: Injectable.Type) -> Self {
        self._type = type
        return self
    }

    @discardableResult
    public func to(object: T) -> Self {
        return self.to(provider: SingletonProvider(object: object))
    }

    @discardableResult
    public func to(provider: Provider<T>) -> Self {
        self._provider = provider
        return self
    }

    @discardableResult
    public func with(handler: @escaping Provider<T>.ProviderHandler) -> Self {
        self._handler = handler
        return self
    }

    @discardableResult
    public func singleton() -> Self {
        self._singleton = true
        return self
    }

    public func provider() -> Provider<T>? {
        if self._provider == nil {
            if self._singleton {
                if let type = self._type {
                    self._provider = SingletonProvider(type: type)
                } else if let handler = self._handler {
                    self._provider = SingletonProvider(handler: handler)
                }
            } else {
                if let type = self._type {
                    self._provider = Provider(type: type)
                } else if let handler = self._handler {
                    self._provider = Provider(handler: handler)
                }
            }
        }
        return self._provider
    }
}
