import SwiftUI
import Charts

struct WeeklyStepsChart: View {
    @State var store: StepDataStore
    @State private var selectedDate: Date?
    
    var body: some View {
        Chart {
            ForEach(store.weeklySteps, id: \.id) { day in
                BarMark(
                    x: .value("Date", day.date, unit: .day),
                    y: .value("Steps", day.steps)
                )
                .foregroundStyle(day.steps >= day.goal ? Color.green : Color.blue)
                
                RuleMark(y: .value("Goal", day.goal))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(.red)
            }
        }
        .frame(height: 200)
        .padding()
        .accessibilityIdentifier("WeeklyStepsChart") // <— for UI tests
    }
}
