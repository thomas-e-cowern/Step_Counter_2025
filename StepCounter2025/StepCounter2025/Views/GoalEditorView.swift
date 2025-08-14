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
                    Stepper("Daily Goal: \(newGoal)", value: $newGoal, in: 1_000...30_000, step: 500)
                }
                .navigationTitle("Set Goal")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            store.updateGoal(for: Date(), goal: newGoal)
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
                .onAppear {
                    if let today = store.weeklySteps.first(where: { Calendar.current.isDateInToday($0.date) }) {
                        newGoal = today.goal
                    }
                }
            }
        }
    }

//#Preview {
//    GoalEditorView(store: <#StepDataStore#>, date: <#Date#>)
//}
