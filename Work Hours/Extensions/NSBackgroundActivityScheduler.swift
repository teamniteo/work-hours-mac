//
//  BackgroundInterval.swift
//  Work Hours
//
//  Created by Janez Troha on 23/12/2021.
//

import Foundation

extension NSBackgroundActivityScheduler {
    static func repeating(withName name: String, withInterval: TimeInterval, _ fn: @escaping (NSBackgroundActivityScheduler.CompletionHandler) -> Void) {
        let activity = NSBackgroundActivityScheduler(identifier: "\(Bundle.main.bundleIdentifier!).\(name)")
        activity.repeats = true
        activity.interval = withInterval
        activity.qualityOfService = .userInteractive
        activity.tolerance = TimeInterval(1)
        activity.schedule { (completion: NSBackgroundActivityScheduler.CompletionHandler) in
            fn(completion)
        }
    }
}
