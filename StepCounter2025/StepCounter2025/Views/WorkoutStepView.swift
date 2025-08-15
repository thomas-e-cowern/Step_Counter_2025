//
//  WorkoutStepView.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/15/25.
//

import SwiftUI
import HealthKit

struct WorkoutStepView: View {
    @State private var workoutManager = WorkoutStepManager()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Workout Step Tracker")
                .font(.title)
                .bold()
            
            Text("\(workoutManager.currentSteps)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.green)
                .accessibilityIdentifier("WorkoutStepCount")
            
            if workoutManager.isTracking {
                Button(role: .destructive) {
                    workoutManager.stopTracking()
                } label: {
                    Label("Stop", systemImage: "stop.circle.fill")
                        .font(.title2)
                }
            } else {
                Button {
                    workoutManager.startTracking()
                } label: {
                    Label("Start", systemImage: "play.circle.fill")
                        .font(.title2)
                }
            }
        }
        .padding()
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}


#Preview {
    WorkoutStepView()
}
