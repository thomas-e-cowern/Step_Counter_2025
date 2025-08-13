import SwiftUI
import Charts

struct StepCounterView: View {
    @State private var stepCounter = StepCounter()
    @State private var selectedDay: StepData? = nil
    @State private var chartFrame: CGRect = .zero
    
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
                
                // --- Weekly Steps Chart ---
                WeeklyStepsChart(weeklySteps: stepCounter.weeklySteps)
            }
            .padding(.vertical)
            .padding(.top, 50)
            .padding(.horizontal)
        }
        .onAppear {
            stepCounter.start()
        }
        .onDisappear {
            stepCounter.stop()
        }
    }
}
