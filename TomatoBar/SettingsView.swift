import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configs: [TimerConfiguration]

    private var config: TimerConfiguration {
        if let existing = configs.first {
            return existing
        }
        let new = TimerConfiguration()
        modelContext.insert(new)
        try? modelContext.save()
        return new
    }

    var body: some View {
        Form {
            Section("专注设置") {
                LabeledContent("专注时长: \(config.focusDuration) 分钟") {
                    Slider(value: Binding(
                        get: { Double(config.focusDuration) },
                        set: { config.focusDuration = Int($0) }
                    ), in: 1...120, step: 1)
                }
                LabeledContent("短休息: \(config.shortBreakDuration) 分钟") {
                    Slider(value: Binding(
                        get: { Double(config.shortBreakDuration) },
                        set: { config.shortBreakDuration = Int($0) }
                    ), in: 1...60, step: 1)
                }
                LabeledContent("长休息: \(config.longBreakDuration) 分钟") {
                    Slider(value: Binding(
                        get: { Double(config.longBreakDuration) },
                        set: { config.longBreakDuration = Int($0) }
                    ), in: 1...120, step: 1)
                }
            }

            Section("长休息") {
                Picker("长休息间隔", selection: Binding(
                    get: { config.roundsBeforeLongBreak },
                    set: { config.roundsBeforeLongBreak = $0 }
                )) {
                    ForEach(1...10, id: \.self) { n in
                        Text("\(n) 轮").tag(n)
                    }
                }
            }

            Section("行为") {
                Toggle("自动开始下一轮", isOn: Binding(
                    get: { config.autoStartNext },
                    set: { config.autoStartNext = $0 }
                ))
            }

            Section("提醒") {
                Toggle("通知", isOn: Binding(
                    get: { config.notificationEnabled },
                    set: { config.notificationEnabled = $0 }
                ))
                Toggle("声音", isOn: Binding(
                    get: { config.soundEnabled },
                    set: { config.soundEnabled = $0 }
                ))
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}
