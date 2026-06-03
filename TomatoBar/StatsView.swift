//
//  StatsView.swift
//  TomatoBar
//

import SwiftUI
import SwiftData
import Charts

enum StatsPeriod: String, CaseIterable {
    case day = "天"
    case week = "周"
    case month = "月"
}

struct StatsView: View {
    @Query(sort: \TimerSession.startTime, order: .reverse) private var sessions: [TimerSession]
    @State private var selectedPeriod: StatsPeriod = .day

    var body: some View {
        VStack(spacing: 0) {
            summaryCards

            Picker("", selection: $selectedPeriod) {
                ForEach(StatsPeriod.allCases, id: \.self) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.bottom, 8)

            chartView
                .frame(height: 160)
                .padding(.horizontal)

            Divider()
                .padding(.vertical, 8)

            timelineList
        }
        .padding(.vertical)
    }

    // MARK: - Summary Cards

    private var summaryCards: some View {
        HStack(spacing: 16) {
            StatCard(title: "今日番茄", value: "\(todayCount)")
            StatCard(title: "今日时长", value: todayDuration)
            StatCard(title: "本周番茄", value: "\(weekCount)")
        }
        .padding(.horizontal)
        .padding(.bottom, 12)
    }

    private var todayCount: Int {
        sessions.filter { Calendar.current.isDateInToday($0.startTime) && $0.type == "focus" && $0.completed }.count
    }

    private var todayDuration: String {
        let seconds = sessions
            .filter { Calendar.current.isDateInToday($0.startTime) && $0.completed }
            .reduce(0) { $0 + $1.duration }
        let mm = seconds / 60
        return "\(mm) 分钟"
    }

    private var weekCount: Int {
        sessions.filter {
            Calendar.current.isDate($0.startTime, equalTo: Date(), toGranularity: .weekOfYear) && $0.type == "focus" && $0.completed
        }.count
    }

    // MARK: - Chart

    @ViewBuilder
    private var chartView: some View {
        switch selectedPeriod {
        case .day:
            Chart(periodData, id: \.label) { item in
                BarMark(x: .value("", item.label), y: .value("", item.value))
                    .foregroundStyle(.red)
            }
        case .week:
            Chart(periodData, id: \.label) { item in
                BarMark(x: .value("", item.label), y: .value("", item.value))
                    .foregroundStyle(.orange)
            }
        case .month:
            Chart(periodData, id: \.label) { item in
                LineMark(x: .value("", item.label), y: .value("", item.value))
                    .foregroundStyle(.blue)
            }
        }
    }

    private var periodData: [(label: String, value: Int)] {
        let calendar = Calendar.current
        switch selectedPeriod {
        case .day:
            return (0..<24).map { hour in
                let count = sessions.filter {
                    calendar.isDateInToday($0.startTime) && calendar.component(.hour, from: $0.startTime) == hour && $0.type == "focus" && $0.completed
                }.count
                return ("\(hour)", count)
            }
        case .week:
            let weekdaySymbols = ["一", "二", "三", "四", "五", "六", "日"]
            return (0..<7).map { offset in
                let date = calendar.date(byAdding: .day, value: -offset, to: Date())!
                let count = sessions.filter {
                    calendar.isDate($0.startTime, inSameDayAs: date) && $0.type == "focus" && $0.completed
                }.count
                return (weekdaySymbols[6 - offset], count)
            }.reversed()
        case .month:
            return (0..<30).map { offset in
                let date = calendar.date(byAdding: .day, value: -offset, to: Date())!
                let day = calendar.component(.day, from: date)
                let count = sessions.filter {
                    calendar.isDate($0.startTime, inSameDayAs: date) && $0.type == "focus" && $0.completed
                }.count
                return ("\(day)", count)
            }.reversed()
        }
    }

    // MARK: - Timeline

    private var timelineList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(todaySessions) { session in
                    HStack {
                        Circle()
                            .fill(session.completed ? Color.green : Color.gray)
                            .frame(width: 8, height: 8)
                        Text(session.startTime, format: .dateTime.hour().minute())
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(session.duration / 60)m \(session.typeLabel)")
                            .font(.caption)
                        Spacer()
                        Image(systemName: session.completed ? "checkmark" : "xmark")
                            .font(.caption2)
                            .foregroundColor(session.completed ? .green : .gray)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                    Divider().padding(.leading, 24)
                }
                if todaySessions.isEmpty {
                    Text("今日暂无记录")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
        }
        .frame(maxHeight: 120)
    }

    private var todaySessions: [TimerSession] {
        sessions.filter { Calendar.current.isDateInToday($0.startTime) }
    }
}

extension TimerSession {
    var typeLabel: String {
        switch type {
        case "focus": return "专注"
        case "shortBreak": return "短休息"
        case "longBreak": return "长休息"
        default: return type
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(.quaternary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
