//
//  StepDataStore.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/14/25.
//

import Foundation
import HealthKit
import SwiftData
import SwiftUI
import Observation

class StepDataStore {
    var weeklySteps: [DailyStepData] = []
    private let healthStore = HKHealthStore()
    private let modelContext: ModelContext
    private let mockData: Bool
    
    init(modelContext: ModelContext, mockData: Bool = false) {
            self.modelContext = modelContext
            self.mockData = mockData

            if mockData {
                preloadMockData()
            } else {
                requestHealthKitAccess()
                loadData()
                fetchWeeklySteps()
            }
        }
    
    // MARK: - Load from SwiftData
    func loadData() {
        let fetchDescriptor = FetchDescriptor<DailyStepData>(
            sortBy: [SortDescriptor(\.date)]
        )
        if let result = try? modelContext.fetch(fetchDescriptor) {
            weeklySteps = result
        }
    }
    
    // MARK: - Save
    func save() {
        try? modelContext.save()
    }
    
    // MARK: - Update Steps
    func updateSteps(for date: Date, steps: Int) {
        if let index = weeklySteps.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            weeklySteps[index].steps = steps
        } else {
            let defaultGoal = 8000
            let newData = DailyStepData(date: date, steps: steps, goal: defaultGoal)
            modelContext.insert(newData)
            weeklySteps.append(newData)
        }
        save()
    }
    
    // MARK: - Update Goal
    func updateGoal(for date: Date, goal: Int) {
        if let index = weeklySteps.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            weeklySteps[index].goal = goal
        } else {
            let newData = DailyStepData(date: date, steps: 0, goal: goal)
            modelContext.insert(newData)
            weeklySteps.append(newData)
        }
        save()
    }
    
    // MARK: - HealthKit
    private func requestHealthKitAccess() {
        guard !mockData, HKHealthStore.isHealthDataAvailable(),
                      let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, error in
            if success {
                self.fetchWeeklySteps()
            }
        }
    }
    
    private func fetchWeeklySteps() {
        guard !mockData, let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let calendar = Calendar.current
        let now = Date()
        guard let startDate = calendar.date(byAdding: .day, value: -6, to: now) else { return }
        
        var interval = DateComponents()
        interval.day = 1
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: calendar.startOfDay(for: startDate),
            intervalComponents: interval
        )
        
        query.initialResultsHandler = { _, results, _ in
            results?.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                let steps = Int(statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0)
                DispatchQueue.main.async {
                    self.updateSteps(for: statistics.startDate, steps: steps)
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Mock
        private func preloadMockData() {
            let cal = Calendar.current
            let today = cal.startOfDay(for: Date())
            let data: [DailyStepData] = (0..<7).compactMap { offset in
                guard let date = cal.date(byAdding: .day, value: -6 + offset, to: today) else { return nil }
                // Keep goals different per day to verify behavior
                let steps = [3200, 5400, 8800, 12000, 7600, 10100, 4500][offset]
                let goal  = [8000, 9000, 10000, 11000, 8000, 12000, 9500][offset]
                return DailyStepData(date: date, steps: steps, goal: goal)
            }
            data.forEach { modelContext.insert($0) }
            weeklySteps = data
            save()
        }
}
