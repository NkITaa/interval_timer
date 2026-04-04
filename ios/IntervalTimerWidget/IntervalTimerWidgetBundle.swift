import SwiftUI
import WidgetKit

@main
struct IntervalTimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.1, *) {
            IntervalTimerLiveActivity()
        }
    }
}
