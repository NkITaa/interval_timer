//
//  LockscreenController.swift
//  Runner
//
//  Created by Maurice Nikita Reichert on 13.12.23.
//

import ActivityKit
import Flutter
import Foundation

class LiveActivityManager {
    
    private var timer: Timer?
    private var counter = 0
    private var duration = 0
    private var currentSet = 1
    private var indexTime = 0
    private var isPaused = false
    private var time: Array<Int> = []
    private var sets = 0
    private var stopwatchActivity: Activity<LockscreenAttributes>? = nil
    
    func startLiveActivity(data: [String: Any]?, result: FlutterResult) {
        
        let attributes = LockscreenAttributes()
        
        if let info = data as? [String: Any] {
            
            
            time = info["time"] as? Array<Int> ?? []
            sets = info["sets"] as? Int ?? 0
            counter = time[indexTime]
            
            let state = LockscreenAttributes.ContentState(elapsedTime: counter)
            
            stopwatchActivity = try? Activity<LockscreenAttributes>.request(
                attributes: attributes, contentState: state, pushType: nil)
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                
                if (self.counter == 1) {
                    if (self.indexTime == 1 && self.sets == self.currentSet) {
                        self.stopLiveActivity()
                    }
                    if (self.indexTime == 1) {
                        self.currentSet += 1
                    }
                    self.indexTime = self.indexTime == 1 ? 0 : 1
                    self.counter = self.time[self.indexTime]
                    
                    print("indexTime: ", self.indexTime)
                    print("currentSet: ", self.currentSet)
                    print("counter: ", self.counter)
                    print("counter according to timeArray: ", self.time[self.indexTime])
                    
                    
                } else if (self.counter > 0) {
                    self.counter -= 1
                    Task {
                        await self.stopwatchActivity?.update(using: LockscreenAttributes.ContentState(elapsedTime: self.counter))
                    }
                }
            }
        }
    }
    
    func updateLiveActivity(data: [String: Any]?, result: FlutterResult) {
        if let info = data as? [String: Any] {
            
            if (info["counter"] != nil) {
                self.counter = info["counter"] as? Int ?? 0
            }
            if (info["sets"] != nil) {
                self.sets = info["sets"] as? Int ?? 0
            }
            if (info["currentSet"] != nil) {
                self.currentSet = info["currentSet"] as? Int ?? 0
            }
            if (info["indexTime"] != nil) {
                self.indexTime = info["indexTime"] as? Int ?? 0
            }
            if (info["isPaused"] != nil) {
                self.isPaused = (info["isPaused"] as? Int ?? 0) == 1
                if (self.isPaused == true) {
                    if var unwrappedTimer = timer {
                        unwrappedTimer.invalidate()
                        timer = nil
                    }
                }
                else {
                    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                
                                // executes when the counter is one
                                if (self.counter == 1) {
                                    
                                    // when the
                                    if (self.indexTime == 1 && self.sets == self.currentSet) {
                                        self.stopLiveActivity()
                                    }
                                    if (self.indexTime == 1) {
                                        self.currentSet += 1
                                    }
                                    self.indexTime = self.indexTime == 1 ? 0 : 1
                                    self.counter = self.time[self.indexTime]
                                } else if (self.counter > 0) {
                                    self.counter -= 1
                                    Task {
                                        await self.stopwatchActivity?.update(using: LockscreenAttributes.ContentState(elapsedTime: self.counter))
                                    }
                                }
                            }
                        
                }
            }
            
        }
    }
    
    func stopLiveActivity() {
        Task {
            await stopwatchActivity?.end(using: nil, dismissalPolicy: .immediate)
        }
        if let unwrappedTimer = self.timer {
            unwrappedTimer.invalidate()
            self.timer = nil
        }
    }
}
