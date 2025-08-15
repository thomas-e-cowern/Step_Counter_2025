import SwiftUI
import SwiftData

struct StepTrackerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var store: StepDataStore
    @State private var showGoalEditor = false
    
    init(modelContext: ModelContext, mockData: Bool) {
        _store = State(wrappedValue: StepDataStore(modelContext: modelContext, mockData: mockData))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Today's Steps Ring
                if let todayData = store.weeklySteps.first(where: { Calendar.current.isDateInToday($0.date) }) {
                    let progress = min(Double(todayData.steps) / Double(todayData.goal), 1.0)
                    
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(progress >= 1 ? Color.green : Color.blue,
                                    style: StrokeStyle(lineWidth: 20, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut, value: progress)
                        
                        VStack {
                            Text("\(todayData.steps)")
                                .font(.largeTitle)
                                .bold()
                                .accessibilityIdentifier("TodayStepsValue")
                            Text("of \(todayData.goal) steps")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: 180, height: 180)
                    .padding(.top)
                }
                
                Spacer()
                
                // Weekly Chart
                WeeklyStepsChart(store: store)
                
                Spacer()
            }
            .navigationTitle("Weekly Steps")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Set Goal") {
                        showGoalEditor = true
                    }
                    .accessibilityIdentifier("SetGoalButton")
                }
            }
            .sheet(isPresented: $showGoalEditor) {
                GoalEditorView(store: store)
            }
        }
    }
}
