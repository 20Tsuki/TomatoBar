//
//  TimerPanelView.swift
//  TomatoBar
//

import SwiftUI

struct TimerPanelView: View {
    @Environment(TimerEngine.self) private var timerEngine

    var body: some View {
        Text("计时")
    }
}
