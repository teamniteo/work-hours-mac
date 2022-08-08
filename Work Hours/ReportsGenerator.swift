//
//  ReportsGenerator.swift
//  Work Hours
//
//  Created by Janez Troha on 23/12/2021.
//

import Cocoa
import Foundation
import os.log
import SwiftCSV

extension Date {
    func convertToLocalTime(fromTimeZone timeZoneAbbreviation: String) -> Date? {
        if let timeZone = TimeZone(abbreviation: timeZoneAbbreviation) {
            let targetOffset = TimeInterval(timeZone.secondsFromGMT(for: self))
            let localOffset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))

            return addingTimeInterval(targetOffset + localOffset)
        }

        return nil
    }
}

enum Action: String {
    case start = "START"
    case stop = "END"
}

struct Report {
    let timestamp: String
    let amount: String

    static func fromData(_ data: [String: Int]) -> [Report] {
        var reports = [Report]()
        for (timestamp, duration) in data {
            // skip if less than a minute
            if duration < 60 {
                continue
            }

            reports.append(Report(timestamp: timestamp, amount: TimeInterval.hoursAndMinutes(duration)))
        }
        return reports.sorted(by: { $0.timestamp < $1.timestamp })
    }
}

struct Event {
    let startTimestamp: Date
    let endTimestamp: Date

    var elapsedSeconds: Int {
        Int(endTimestamp.timeIntervalSince(startTimestamp))
    }
}

enum Events {
    static var logFile: URL? {
        let docURL = URL(string: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)!
        let dataPath = docURL.appendingPathComponent("MyWorkHours")
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                os_log("%", error.localizedDescription)
            }
        }
        return FileManager.documentDirectoryURL.appendingPathComponent("MyWorkHours").appendingPathComponent("log.csv")
    }

    static func write(_ action: Action, _ timestamp: Date) {
        guard let logFile = logFile else {
            return
        }

        let data = "\(action.rawValue),\(Date.ISO8601DateFormatter.string(from: timestamp))\n"

        if FileManager.default.fileExists(atPath: logFile.path) {
            os_log("Appending %s to %s", data, logFile.path)
            if let fileHandle = try? FileHandle(forWritingTo: logFile.absoluteURL) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data.data(using: .utf8)!)
                fileHandle.closeFile()
            }
        } else {
            os_log("Writing %s to %s", data, logFile.path)
            try? "action,timestamp\n\(data)".write(to: logFile.absoluteURL, atomically: true, encoding: .utf8)
        }
    }

    // Restore last state from event source
    static func isRunning() -> Date? {
        guard let logFile = logFile else {
            return nil
        }

        if FileManager.default.fileExists(atPath: logFile.path) {
            guard let csvFile: CSV = try? CSV(url: logFile, loadColumns: false) else {
                return nil
            }
            guard let lastLine = csvFile.enumeratedRows.last else {
                return nil
            }
            if lastLine[0] == Action.start.rawValue {
                let timestamp = lastLine[1]
                return Date(dateString: timestamp)
            }
            return nil
        }
        return nil
    }

    static func generateReport(events: [Event], formatter: DateFormatter) -> [Report]? {
        os_log("Start, generateReport")
        var data: [String: Int] = [:]
        for event in events {
            let key = formatter.string(from: event.startTimestamp)
            os_log("Elapsed %s, %s > %d", event.startTimestamp.debugDescription, event.endTimestamp.debugDescription, event.elapsedSeconds)
            if let val = data[key] {
                data[key] = event.elapsedSeconds + val
            } else {
                data[key] = event.elapsedSeconds
            }
        }
        return Report.fromData(data)
    }

    static func getEvents() -> [Event]? {
        os_log("Start, getEvents")

        var events = [Event]()

        guard let logFile = logFile else {
            return nil
        }
        if FileManager.default.fileExists(atPath: logFile.path) {
            guard let CSVFile: CSV = try? CSV(url: logFile) else {
                return nil
            }
            var startTimestamp: Date?
            var endTimestamp: Date?
            var prevEvent: String?

            for line in CSVFile.enumeratedRows {
                // XOR for event filtering, when there is data corruption
                if prevEvent == nil {
                    prevEvent = line[0]
                } else {
                    // Ignore if we have same event multiple times
                    if prevEvent == Action.start.rawValue, line[0] == Action.start.rawValue {
                        os_log("Duplicate start, skipping")
                        continue
                    }
                    if prevEvent == Action.stop.rawValue, line[0] == Action.stop.rawValue {
                        os_log("Duplicate stop, skipping")
                        continue
                    }
                    // update last event
                    prevEvent = line[0]
                }

                switch line[0] {
                case Action.start.rawValue:
                    startTimestamp = Date(dateString: line[1]).convertToLocalTime(fromTimeZone: "UTC")
                case Action.stop.rawValue:
                    endTimestamp = Date(dateString: line[1]).convertToLocalTime(fromTimeZone: "UTC")
                default:
                    os_log("Unknown line %s", line)
                    return nil
                }

                // Got both actions
                if startTimestamp != nil, endTimestamp != nil {
                    events.append(Event(startTimestamp: startTimestamp!, endTimestamp: endTimestamp!))
                    startTimestamp = nil
                    endTimestamp = nil
                }
            }
            return events
        }
        return nil
    }
}
