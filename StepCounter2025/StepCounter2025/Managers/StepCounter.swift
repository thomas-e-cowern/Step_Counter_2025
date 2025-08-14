//
//  StepCounter.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/13/25.
//

import SwiftUI
import Observation

@Observable
class StepCounter {
    var steps: Int = 0
    var weeklySteps: [DailyStepData] = []
    
    private var motionManager = StepCounterManager()
    private let healthKitManager = HealthKitManager()
    
    func start() {
        healthKitManager.requestAuthorization { [weak self] authorized in
            if authorized {
                self?.updateStepsFromHealth()
                self?.updateWeeklySteps()
                self?.startLiveUpdates()
            } else {
                print("HealthKit authorization denied.")
            }
        }
    }
    
    private func updateStepsFromHealth() {
        healthKitManager.fetchTodaySteps { [weak self] count in
            self?.steps = Int(count)
        }
    }
    
    private func updateWeeklySteps() {
        healthKitManager.fetchWeeklySteps { [weak self] data in
            self?.weeklySteps = data
        }
    }
    
    private func startLiveUpdates() {
        motionManager.startUpdates { [weak self] liveSteps in
            // Live step count since app start — merge with HealthKit total
            self?.updateStepsFromHealth()
        }
    }
    
    func stop() {
        motionManager.stopUpdates()
    }
}
