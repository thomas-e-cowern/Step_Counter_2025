//
//  StepData.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/13/25.
//

import Foundation
import SwiftData

@Model
class DailyStepData {
    var id: UUID
    var date: Date
    var steps: Int
    var goal: Int
    
    init(date: Date, steps: Int, goal: Int) {
        self.id = UUID()
        self.date = date
        self.steps = steps
        self.goal = goal
    }
}
