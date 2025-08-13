//
//  StepCounterView.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/13/25.
//

import SwiftUI
import Charts

struct StepCounterView: View {
    @State private var stepCounter = StepCounter()

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // --- Live Steps Ring ---
                Text("Today's Steps")
                    .font(.title)
                    .fontWeight(.semibold)

                ZStack {
                    Circle()
                        .stroke(Color.blue.opacity(0.3), lineWidth: 20)
                        .frame(width: 200, height: 200)

                    Circle()
                        .trim(from: 0, to: min(CGFloat(stepCounter.steps) / 10000, 1.0))
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 200, height: 200)
                        .animation(.easeOut, value: stepCounter.steps)

                    VStack {
                        Text("\(stepCounter.steps)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("of 10,000")
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                    .frame(height: 100)
                
                // --- Weekly Chart ---
                VStack(alignment: .leading, spacing: 10) {
                    Text("Weekly Steps")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Chart(stepCounter.weeklySteps) { item in
                        BarMark(
                            x: .value("Date", item.date, unit: .day),
                            y: .value("Steps", item.steps)
                        )
                        .foregroundStyle(Color.green.gradient)
                    }
                    .frame(height: 200)
                }
                .padding(.horizontal)
            } // End of VStack
            .padding(.vertical, 50)
        }
        .onAppear {
            stepCounter.start()
        }
        .onDisappear {
            stepCounter.stop()
        }
    }
}

#Preview {
    StepCounterView()
}

