//
//  Calendar.swift
//  Work Hours
//
//  Created by Janez Troha on 23/12/2021.
//

import Foundation

extension Calendar {
    static func isSameYear(_ lcp: Date, _ rcp: Date) -> Bool {
        return Calendar.current.compare(lcp, to: rcp, toGranularity: .year) == .orderedSame
    }
    static func isSameMonth(_ lcp: Date, _ rcp: Date) -> Bool {
        return Calendar.current.compare(lcp, to: rcp, toGranularity: .month) == .orderedSame
    }
    static func isSameDay(_ lcp: Date, _ rcp: Date) -> Bool {
        return Calendar.current.compare(lcp, to: rcp, toGranularity: .day) == .orderedSame
    }
}
