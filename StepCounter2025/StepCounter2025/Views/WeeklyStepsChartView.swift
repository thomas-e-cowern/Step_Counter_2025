//
//  WeeklyStepsChartView.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/15/25.
//

import SwiftUI
import Charts

struct WeeklyStepsChartView: View {
    let entries: [StepEntry]
    let today: Date
    
    var last7Days: [StepEntry] {
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: today)!
        return entries.filter { $0.date >= startDate }
    }
    
    var body: some View {
        Chart {
            ForEach(last7Days, id: \.id) { entry in
                BarMark(
                    x: .value("Date", entry.date, unit: .day),
                    y: .value("Steps", entry.steps)
                )
                .foregroundStyle(entry.steps >= entry.goal ? Color.green : Color.blue)
                
                // Circle marker above bar
                PointMark(
                    x: .value("Date", entry.date, unit: .day),
                    y: .value("Steps", entry.steps)
                )
                .foregroundStyle(Color.red)
                .symbolSize(80)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel(date.formatted(.dateTime.weekday(.abbreviated)))
                }
            }
        }
    }
}


#Preview {
    WeeklyStepsChartView()
}
