import XCTest
@testable import SoundMan

final class SoundManTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SoundMan().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
