import ActivityKit
import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
struct IntervalTimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IntervalTimerAttributes.self) { context in
            LockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 4) {
                        Text("Interval Timer")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                        if context.state.isPaused {
                            Text(formatSeconds(context.state.totalRemainingSeconds))
                                .font(.title2.monospacedDigit().bold())
                            Text("Paused")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        } else if context.state.totalEndDate > Date() {
                            Text(timerInterval: Date.now...context.state.totalEndDate, countsDown: true)
                                .font(.title2.monospacedDigit().bold())
                                .multilineTextAlignment(.center)
                            Text("remaining")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        } else {
                            Text("0:00")
                                .font(.title2.monospacedDigit().bold())
                            Text("Done")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            } compactLeading: {
                Image(systemName: "timer")
                    .foregroundColor(.orange)
            } compactTrailing: {
                if context.state.isPaused {
                    Text(formatSeconds(context.state.totalRemainingSeconds))
                        .font(.caption.monospacedDigit())
                } else if context.state.totalEndDate > Date() {
                    Text(timerInterval: Date.now...context.state.totalEndDate, countsDown: true)
                        .font(.caption.monospacedDigit())
                        .multilineTextAlignment(.center)
                } else {
                    Text("0:00")
                        .font(.caption.monospacedDigit())
                }
            } minimal: {
                Image(systemName: "timer")
                    .foregroundColor(.orange)
            }
        }
    }
}

@available(iOS 16.1, *)
struct LockScreenView: View {
    let context: ActivityViewContext<IntervalTimerAttributes>

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.orange)
                .frame(width: 6)

            VStack(alignment: .leading, spacing: 4) {
                Text("INTERVAL TIMER")
                    .font(.caption.bold())
                    .foregroundColor(.orange)

                if context.state.isPaused {
                    Text(formatSeconds(context.state.totalRemainingSeconds))
                        .font(.title.monospacedDigit().bold())
                } else if context.state.totalEndDate > Date() {
                    Text(timerInterval: Date.now...context.state.totalEndDate, countsDown: true)
                        .font(.title.monospacedDigit().bold())
                        .multilineTextAlignment(.leading)
                } else {
                    Text("0:00")
                        .font(.title.monospacedDigit().bold())
                }

                HStack {
                    if context.state.isPaused {
                        Image(systemName: "pause.fill")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("Paused")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    } else {
                        Image(systemName: "timer")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        if context.state.totalEndDate > Date() {
                            Text("remaining")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Done")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

private func formatSeconds(_ totalSeconds: Int) -> String {
    let minutes = totalSeconds / 60
    let seconds = totalSeconds % 60
    return String(format: "%d:%02d", minutes, seconds)
}
