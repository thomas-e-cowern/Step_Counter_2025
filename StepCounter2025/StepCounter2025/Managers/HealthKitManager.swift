//
//  HealthKitManager.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/13/25.
//

import Foundation
import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()
    let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let typesToRead: Set = [stepType]
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            DispatchQueue.main.async {
                completion(success && error == nil)
            }
        }
    }

    func fetchTodaySteps(completion: @escaping (Double) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let count = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
            DispatchQueue.main.async {
                completion(count)
            }
        }
        healthStore.execute(query)
    }
}

