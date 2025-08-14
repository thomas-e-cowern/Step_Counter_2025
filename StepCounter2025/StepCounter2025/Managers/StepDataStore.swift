//
//  StepDataStore.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/14/25.
//

import Foundation
import Observation

@Observable
class StepDataStore {
    bvar weeklySteps: [StepData] = [] {
        didSet { saveData() }
    }

    private let saveKey = "weeklyStepsData"

    init() {
        loadData()
    }

    func updateGoal(for date: Date, to newGoal: Int) {
        if let index = weeklySteps.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            weeklySteps[index].goal = newGoal
        } else {
            weeklySteps.append(StepData(date: date, steps: 0, goal: newGoal))
        }
    }

    private func saveData() {
        if let encoded = try? JSONEncoder().encode(weeklySteps) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([StepData].self, from: data) {
            weeklySteps = decoded
        } else {
            // Initialize with dummy data for testing
            let today = Date()
            weeklySteps = (0..<7).map {
                let date = Calendar.current.date(byAdding: .day, value: -$0, to: today)!
                return StepData(date: date, steps: Int.random(in: 3000...12000), goal: 10000)
            }.reversed()
        }
    }
}
