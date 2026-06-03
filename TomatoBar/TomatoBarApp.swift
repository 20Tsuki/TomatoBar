//
//  TomatoBarApp.swift
//  TomatoBar
//
//  Created by Layla Garcia on 2026/6/3.
//

import SwiftUI
import SwiftData
import AppKit
import UserNotifications

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
}

@main
struct TomatoBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var timerEngine = TimerEngine()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TimerConfiguration.self,
            TimerSession.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environment(timerEngine)
                .modelContainer(sharedModelContainer)
        } label: {
            let icon = timerEngine.currentMode == .focus ? "🍅" : "☕️"
            let mm = timerEngine.remainingSeconds / 60
            let ss = timerEngine.remainingSeconds % 60
            let timeStr = String(format: "%02d:%02d", mm, ss)
            let modeStr: String = {
                switch timerEngine.currentMode {
                case .focus: return "专注中"
                case .shortBreak: return "短休息"
                case .longBreak: return "长休息"
                }
            }()
            Text("\(icon) \(timeStr) \(modeStr)")
        }
        .menuBarExtraStyle(.window)
    }
}
