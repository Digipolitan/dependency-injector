//
//  DependencyProvider.swift
//  DGDependencyInjector
//
//  Created by Benoit BRIATTE on 17/05/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

public protocol Injectable {

    init(injector: DependencyInjector, arguments: [String: Any]?) throws
}

open class DependencyProvider<T> {

    public typealias DependencyHandler = (DependencyInjector, [String: Any]?) throws -> T?

    private let handler: DependencyHandler

    public init(handler: @escaping DependencyHandler) {
        self.handler = handler
    }

    public convenience init(injectedType: Injectable.Type) {
        self.init { (injector, arguments) -> T? in
            if let res = try injectedType.init(injector: injector, arguments: arguments) as? T {
                return res
            }
            return nil
        }
    }

    public func provide(injector: DependencyInjector, arguments: [String: Any]?) throws -> T? {
        return try self.handler(injector, arguments)
    }
}

open class SingletonDependencyProvider<T>: DependencyProvider<T> {

    private var cache: T?

    public convenience init(object: T) {
        self.init(handler: { (_, _) in
            return object
        })
    }

    public override func provide(injector: DependencyInjector, arguments: [String : Any]?) throws -> T? {
        if self.cache != nil {
            return self.cache!
        }
        let object = try super.provide(injector: injector, arguments: arguments)
        self.cache = object
        return object
    }
}
