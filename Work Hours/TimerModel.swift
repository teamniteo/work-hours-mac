//
//  TimerModel.swift
//  Work Hours
//
//  Created by Janez Troha on 23/12/2021.
//

import Cocoa
import Foundation
import os.log
import SwiftCSV

class TimerModel: ObservableObject {
    @Published var display: String = "00:00"
    @Published var isRunning: Bool
    @Published var startTime: Date!
    @Published var endTime: Date!

    init(isRunning _: Bool = false) {
        isRunning = Events.isRunning() != nil
        if isRunning {
            startTime = Events.isRunning()
            os_log("Setting time to: %s", startTime.description)
            update()
        }
    }

    func stop() {
        if Events.isRunning() != nil {
            endTime = Date()
            isRunning = false
            Events.write(Action.stop, endTime)
            update()
        }
    }

    func start() {
        if Events.isRunning() == nil {
            startTime = Date()
            isRunning = true
            Events.write(Action.start, startTime)
            update()
        }
    }

    func update() {
        if startTime != nil {
            let diff = Date() - startTime
            display = diff.hoursAndMinutes()
        }
    }
}
