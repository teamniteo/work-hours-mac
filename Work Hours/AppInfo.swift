//
//  AppInfo.swift
//  Work Hours
//
//  Created by Janez Troha on 24/12/2021.
//

import Foundation
import os.log
import SwiftUI

enum AppInfo {
    static let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    static let buildVersion: String = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    static let machineName: String = Host.current().localizedName!
    static let macOSVersion = ProcessInfo.processInfo.operatingSystemVersion
    static let macOSVersionString = "\(macOSVersion.majorVersion).\(macOSVersion.minorVersion).\(macOSVersion.patchVersion)"
    static var isRunningTests: Bool {
        ProcessInfo.processInfo.arguments.contains("isRunningTests") || ProcessInfo.processInfo.environment["CI"] ?? "false" != "false"
    }
}
