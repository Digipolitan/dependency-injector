/**
 * Dependency module is a registry of provider which provides the possibility to register providers for a specific class, struct or protocol
 * @author Benoit BRIATTE http://www.digipolitan.com
 * @copyright 2017 Digipolitan. All rights reserved.
 */
open class Module {

    /**
     * All registrations are stored in this dictionary
     */
    fileprivate var records: [String: Any]

    public init() {
        self.records = [:]
    }

    /**
     * Bind types to the module
     * @param type The type to be injected
     * @return The Binder object witch provide the real instance
     */
    public func bind<T>(_ type: T.Type) -> Binder<T> {
        let reference = String(describing: type)
        if let binder = self.records[reference] as? Binder<T> {
            return binder
        }
        let binder = Binder<T>()
        self.records[reference] = binder
        return binder
    }

    /**
     * Retrieves a provider using a Type
     * @param type The Type used for injection
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
