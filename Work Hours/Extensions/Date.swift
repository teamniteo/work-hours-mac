//
//  Date.swift
//  Work Hours
//
//  Created by Janez Troha on 23/12/2021.
//
import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

    init(dateString: String) {
        self = Date.iso8601Formatter.date(from: dateString)!
    }

    static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime]
        return formatter
    }()

    static let RFC3339DateFormatter: DateFormatter = {
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return RFC3339DateFormatter
    }()

    static let YearMonthFormatter: DateFormatter = {
        let YearMonthFormatter = DateFormatter()
        YearMonthFormatter.locale = Locale(identifier: "en_US_POSIX")
        YearMonthFormatter.dateFormat = "yyyy-MM"
        YearMonthFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return YearMonthFormatter
    }()

    static let YearMonthDayFormatter: DateFormatter = {
        let YearMonthFormatter = DateFormatter()
        YearMonthFormatter.locale = Locale(identifier: "en_US_POSIX")
        YearMonthFormatter.dateFormat = "yyyy-MM-dd"
        YearMonthFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return YearMonthFormatter
    }()
}

extension TimeInterval {
    func hoursAndMinutes() -> String {
        let diff = Int(self)
        let minutes = (diff / 60) % 60
        let hours = (diff / 3600)

        return String(format: "%0.2d:%0.2d", hours, minutes)
    }

    static func hoursAndMinutes(_ diff: Int) -> String {
        let minutes = (diff / 60) % 60
        let hours = (diff / 3600)

        return String(format: "%0.2dh %0.2dm", hours, minutes)
    }
}
