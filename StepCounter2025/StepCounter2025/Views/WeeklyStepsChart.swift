import SwiftUI
import Charts

struct WeeklyStepsChart: View {
    let weeklySteps: [StepData]
    @State private var selectedDay: StepData? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Weekly Steps")
                .font(.title2)
                .fontWeight(.semibold)
            
            Chart(weeklySteps, id: \.id) { item in
                BarMark(
                    x: .value("Date", item.date, unit: .day),
                    y: .value("Steps", item.steps)
                )
                .foregroundStyle(.green)
                .cornerRadius(5)
                .annotation(position: .automatic, spacing: 4) {
                    Text("\(item.steps)")
                        .font(.caption)
                }
            }
            .frame(height: 200)
        }
    }
}
