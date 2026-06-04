import XCTest
import UserNotifications
@testable import TomatoBar

final class NotificationManagerTests: XCTestCase {

    override func tearDown() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func testNotifyWhenDisabledDoesNotScheduleRequest() {
        let config = TimerConfiguration(soundEnabled: true, notificationEnabled: false)
        let center = UNUserNotificationCenter.current()

        NotificationManager.shared.notify(sessionType: .focus, config: config)

        let expectation = XCTestExpectation(description: "check delivered")
        center.getDeliveredNotifications { notifications in
            XCTAssertTrue(notifications.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testNotifyWhenEnabledSchedulesRequest() {
        let config = TimerConfiguration(soundEnabled: false, notificationEnabled: true)
        let center = UNUserNotificationCenter.current()

        NotificationManager.shared.notify(sessionType: .focus, config: config)

        let expectation = XCTestExpectation(description: "check delivered")
        center.getDeliveredNotifications { notifications in
            XCTAssertEqual(notifications.count, 1)
            if let notification = notifications.first {
                let content = notification.request.content
                XCTAssertEqual(content.title, "Focus Complete")
                XCTAssertNil(content.sound)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testNotifyWithSoundSetsDefaultSound() {
        let config = TimerConfiguration() // soundEnabled=true, notificationEnabled=true
        let center = UNUserNotificationCenter.current()

        NotificationManager.shared.notify(sessionType: .shortBreak, config: config)

        let expectation = XCTestExpectation(description: "check delivered")
        center.getDeliveredNotifications { notifications in
            XCTAssertEqual(notifications.count, 1)
            if let notification = notifications.first {
                let content = notification.request.content
                XCTAssertEqual(content.title, "Break Over")
                XCTAssertEqual(content.sound, .default)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLongBreakNotificationContent() {
        let config = TimerConfiguration(longBreakDuration: 20, soundEnabled: true, notificationEnabled: true)
        let center = UNUserNotificationCenter.current()

        NotificationManager.shared.notify(sessionType: .longBreak, config: config)

        let expectation = XCTestExpectation(description: "check delivered")
        center.getDeliveredNotifications { notifications in
            XCTAssertEqual(notifications.count, 1)
            if let notification = notifications.first {
                let content = notification.request.content
                XCTAssertEqual(content.title, "Long Break Over")
                XCTAssertEqual(content.body, "Start a new round")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
