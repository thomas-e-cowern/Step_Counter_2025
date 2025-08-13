//
//  StepCounterView.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/13/25.
//

import SwiftUI

struct StepCounterView: View {
    @State private var stepCounter = StepCounter()

    var body: some View {
        VStack(spacing: 30) {
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

            Button(action: {
                stepCounter.steps = 0
            }) {
                Text("Reset")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            stepCounter.start()
        }
        .onDisappear {
            stepCounter.stop()
        }
    }
}

