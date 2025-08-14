import SwiftUI
import Charts

struct WeeklyStepsChart: View {
    @State var store: StepDataStore
    @State private var selectedDate: Date?
    
    var body: some View {
        Chart {
            ForEach(store.weeklySteps, id: \.id) { day in
                // Bar for actual steps
                BarMark(
                    x: .value("Date", day.date, unit: .day),
                    y: .value("Steps", day.steps)
                )
                .foregroundStyle(day.steps >= day.goal ? Color.blue : Color.red)
                
                // Goal circle marker with text above
                PointMark(
                    x: .value("Date", day.date, unit: .day),
                    y: .value("Goal", day.goal)
                )
                .symbol(Circle())
                .symbolSize(100) // ~10x10 points
                .foregroundStyle(day.steps >= day.goal ? Color.green : Color.red)
                .annotation(position: .top) {
                    Text("\(day.goal)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(height: 250)
        .padding()
        .accessibilityIdentifier("WeeklyStepsChart")
    }
}
