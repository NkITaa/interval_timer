import ActivityKit
import Foundation

@available(iOS 16.1, *)
struct IntervalTimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var totalEndDate: Date
        var isPaused: Bool
        var totalRemainingSeconds: Int
    }
}
