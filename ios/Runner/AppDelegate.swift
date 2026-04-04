import UIKit
import Flutter
import ActivityKit

@main
@objc class AppDelegate: FlutterAppDelegate {

    private var currentActivity: Any? = nil

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "live_activity", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "start":
                self?.handleStart(call: call, result: result)
            case "update":
                self?.handleUpdate(call: call, result: result)
            case "stop":
                self?.handleStop(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func handleStart(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard #available(iOS 16.2, *) else {
            result(nil)
            return
        }

        guard let args = call.arguments as? [String: Any],
              let totalEndTimestamp = args["totalEndTimestamp"] as? Int
        else {
            result(nil)
            return
        }

        result(nil)

        Task { @MainActor in
            await self.startActivity(totalEndTimestamp: totalEndTimestamp)
        }
    }

    private func handleUpdate(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard #available(iOS 16.2, *) else {
            result(nil)
            return
        }

        guard let args = call.arguments as? [String: Any],
              let totalEndTimestamp = args["totalEndTimestamp"] as? Int,
              let isPaused = args["isPaused"] as? Bool,
              let totalRemainingSeconds = args["totalRemainingSeconds"] as? Int
        else {
            result(nil)
            return
        }

        result(nil)

        Task { @MainActor in
            await self.updateActivity(
                totalEndTimestamp: totalEndTimestamp,
                isPaused: isPaused,
                totalRemainingSeconds: totalRemainingSeconds
            )
        }
    }

    private func handleStop(result: @escaping FlutterResult) {
        guard #available(iOS 16.2, *) else {
            result(nil)
            return
        }
        result(nil)
        Task { @MainActor in
            await self.stopActivity()
        }
    }

    @available(iOS 16.2, *)
    private func startActivity(totalEndTimestamp: Int) async {
        let totalEndDate = Date(timeIntervalSince1970: Double(totalEndTimestamp) / 1000.0)
        let totalRemainingSeconds = Int(totalEndDate.timeIntervalSinceNow)

        let state = IntervalTimerAttributes.ContentState(
            totalEndDate: totalEndDate,
            isPaused: false,
            totalRemainingSeconds: totalRemainingSeconds
        )

        do {
            let newActivity = try Activity.request(
                attributes: IntervalTimerAttributes(),
                content: .init(state: state, staleDate: nil),
                pushType: nil
            )
            currentActivity = newActivity

            for activity in Activity<IntervalTimerAttributes>.activities {
                if activity.id != newActivity.id {
                    await activity.end(nil, dismissalPolicy: .immediate)
                }
            }
        } catch {
            NSLog("[LiveActivity] Failed to start: \(error)")
            for activity in Activity<IntervalTimerAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            currentActivity = nil
        }
    }

    @available(iOS 16.2, *)
    private func updateActivity(
        totalEndTimestamp: Int,
        isPaused: Bool,
        totalRemainingSeconds: Int
    ) async {
        var activity = currentActivity as? Activity<IntervalTimerAttributes>
        if activity == nil {
            activity = Activity<IntervalTimerAttributes>.activities.first
            if let found = activity { currentActivity = found }
        }
        guard let activity = activity else { return }

        let totalEndDate: Date
        if isPaused {
            totalEndDate = Date.distantFuture
        } else {
            totalEndDate = Date(timeIntervalSince1970: Double(totalEndTimestamp) / 1000.0)
        }

        let state = IntervalTimerAttributes.ContentState(
            totalEndDate: totalEndDate,
            isPaused: isPaused,
            totalRemainingSeconds: totalRemainingSeconds
        )

        await activity.update(.init(state: state, staleDate: nil))
    }

    @available(iOS 16.2, *)
    private func stopActivity() async {
        for activity in Activity<IntervalTimerAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        currentActivity = nil
    }
}
