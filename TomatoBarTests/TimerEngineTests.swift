import XCTest
@testable import TomatoBar

final class TimerEngineTests: XCTestCase {

    func testInitialStateIsIdle() {
        let engine = TimerEngine()
        XCTAssertEqual(engine.state, .idle)
    }

    func testInitialModeIsFocus() {
        let engine = TimerEngine()
        XCTAssertEqual(engine.currentMode, .focus)
    }

    func testInitialRoundIsOne() {
        let engine = TimerEngine()
        XCTAssertEqual(engine.currentRound, 1)
    }

    func testConfigureSetsDurations() {
        let engine = TimerEngine()
        engine.configure(focusDuration: 30, shortBreakDuration: 10, longBreakDuration: 20, roundsBeforeLongBreak: 3, autoStartNext: false)
        XCTAssertEqual(engine.totalSeconds, 30 * 60)
        XCTAssertFalse(engine.autoStartNext)
    }

    func testStartTransitionsToRunningAndSetsRemaining() {
        let engine = TimerEngine()
        engine.configure(focusDuration: 25, shortBreakDuration: 5, longBreakDuration: 15, roundsBeforeLongBreak: 4, autoStartNext: false)
        engine.start()
        XCTAssertEqual(engine.state, .running)
        XCTAssertEqual(engine.remainingSeconds, 25 * 60)
    }

    func testPauseTransitionsToPaused() {
        let engine = TimerEngine()
        engine.configure(focusDuration: 25, shortBreakDuration: 5, longBreakDuration: 15, roundsBeforeLongBreak: 4, autoStartNext: false)
        engine.start()
        engine.pause()
        XCTAssertEqual(engine.state, .paused)
    }

    func testResumeTransitionsToRunning() {
        let engine = TimerEngine()
        engine.configure(focusDuration: 25, shortBreakDuration: 5, longBreakDuration: 15, roundsBeforeLongBreak: 4, autoStartNext: false)
        engine.start()
        engine.pause()
        engine.resume()
        XCTAssertEqual(engine.state, .running)
    }

    func testTickDecrementsRemainingSeconds() {
        let engine = TimerEngine()
        engine.configure(focusDuration: 25, shortBreakDuration: 5, longBreakDuration: 15, roundsBeforeLongBreak: 4, autoStartNext: false)
        engine.start()
        let before = engine.remainingSeconds
        engine.tick()
        XCTAssertEqual(engine.remainingSeconds, before - 1)
    }

    func testTickWhenPausedDoesNothing() {
        let engine = TimerEngine()
        engine.configure(focusDuration: 25, shortBreakDuration: 5, longBreakDuration: 15, roundsBeforeLongBreak: 4, autoStartNext: false)
        engine.start()
        engine.pause()
        let before = engine.remainingSeconds
        engine.tick()
        XCTAssertEqual(engine.remainingSeconds, before)
    }

    func testTickReachingZeroTransitionsToFinished() {
        let engine = TimerEngine()
        engine.configure(focusDuration: 25, shortBreakDuration: 5, longBreakDuration: 15, roundsBeforeLongBreak: 4, autoStartNext: false)
        engine.start()
        engine.remainingSeconds = 1
        engine.tick()
        XCTAssertEqual(engine.state, .finished)
        XCTAssertEqual(engine.remainingSeconds, 0)
    }

    func testSkipFromFocusGoesToShortBreak() {
        let engine = TimerEngine()
        engine.configure(focusDuration: 25, shortBreakDuration: 5, longBreakDuration: 15, roundsBeforeLongBreak: 4, autoStartNext: false)
        engine.start()
        engine.skip()
        XCTAssertEqual(engine.currentMode, .shortBreak)
        XCTAssertEqual(engine.state, .idle)
    }

    func testSkipFromShortBreakGoesToFocus() {
        let engine = TimerEngine()
        engine.configure(focusDuration: 25, shortBreakDuration: 5, longBreakDuration: 15, roundsBeforeLongBreak: 4, autoStartNext: false)
        engine.currentMode = .shortBreak
        engine.currentRound = 1
        engine.skip()
        XCTAssertEqual(engine.currentMode, .focus)
        XCTAssertEqual(engine.currentRound, 2)
    }

    func testFourthRoundFocusLeadsToLongBreak() {
        let engine = TimerEngine()
        engine.configure(focusDuration: 25, shortBreakDuration: 5, longBreakDuration: 15, roundsBeforeLongBreak: 4, autoStartNext: false)
        engine.currentRound = 4
        engine.start()
        engine.remainingSeconds = 1
        engine.tick()
        XCTAssertEqual(engine.currentMode, .longBreak)
    }

    func testAdvanceAfterLongBreakResetsRoundToOne() {
        let engine = TimerEngine()
        engine.configure(focusDuration: 25, shortBreakDuration: 5, longBreakDuration: 15, roundsBeforeLongBreak: 4, autoStartNext: false)
        engine.currentMode = .longBreak
        engine.currentRound = 4
        engine.skip()
        XCTAssertEqual(engine.currentMode, .focus)
        XCTAssertEqual(engine.currentRound, 1)
    }

    func testOnSessionCompleteCallbackIsCalled() {
        let engine = TimerEngine()
        engine.configure(focusDuration: 25, shortBreakDuration: 5, longBreakDuration: 15, roundsBeforeLongBreak: 4, autoStartNext: false)
        var callbackFired = false
        var callbackMode: SessionType?
        engine.onSessionComplete = { mode, completed in
            callbackFired = true
            callbackMode = mode
        }
        engine.start()
        engine.remainingSeconds = 1
        engine.tick()
        XCTAssertTrue(callbackFired)
        XCTAssertEqual(callbackMode, .focus)
    }
}
