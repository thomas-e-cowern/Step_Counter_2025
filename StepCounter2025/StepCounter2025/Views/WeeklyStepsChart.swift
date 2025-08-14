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
            }
        }
        .frame(height: 200)
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                }
            }
        }
    }
}
