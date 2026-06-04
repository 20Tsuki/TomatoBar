import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }

    func notify(sessionType: SessionType, config: TimerConfiguration) {
        guard config.notificationEnabled else { return }

        let content = UNMutableNotificationContent()
        switch sessionType {
        case .focus:
            content.title = "Focus Complete"
            content.body = "Take a break, \(config.shortBreakDuration) min short break"
        case .shortBreak:
            content.title = "Break Over"
            content.body = "Start a new pomodoro"
        case .longBreak:
            content.title = "Long Break Over"
            content.body = "Start a new round"
        }

        if config.soundEnabled {
            content.sound = .default
        }

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
    }
}
