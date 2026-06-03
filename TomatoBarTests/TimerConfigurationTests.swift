import XCTest
@testable import TomatoBar

final class TimerConfigurationTests: XCTestCase {

    func testDefaultFocusDurationIs25() {
        let config = TimerConfiguration()
        XCTAssertEqual(config.focusDuration, 25)
    }

    func testDefaultShortBreakDurationIs5() {
        let config = TimerConfiguration()
        XCTAssertEqual(config.shortBreakDuration, 5)
    }

    func testDefaultLongBreakDurationIs15() {
        let config = TimerConfiguration()
        XCTAssertEqual(config.longBreakDuration, 15)
    }

    func testDefaultRoundsBeforeLongBreakIs4() {
        let config = TimerConfiguration()
        XCTAssertEqual(config.roundsBeforeLongBreak, 4)
    }

    func testDefaultAutoStartNextIsTrue() {
        let config = TimerConfiguration()
        XCTAssertTrue(config.autoStartNext)
    }

    func testDefaultSoundEnabledIsTrue() {
        let config = TimerConfiguration()
        XCTAssertTrue(config.soundEnabled)
    }

    func testDefaultNotificationEnabledIsTrue() {
        let config = TimerConfiguration()
        XCTAssertTrue(config.notificationEnabled)
    }

    func testCustomInitialization() {
        let config = TimerConfiguration(
            focusDuration: 30,
            shortBreakDuration: 10,
            longBreakDuration: 20,
            roundsBeforeLongBreak: 3,
            autoStartNext: false,
            soundEnabled: false,
            notificationEnabled: false
        )
        XCTAssertEqual(config.focusDuration, 30)
        XCTAssertEqual(config.shortBreakDuration, 10)
        XCTAssertEqual(config.longBreakDuration, 20)
        XCTAssertEqual(config.roundsBeforeLongBreak, 3)
        XCTAssertFalse(config.autoStartNext)
        XCTAssertFalse(config.soundEnabled)
        XCTAssertFalse(config.notificationEnabled)
    }
}
