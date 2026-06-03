import Foundation
import Observation

@Observable
final class TimerEngine {
    var state: TimerState = .idle
    var currentMode: SessionType = .focus
    var remainingSeconds: Int = 0
    var totalSeconds: Int = 0
    var currentRound: Int = 1
    var autoStartNext: Bool = true

    private var focusDuration: Int = 25
    private var shortBreakDuration: Int = 5
    private var longBreakDuration: Int = 15
    private var roundsBeforeLongBreak: Int = 4

    var onSessionComplete: ((SessionType, Bool) -> Void)?

    func configure(
        focusDuration: Int,
        shortBreakDuration: Int,
        longBreakDuration: Int,
        roundsBeforeLongBreak: Int,
        autoStartNext: Bool
    ) {
        self.focusDuration = focusDuration
        self.shortBreakDuration = shortBreakDuration
        self.longBreakDuration = longBreakDuration
        self.roundsBeforeLongBreak = roundsBeforeLongBreak
        self.autoStartNext = autoStartNext
        totalSeconds = focusDuration * 60
    }

    func start() {
        state = .running
        remainingSeconds = totalSeconds
    }

    func pause() {
        guard state == .running else { return }
        state = .paused
    }

    func resume() {
        guard state == .paused else { return }
        state = .running
    }

    func tick() {
        guard state == .running else { return }
        remainingSeconds -= 1
        if remainingSeconds <= 0 {
            remainingSeconds = 0
            state = .finished
            onSessionComplete?(currentMode, true)
            advanceToNextMode()
        }
    }

    func skip() {
        let wasRunning = state == .running || state == .paused
        state = .idle
        onSessionComplete?(currentMode, false)
        advanceToNextMode()
        if wasRunning && autoStartNext {
            start()
        }
    }

    private func advanceToNextMode() {
        switch currentMode {
        case .focus:
            if currentRound >= roundsBeforeLongBreak {
                currentMode = .longBreak
                totalSeconds = longBreakDuration * 60
            } else {
                currentMode = .shortBreak
                totalSeconds = shortBreakDuration * 60
            }
        case .shortBreak:
            currentMode = .focus
            currentRound += 1
            totalSeconds = focusDuration * 60
        case .longBreak:
            currentMode = .focus
            currentRound = 1
            totalSeconds = focusDuration * 60
        }
    }
}
