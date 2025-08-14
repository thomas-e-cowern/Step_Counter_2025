//
//  GoalEditorView.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/14/25.
//

import SwiftUI

struct GoalEditorView: View {
    
    @State var store: StepDataStore
    
    var date: Date
    @State private var goalText = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Daily Step Goal")) {
                    TextField("Enter goal", text: $goalText)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Edit Goal")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let goal = Int(goalText) {
                            store.updateGoal(for: date, to: goal)
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                if let day = store.weeklySteps.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                    goalText = "\(day.goal)"
                }
            }
        }
    }
}

#Preview {
    GoalEditorView(store: <#StepDataStore#>, date: <#Date#>)
}
