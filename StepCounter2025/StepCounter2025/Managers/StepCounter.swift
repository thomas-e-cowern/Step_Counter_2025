//
//  StepCounter.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/13/25.
//

import SwiftUI
import Observation

@Observable
class StepCounterViewModel {
    var steps: Int = 0
    private var manager = StepCounterManager()

    func start() {
        manager.startUpdates { [weak self] newSteps in
            self?.steps = newSteps
        }
    }

    func stop() {
        manager.stopUpdates()
    }
}
