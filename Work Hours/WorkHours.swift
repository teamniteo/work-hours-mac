//
//  WorkHoursApp.swift
//  Work Hours
//
//  Created by Janez Troha on 19/12/2021.
//

import SwiftUI

import Cocoa
import Defaults
import os.log
import SwiftUI

extension NSWorkspace {
    static func onWakeup(_ fn: @escaping (Notification) -> Void) {
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didWakeNotification,
                                                          object: nil,
                                                          queue: nil,
                                                          using: fn)
    }

    static func onSleep(_ fn: @escaping (Notification) -> Void) {
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.willSleepNotification,
                                                          object: nil,
                                                          queue: nil,
                                                          using: fn)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var welcomeWindow: NSWindow?
    var statusBar: StatusBarController?

    func applicationWillFinishLaunching(_: Notification) {}

    func applicationDidFinishLaunching(_: Notification) {
        // disable any other code if in preview mode
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return
        }

        statusBar = StatusBarController()
        statusBar?.updateMenu()

        NSWorkspace.onSleep { _ in
            if Defaults[.stopOnSleep] {
                self.statusBar?.timerModel.stop()
            }
        }
    }

    func application(_: NSApplication, open urls: [URL]) {
        for url in urls {
            processAction(url)
        }
    }

    func processAction(_: URL) {}

    @objc func showPrefs() {
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(self)
    }
}

@main
struct WorkHoursApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            SettingsView(selected: SettingsView.Tabs.general)
        }
    }
}
