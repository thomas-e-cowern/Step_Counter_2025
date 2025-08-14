//
//  StepCounter2025Tests.swift
//  StepCounter2025Tests
//
//  Created by Thomas Cowern on 8/14/25.
//

import Testing
import SwiftUI
import SwiftData
@testable import StepCounter2025

struct StepDataStoreTests {
    
    /// Helper: Create an in-memory store for testing
    private func makeInMemoryContext() throws -> ModelContext {
        let container = try ModelContainer(
            for: DailyStepData.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return ModelContext(container)
    }
    
    @Test("Update steps should create an entry")
    func updateStepsCreatesEntry() throws {
        let context = try makeInMemoryContext()
        let store = StepDataStore(modelContext: context)
        
        let date = Date()
        store.updateSteps(for: date, steps: 5000)
        
        #expect(store.weeklySteps.count == 1)
        #expect(store.weeklySteps.first?.steps == 5000)
    }
    
    @Test("Update goal should only change future days")
    func updateGoalOnlyFutureDays() throws {
        let context = try makeInMemoryContext()
        let store = StepDataStore(modelContext: context)
        
        let today = Date()
        let pastDay = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        let futureDay = Calendar.current.date(byAdding: .day, value: 2, to: today)!
        
        store.updateSteps(for: pastDay, steps: 3000)
        store.updateSteps(for: today, steps: 4000)
        store.updateSteps(for: futureDay, steps: 2000)
        
        let newGoal = 12000
        for entry in store.weeklySteps {
            if entry.date >= today {
                store.updateGoal(for: entry.date, goal: newGoal)
            }
        }
        
        let pastEntry = store.weeklySteps.first(where: { Calendar.current.isDate($0.date, inSameDayAs: pastDay) })!
        let futureEntry = store.weeklySteps.first(where: { Calendar.current.isDate($0.date, inSameDayAs: futureDay) })!
        
        #expect(pastEntry.goal != newGoal)
        #expect(futureEntry.goal == newGoal)
    }
    
    @Test("Saving and loading data should persist steps")
    func saveAndLoadData() throws {
        let context = try makeInMemoryContext()
        let store = StepDataStore(modelContext: context)
        
        let date = Date()
        store.updateSteps(for: date, steps: 7500)
        store.loadData()
        
        #expect(store.weeklySteps.contains { $0.steps == 7500 })
    }
}
