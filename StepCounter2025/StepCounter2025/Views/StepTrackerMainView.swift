//
//  StepTrackerMainView.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/15/25.
//

import SwiftUI
import SwiftData

struct StepTrackerMainView: View {
    @State private var showingWorkout = false
    @State private var showingGoalEditor = false
    @Environment(\.modelContext) private var context
    @Query(sort: \StepEntry.date, order: .forward) private var stepEntries: [StepEntry]
    
    @StateObject private var healthKitManager = HealthKitManager()
    
    private var today: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    var todayEntry: StepEntry? {
        stepEntries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) })
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Today’s Step Count Circle
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                    
                    Circle()
                        .trim(from: 0, to: min(Double(healthKitManager.currentSteps) / Double(todayEntry?.goal ?? 10000), 1))
                        .stroke(
                            (Double(healthKitManager.currentSteps) >= Double(todayEntry?.goal ?? 10000) ? Color.green : Color.blue),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut, value: healthKitManager.currentSteps)
                    
                    Text("\(healthKitManager.currentSteps)")
                        .font(.largeTitle.bold())
                }
                .frame(width: 200, height: 200)
                
                // Weekly Chart
                WeeklyStepsChartView(entries: stepEntries, today: today)
                    .frame(height: 200)
                
                Spacer()
                
                // Start Workout Button
                Button {
                    showingWorkout = true
                } label: {
                    Label("Start Workout", systemImage: "figure.walk")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
            .padding()
            .navigationTitle("Steps")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingGoalEditor = true
                    } label: {
                        Label("Edit Goal", systemImage: "pencil")
                    }
                }
            }
            .sheet(isPresented: $showingWorkout) {
                WorkoutStepsView()
            }
            .sheet(isPresented: $showingGoalEditor) {
                EditGoalView(stepEntry: todayEntry ?? StepEntry(date: today, steps: 0, goal: 10000))
                    .presentationDetents([.fraction(0.4)])
            }
            .onAppear {
                healthKitManager.requestAuthorization()
                healthKitManager.fetchTodaySteps()
            }
        }
    }
}


#Preview {
    StepTrackerMainView()
}
