//
//  WorkoutStepManager.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/15/25.
//

import Foundation
import HealthKit
import Observation

@Observable
class WorkoutStepManager {
    private let healthStore = HKHealthStore()
    private var query: HKQuery?
    
    var currentSteps: Int = 0
    var isTracking = false
    
    private var startDate: Date?
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, error in
            if let error = error {
                print("HealthKit auth error: \(error.localizedDescription)")
            }
        }
    }
    
    func startTracking() {
        guard !isTracking else { return }
        
        isTracking = true
        startDate = Date()
        currentSteps = 0
        beginLiveStepQuery()
    }
    
    func stopTracking() {
        isTracking = false
        if let query = query {
            healthStore.stop(query)
        }
        query = nil
    }
    
    private func beginLiveStepQuery() {
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount),
              let startDate = startDate else { return }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)
        
        let liveQuery = HKAnchoredObjectQuery(type: stepType,
                                              predicate: predicate,
                                              anchor: nil,
                                              limit: HKObjectQueryNoLimit) { [weak self] _, samples, _, _, _ in
            self?.process(samples)
        }
        
        liveQuery.updateHandler = { [weak self] _, samples, _, _, _ in
            self?.process(samples)
        }
        
        query = liveQuery
        healthStore.execute(liveQuery)
    }
    
    private func process(_ samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else { return }
        
        let steps = samples.reduce(0) { $0 + Int($1.quantity.doubleValue(for: .count())) }
        
        // hop to main actor for UI updates
        Task { @MainActor in
            self.currentSteps += steps
        }
    }
}

