//
//  WorkHoursTests.swift
//  Work HoursTests
//
//  Created by Janez Troha on 19/12/2021.
//

import SwiftCSV
@testable import Work_Hours
import XCTest

class WorkHoursTests: XCTestCase {
    func testPerformanceExample() throws {
        do {
            // As a string
            let csv: CSV = try CSV(string: "START,2021-12-23T10:23:49.126424\nEND,2021-12-23T10:26:13.645456", loadColumns: false)
            for line in csv.enumeratedRows {
                print(line)
            }
            // Catch errors from parsing invalid formed CSV
        } catch {
            // Catch errors from trying to load files
        }
    }
}
