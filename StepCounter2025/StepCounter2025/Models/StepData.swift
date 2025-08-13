//
//  StepData.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/13/25.
//

import Foundation

struct StepData: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
}
