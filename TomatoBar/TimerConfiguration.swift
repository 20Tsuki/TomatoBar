import Foundation
import SwiftData

@Model
final class TimerConfiguration {
    var focusDuration: Int = 25
    var shortBreakDuration: Int = 5
    var longBreakDuration: Int = 15
    var roundsBeforeLongBreak: Int = 4
    var autoStartNext: Bool = true
    var soundEnabled: Bool = true
    var notificationEnabled: Bool = true

    init(
        focusDuration: Int = 25,
        shortBreakDuration: Int = 5,
        longBreakDuration: Int = 15,
        roundsBeforeLongBreak: Int = 4,
        autoStartNext: Bool = true,
        soundEnabled: Bool = true,
        notificationEnabled: Bool = true
    ) {
        self.focusDuration = focusDuration
        self.shortBreakDuration = shortBreakDuration
        self.longBreakDuration = longBreakDuration
        self.roundsBeforeLongBreak = roundsBeforeLongBreak
        self.autoStartNext = autoStartNext
        self.soundEnabled = soundEnabled
        self.notificationEnabled = notificationEnabled
    }
}
