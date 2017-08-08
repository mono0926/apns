import XCTest
import APNS

class EnvironmentTests: XCTestCase {
    func testSandbox() {
        let env = Environment.sandbox
        XCTAssertTrue(env.contains(.sandbox))
        XCTAssertFalse(env.contains(.production))
    }
    func testProduction() {
        let env = Environment.production
        XCTAssertTrue(env.contains(.production))
        XCTAssertFalse(env.contains(.sandbox))
    }
    func testAll() {
        let env = Environment.all
        XCTAssertTrue(env.contains(.sandbox))
        XCTAssertTrue(env.contains(.production))
    }
}
