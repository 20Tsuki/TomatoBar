import XCTest
@testable import TomatoBar

final class FormattedTimerTests: XCTestCase {

    func testZeroSeconds() {
        XCTAssertEqual(0.formattedTimer, "00:00")
    }

    func testOneSecond() {
        XCTAssertEqual(1.formattedTimer, "00:01")
    }

    func testSixtySeconds() {
        XCTAssertEqual(60.formattedTimer, "01:00")
    }

    func testTwentyFiveMinutes() {
        XCTAssertEqual((25 * 60).formattedTimer, "25:00")
    }

    func testNinetyMinutes() {
        XCTAssertEqual((90 * 60).formattedTimer, "90:00")
    }
}
