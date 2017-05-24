@testable import DGDependencyInjector

open class Dog: IAnimal, Injectable {

    public required init(injector: Injector, arguments: [String : Any]?) throws {
        self.name = try Cast.ensure(obj: arguments?[IAnimalKeys.name])
    }

    public var name: String
    public var test: Cat?

    public init(name: String) {
        self.name = name
    }

    public func scream() -> String {
        return "Barking"
    }
}

public class Converter<Source, Target> {

    public typealias ConverterHandler = (Source) throws -> Target

    private let handler: ConverterHandler

    public init(handler: @escaping ConverterHandler) {
        self.handler = handler
    }

    public func convert(value: Source) throws -> Target {
        return try self.handler(value)
    }
}

public class Cast {

    private var defaultValues: [String: Any]
    private var converters: [String: [String: Any]]

    private init() {
        self.defaultValues = [:]
        self.converters = [:]
        self.setup()
    }

    public enum CastError: Error {
        case noConverterFound
        case noDefaultValueFound
    }

    public static let `default` = Cast()

    public func registerConverter<Source, Target>(_ converter: @escaping (_ from: Source) throws -> Target) {
        let src = String(describing: Source.self)
        let target = String(describing: Target.self)
        var record = self.converters[src] ?? [:]
        record[target] = Converter(handler: converter)
        self.converters[src] = record
    }

    public func registerDefaultValue<Target>(_ defaultValue: Target) {
        self.defaultValues[String(describing: Target.self)] = defaultValue
    }

    public func converter<Source, Target>(from source: Source, to targetType: Target.Type) -> Converter<Source, Target>? {
        var mirror = Mirror(reflecting: source)
        let target = String(describing: targetType)
        if let record = self.converters[String(describing: mirror.subjectType)] {
            return record[target] as? Converter<Source, Target>
        }
        while let parent = mirror.superclassMirror {
            if let record = self.converters[String(describing: parent.subjectType)] {
                return record[target] as? Converter<Source, Target>
            }
            mirror = parent
        }
        return nil
    }

    public func defaultValue<Target>(of targetType: Target.Type) -> Target? {
        let target = String(describing: targetType)
        return self.defaultValues[target] as? Target
    }

    public func setup() {
        self.registerDefaultValue("")
        self.registerDefaultValue(Int())
        self.registerDefaultValue(Double())
        self.registerDefaultValue(false)
        self.registerDefaultValue(Float())
        self.registerDefaultValue(Date(timeIntervalSince1970: 0))
        self.registerIntConverters()
        self.registerFloatConverters()
        self.registerDoubleConverters()
        self.registerBoolConverters()
        self.registerStringConverters()
        self.registerNSNumberConverters()
        self.registerNSStringConverters()
    }

    public func registerStringConverters() {
        self.registerConverter { (str: String) -> Int in
            if let res = Double(str) {
                return Int(res)
            }
            return 0
        }
        self.registerConverter { (str: String) -> Double in
            return Double(str) ?? Double()
        }
        self.registerConverter { (str: String) -> Float in
            return Float(str) ?? Float()
        }
        self.registerConverter { (str: String) -> Bool in
            return Bool(str) ?? false
        }
    }

    public func registerNSStringConverters() {
        self.registerConverter { (str: NSString) -> Int in
            return Int(str as String) ?? 0
        }
    }

    public func registerIntConverters() {
        self.registerConverter { (i: Int) -> Double in
            return Double(i)
        }
        self.registerConverter { (i: Int) -> String in
            return String(describing: i)
        }
    }

    public func registerDoubleConverters() {
        self.registerConverter { (v: Double) -> String in
            return String(describing: v)
        }
        self.registerConverter { (v: Double) -> Int in
            return Int(v)
        }
    }

    public func registerFloatConverters() {
        self.registerConverter { (v: Float) -> String in
            return String(describing: v)
        }
    }

    public func registerBoolConverters() {
        self.registerConverter { (v: Bool) -> String in
            return String(describing: v)
        }
        self.registerConverter { (v: Bool) -> Int in
            return v == true ? 1 : 0
        }
    }

    public func registerNSNumberConverters() {
        self.registerConverter { (v: NSNumber) -> Int in
            return v.intValue
        }
        self.registerConverter { (v: NSNumber) -> Double in
            return v.doubleValue
        }
        self.registerConverter { (v: NSNumber) -> Float in
            return v.floatValue
        }
        self.registerConverter { (v: NSNumber) -> Bool in
            return v.boolValue
        }
        self.registerConverter { (v: NSNumber) -> String in
            return v.stringValue
        }
    }

    public static func ensure<T>(obj: Any?) throws -> T {
        if let res = obj as? T {
            return res
        }
        if let unwrap = obj {
            if let converter = Cast.default.converter(from: unwrap, to: T.self) {
                return try converter.convert(value: unwrap)
            }
            throw CastError.noConverterFound
        }
        if let defaultValue = Cast.default.defaultValue(of: T.self) {
            return defaultValue
        }
        throw CastError.noDefaultValueFound
    }

    public static func ensure<T>(collection: [Any]?) throws -> [T] {
        if let res = collection as? [T] {
            return res
        }
        if let unwrap = collection {
            return try unwrap.map({ (obj) -> T in
                return try self.ensure(obj: obj)
            })
        }
        return [T]()
    }

    public static func ensure<IK: Hashable, K: Hashable, V>(dictionary: [IK: Any]?) throws -> [K: V] {
        if let res = dictionary as? [K: V] {
            return res
        }
        var res = [K: V]()
        if let unwrap = dictionary {
            for (key, value) in unwrap {
                res[try self.ensure(obj: key)] = try self.ensure(obj: value)
            }
        }
        return res
    }
}
