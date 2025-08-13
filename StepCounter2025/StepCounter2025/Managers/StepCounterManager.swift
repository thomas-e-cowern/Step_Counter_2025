//
//  StepCounterManager.swift
//  StepCounter2025
//
//  Created by Thomas Cowern on 8/13/25.
//

import Foundation
import CoreMotion

class StepCounterManager {
    private let pedometer = CMPedometer()

    func startUpdates(stepUpdate: @escaping (Int) -> Void) {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting not available on this device.")
            return
        }

        pedometer.startUpdates(from: Date()) { data, error in
            DispatchQueue.main.async {
                if let steps = data?.numberOfSteps.intValue {
                    stepUpdate(steps)
                }
            }
        }
    }

    func stopUpdates() {
        pedometer.stopUpdates()
    }
}
