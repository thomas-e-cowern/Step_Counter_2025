//
//  WorkoutStepsView.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/15/25.
//

import SwiftUI

struct WorkoutStepsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var workoutManager = WorkoutStepManager()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Workout Step Tracker")
                .font(.largeTitle)
                .bold()
            
            Text("\(workoutManager.currentSteps)")
                .font(.system(size: 72, weight: .bold))
                .foregroundColor(.green)
            
            HStack {
                Button {
                    workoutManager.startWorkout
                } label: {
                    Label("Start", systemImage: "play.fill")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                
                Button {
                    workoutManager.stopWorkout()
                    dismiss()
                } label: {
                    Label("Stop", systemImage: "stop.fill")
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
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
