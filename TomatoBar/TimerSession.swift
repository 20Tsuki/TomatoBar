import Foundation
import SwiftData

@Model
final class TimerSession {
    var startTime: Date
    var endTime: Date
    var type: String
    var duration: Int
    var completed: Bool

    init(
        startTime: Date,
        endTime: Date,
        type: String,
        duration: Int,
        completed: Bool
    ) {
        self.startTime = startTime
        self.endTime = endTime
        self.type = type
        self.duration = duration
        self.completed = completed
    }
}
