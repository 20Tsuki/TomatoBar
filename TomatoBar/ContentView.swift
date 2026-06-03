//
//  ContentView.swift
//  TomatoBar
//
//  Created by Layla Garcia on 2026/6/3.
//

import SwiftUI

struct ContentView: View {
    @Environment(TimerEngine.self) private var timerEngine
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            TimerPanelView()
                .tabItem { Text("计时") }
            StatsView()
                .tabItem { Text("统计") }
            SettingsView()
                .tabItem { Text("设置") }
        }
        .frame(width: 320, height: 480)
    }
}
