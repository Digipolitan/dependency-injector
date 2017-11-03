public protocol Injectable {

    init(injector: Injector, arguments: [String: Any]?) throws
}
