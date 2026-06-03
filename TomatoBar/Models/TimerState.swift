import Foundation

enum TimerState {
    case idle
    case running
    case paused
    case finished
}

enum SessionType: String {
    case focus
    case shortBreak
    case longBreak
}
