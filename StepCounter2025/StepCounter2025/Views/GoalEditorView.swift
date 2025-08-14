//
//  GoalEditorView.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/14/25.
//

import SwiftUI

struct GoalEditorView: View {
    @Environment(\.dismiss) var dismiss
    @State var store: StepDataStore
    @State private var newGoal: Int = 8000
    
    var body: some View {
        NavigationView {
            Form {
                Stepper("Daily Goal: \(newGoal)", value: $newGoal, in: 1000...20000, step: 500)
            }
            .navigationTitle("Set Goal")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let today = Date()
                        for index in store.weeklySteps.indices {
                            if store.weeklySteps[index].date >= Calendar.current.startOfDay(for: today) {
                                store.weeklySteps[index].goal = newGoal
                            }
                        }
                        store.save()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

//#Preview {
//    GoalEditorView(store: <#StepDataStore#>, date: <#Date#>)
//}
