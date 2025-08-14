//
//  StepCounter2025App.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/13/25.
//

import SwiftUI
import SwiftData

@main
struct StepCounter2025App: App {
    
    var sharedModelContainer: ModelContainer = {
            let schema = Schema([DailyStepData.self])
            let config = ModelConfiguration(schema: schema)
            return try! ModelContainer(for: schema, configurations: [config])
        }()
    
    var body: some Scene {
        WindowGroup {
            StepCounterView()
                .modelContainer(sharedModelContainer)
        }
    }
}
