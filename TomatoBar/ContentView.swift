//
//  ContentView.swift
//  TomatoBar
//
//  Created by Layla Garcia on 2026/6/3.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(TimerEngine.self) private var timerEngine
    @Environment(\.modelContext) private var modelContext
    @State private var timerConfigured = false

    var body: some View {
        VStack(spacing: 0) {
            TabView {
                TimerPanelView()
                    .tabItem { Text("计时") }
                StatsView()
                    .tabItem { Text("统计") }
                SettingsView()
                    .tabItem { Text("设置") }
            }

            Divider()

            HStack {
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
                Spacer()
            }
            .padding(.vertical, 6)
        }
        .frame(width: 320, height: 500)
        .onAppear {
            guard !timerConfigured else { return }
            timerConfigured = true
            setupEngineAndTimer()
        }
    }

    private func setupEngineAndTimer() {
        let config = fetchConfig()
        timerEngine.configure(
            focusDuration: config.focusDuration,
            shortBreakDuration: config.shortBreakDuration,
            longBreakDuration: config.longBreakDuration,
            roundsBeforeLongBreak: config.roundsBeforeLongBreak,
            autoStartNext: config.autoStartNext
        )
        timerEngine.onSessionComplete = { mode, completed in
            saveSession(mode: mode, completed: completed)
            if completed {
                let config = fetchConfig()
                NotificationManager.shared.notify(sessionType: mode, config: config)
                if config.autoStartNext {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        timerEngine.start()
                    }
                }
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timerEngine.tick()
        }
    }

    private func fetchConfig() -> TimerConfiguration {
        let descriptor = FetchDescriptor<TimerConfiguration>()
        if let existing = try? modelContext.fetch(descriptor).first {
            return existing
        }
        let new = TimerConfiguration()
        modelContext.insert(new)
        try? modelContext.save()
        return new
    }

    private func saveSession(mode: SessionType, completed: Bool) {
        let now = Date()
        let elapsed = timerEngine.totalSeconds - timerEngine.remainingSeconds
        let session = TimerSession(
            startTime: now.addingTimeInterval(-Double(elapsed)),
            endTime: now,
            type: mode.rawValue,
            duration: elapsed,
            completed: completed
        )
        modelContext.insert(session)
        try? modelContext.save()
    }
}
