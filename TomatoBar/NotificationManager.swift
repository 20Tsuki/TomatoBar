import Foundation
import UserNotifications
import AppKit

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
            content.title = "专注完成"
            content.body = "休息一下吧，\(config.shortBreakDuration) 分钟短休息"
        case .shortBreak:
            content.title = "休息结束"
            content.body = "开始新的番茄"
        case .longBreak:
            content.title = "休息结束"
            content.body = "开始新一轮番茄"
        }

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
    }

    func playSound() {
        NSSound.beep()
    }
}
