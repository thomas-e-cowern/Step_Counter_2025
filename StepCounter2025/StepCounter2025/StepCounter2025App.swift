//
//  StepCounter2025App.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/13/25.
//

import SwiftUI

@main
struct StepCounter2025App: App {
    
    @State private var newStepGoal: Int = 10000
    
    var body: some Scene {
        WindowGroup {
            StepCounterView(stepGoal: $newStepGoal)
        }
    }
}
