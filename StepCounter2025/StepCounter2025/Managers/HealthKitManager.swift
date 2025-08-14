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

extension HealthKitManager {
    func fetchWeeklySteps(completion: @escaping ([DailyStepData]) -> Void) {
        let now = Date()
        let calendar = Calendar.current
        guard let startDate = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now)) else { return }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: calendar.startOfDay(for: now),
            intervalComponents: interval
        )

        query.initialResultsHandler = { _, results, _ in
            var stepDataArray: [DailyStepData] = []
            results?.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                let steps = statistics.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
                stepDataArray.append(DailyStepData(date: statistics.startDate, steps: Int(steps), goal: 0))
            }
            DispatchQueue.main.async {
                completion(stepDataArray)
            }
        }

        healthStore.execute(query)
    }
}
