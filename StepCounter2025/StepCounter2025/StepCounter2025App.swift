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
    
    // In-memory or on-disk container (on-disk for app, in-memory for tests)
        var sharedModelContainer: ModelContainer = {
            let schema = Schema([DailyStepData.self])
            // Default on-disk config for real app
            return try! ModelContainer(for: schema)
        }()
    
    var body: some Scene {
        WindowGroup {
            let mockMode = CommandLine.arguments.contains("UI_TEST_MODE")
            StepTrackerBoot(mockMode: mockMode)
        }
        .modelContainer(sharedModelContainer)
    }
}

struct StepTrackerBoot: View {
    @Environment(\.modelContext) private var modelContext
    let mockMode: Bool

    var body: some View {
        StepTrackerView(modelContext: modelContext, mockData: mockMode)
    }
}
