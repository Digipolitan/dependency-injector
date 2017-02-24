import XCTest

@testable import DGDependencyInjector

class SimpleDependencyInjectorTests: XCTestCase {

    private var injector: DependencyInjector?

    override func setUp() {
        super.setUp()
        let injector = DependencyInjector()
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
        self.injector = injector
    }

    func testStringInjection() {
        XCTAssert(self.injector?.inject(type: String.self) == "Hello", "Error during the string injection")
    }

    func testInt8Injection() {
        XCTAssert(self.injector?.inject(type: Int8.self) == 78, "Error during the Int8 injection")
    }

    func testScopeIntInjection() {
        XCTAssert(self.injector?.inject(type: Int.self) == nil, "Error during the Int injection")
        XCTAssert(self.injector?.inject(type: Int.self, scope: "special") == 99, "Error during the Int injection")
        XCTAssert(self.injector?.inject(type: Int.self, scope: "fail") == nil, "Error during the Int injection")
    }

    func testScopeInjection() {
        XCTAssert(self.injector?.inject(type: String.self, scope: "special") == "Hello", "Error during the String injection")
        XCTAssert(self.injector?.inject(type: Int.self, scope: "fail") == nil, "Error during the Int injection")
    }

}
