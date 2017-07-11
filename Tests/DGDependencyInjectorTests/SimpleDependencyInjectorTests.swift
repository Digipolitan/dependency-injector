import XCTest

@testable import DGDependencyInjector

class SimpleDependencyInjectorTests: XCTestCase {

    override func setUp() {

        super.setUp()
        let injector = Injector.default
        let module = Module()

        module.bind(String.self).with { _ in
            return "Hello"
        }
        module.bind(Int8.self).with { _ in
            return 78
        }
        injector.register(module: module, with: "ID")

        let other = Injector.instance(scope: "special")
        let moduleOther = Module()
        moduleOther.bind(Int.self).with { _ -> Int? in
            return 99
        }
        other.register(module: moduleOther, with: "ID")
    }

    override func tearDown() {
        super.tearDown()

        let injector = Injector.default
        injector.modules.forEach {
            injector.remove(module: $0.key)
        }

        let other = Injector.instance(scope: "special")
        other.modules.forEach {
            other.remove(module: $0.key)
        }
    }

    func testStringInjection() {
        XCTAssert(try Injector.default.inject(String.self) == "Hello", "Error during the string injection")
    }

    func testInt8Injection() {
        XCTAssert(try Injector.default.inject(Int8.self) == 78, "Error during the Int8 injection")
    }

    func testScopeIntInjection() {
        XCTAssertThrowsError(try Injector.default.inject(Int.self), "Error during the Int injection")
        XCTAssert(try Injector.instance(scope: "special").inject(Int.self) == 99, "Error during the Int injection")
        XCTAssertThrowsError(try Injector.instance(scope: "fail").inject(Int.self), "Error during the Int injection")
    }

    func testScopeInjection() {
        XCTAssertThrowsError(try Injector.instance(scope: "special").inject(String.self), "Error during the String injection")
        XCTAssertThrowsError(try Injector.instance(scope: "fail").inject(Int.self), "Error during the Int injection")
    }
}
