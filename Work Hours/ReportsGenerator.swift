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

enum Action: String {
    case start = "START"
    case stop = "END"
}

struct Report {
    let timestamp: String
    let amount: String
    
    static func fromData(_ data: [String:Int])->[Report]{
        var reports = [Report]()
        for (ts, duration) in data {
            reports.append(Report(timestamp: ts, amount: TimeInterval.hoursAndMinutes(duration)))
        }
        return reports
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
        
        let data = "\(action.rawValue),\(timestamp.ISO8601Format())\n"
        
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
            guard let csvFile: CSV = try? CSV(url: logFile, loadColumns:false) else {
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
    
    static func generateReport(formatter: DateFormatter) -> [Report]? {
        var data:[String:Int] = [:]
        guard let logFile = logFile else {
            return nil
        }
        if FileManager.default.fileExists(atPath: logFile.path) {
            guard let csvFile: CSV = try? CSV(url: logFile) else {
                return nil
            }
            var startTimestamp: Date?
            var endTimestamp: Date?
            for line in csvFile.enumeratedRows {
                switch line[0] {
                case Action.start.rawValue:
                    startTimestamp = Date(dateString: line[1])
                case Action.stop.rawValue:
                    endTimestamp = Date(dateString: line[1])
                default:
                    os_log("Unknown line %s", line)
                    return nil
                }
                
                // corrupted data
                if startTimestamp != nil, endTimestamp != nil {
                    // same day, TODO: remove once we are ok with current state of parsing
                    //if formatter.string(from: startTimestamp!) == formatter.string(from: endTimestamp!) {
                        let elapsed = Int(endTimestamp!.timeIntervalSince(startTimestamp!))
                        let key = formatter.string(from: startTimestamp!)
                        if let val = data[key] {
                            data[key] = elapsed + val
                        }else{
                            data[key] = elapsed
                        }
                        startTimestamp = nil
                        endTimestamp = nil
                    //}else {
                    //    return nil
                    //}
                }
            }
            return Report.fromData(data)
        }
        return nil
        
    }
}
