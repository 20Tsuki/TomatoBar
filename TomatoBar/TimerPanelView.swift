import SwiftUI
import SwiftData

struct TimerPanelView: View {
    @Environment(TimerEngine.self) private var timerEngine
    @Query private var configs: [TimerConfiguration]

    private var config: TimerConfiguration? { configs.first }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text(timerEngine.remainingSeconds.formattedTimer)
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundColor(timerEngine.state == .finished ? .green : .primary)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(spacing: 16) {
                if timerEngine.state == .idle {
                    Button(action: startAction) {
                        Label(startButtonLabel, systemImage: "play.fill")
                            .frame(minWidth: 80)
                    }
                    .buttonStyle(.borderedProminent)
                }

                if timerEngine.state == .running {
                    Button(action: { timerEngine.pause() }) {
                        Label("暂停", systemImage: "pause.fill")
                            .frame(minWidth: 80)
                    }
                    .buttonStyle(.bordered)
                }

                if timerEngine.state == .paused {
                    Button(action: { timerEngine.resume() }) {
                        Label("继续", systemImage: "play.fill")
                            .frame(minWidth: 80)
                    }
                    .buttonStyle(.borderedProminent)
                }

                if timerEngine.state == .running || timerEngine.state == .paused {
                    Button(action: { timerEngine.skip() }) {
                        Label("跳过", systemImage: "forward.end.fill")
                            .frame(minWidth: 80)
                    }
                    .buttonStyle(.bordered)
                }
            }

            if timerEngine.state == .finished {
                Button(action: { timerEngine.start() }) {
                    Label(nextButtonLabel, systemImage: "play.fill")
                        .frame(minWidth: 80)
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            if let config = config {
                timerEngine.configure(
                    focusDuration: config.focusDuration,
                    shortBreakDuration: config.shortBreakDuration,
                    longBreakDuration: config.longBreakDuration,
                    roundsBeforeLongBreak: config.roundsBeforeLongBreak,
                    autoStartNext: config.autoStartNext
                )
            }
        }
    }

    private var subtitle: String {
        let modeStr: String = {
            switch timerEngine.currentMode {
            case .focus: return "专注"
            case .shortBreak: return "短休息"
            case .longBreak: return "长休息"
            }
        }()
        let roundInfo: String = {
            if let config = config {
                return " · 第 \(timerEngine.currentRound)/\(config.roundsBeforeLongBreak) 轮"
            }
            return ""
        }()
        return "\(modeStr)\(roundInfo)"
    }

    private var startButtonLabel: String {
        "开始专注"
    }

    private var nextButtonLabel: String {
        switch timerEngine.currentMode {
        case .focus: return "开始专注"
        case .shortBreak: return "开始休息"
        case .longBreak: return "开始长休息"
        }
    }

    private func startAction() {
        if let config = config {
            timerEngine.configure(
                focusDuration: config.focusDuration,
                shortBreakDuration: config.shortBreakDuration,
                longBreakDuration: config.longBreakDuration,
                roundsBeforeLongBreak: config.roundsBeforeLongBreak,
                autoStartNext: config.autoStartNext
            )
        }
        timerEngine.start()
    }
}

extension Int {
    var formattedTimer: String {
        let mm = self / 60
        let ss = self % 60
        return String(format: "%02d:%02d", mm, ss)
    }
}
