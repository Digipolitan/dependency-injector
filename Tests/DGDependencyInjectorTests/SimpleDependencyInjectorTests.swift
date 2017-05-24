import XCTest

@testable import DGDependencyInjector

class SimpleDependencyInjectorTests: XCTestCase {

    /*
    override func setUp() {

        super.setUp()
        let injector = DependencyInjector.default
        let module = DependencyModule()

        module.register(type: String.self) { _ in
            return "Hello"
        }
        module.register(type: Int8.self) { _ in
            return 78
        }
        module.register(type: Int.self, scope: "special") { _ in
            return 99
        }

        injector.register(module: module)
    }

    func testStringInjection() {
        XCTAssert(try DependencyInjector.default.inject(type: String.self) == "Hello", "Error during the string injection")
    }

    func testInt8Injection() {
        XCTAssert(try DependencyInjector.default.inject(type: Int8.self) == 78, "Error during the Int8 injection")
    }

    func testScopeIntInjection() {
        XCTAssertThrowsError(try DependencyInjector.default.inject(type: Int.self), "Error during the Int injection")
        XCTAssert(try DependencyInjector.default.inject(type: Int.self, scope: "special") == 99, "Error during the Int injection")
        XCTAssertThrowsError(try DependencyInjector.default.inject(type: Int.self, scope: "fail"), "Error during the Int injection")
    }

    func testScopeInjection() {
        XCTAssert(try DependencyInjector.default.inject(type: String.self, scope: "special") == "Hello", "Error during the String injection")
        XCTAssertThrowsError(try DependencyInjector.default.inject(type: Int.self, scope: "fail"), "Error during the Int injection")
    }
 */
}
