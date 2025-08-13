import SwiftUI
import Charts

struct StepCounterView: View {
    @State private var stepCounter = StepCounter()
    @State private var selectedDay: StepData? = nil
    @State private var chartFrame: CGRect = .zero
    @State private var showStepGoal: Bool = false
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .none
        return nf
    }()
    @Binding var stepGoal: Int
    
    var body: some View {
        NavigationStack {
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
                            .trim(from: 0, to: min(CGFloat(stepCounter.steps) / CGFloat(stepGoal), 1.0))
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 200, height: 200)
                            .animation(.easeOut, value: stepCounter.steps)
                        
                        VStack {
                            Text("\(stepCounter.steps)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("of \(stepGoal)")
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
            }  // End of ScrollView
            .onAppear {
                stepCounter.start()
            }
            .onDisappear {
                stepCounter.stop()
            }
            .toolbar {
                Button("Change Step Goal") {
                    showStepGoal.toggle()
                }
            }
            .sheet(isPresented: $showStepGoal) {
                VStack {
                    TextField("Enter your new step goal", value: $stepGoal, formatter: numberFormatter)
                }
            }
        }
    }
}

