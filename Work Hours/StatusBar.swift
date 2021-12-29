//
//  MenuBar.swift
//  Work Hours
//
//  Created by Janez Troha on 19/12/2021.
//

import AppKit
import os.log
import SwiftUI

typealias Scheduler = NSBackgroundActivityScheduler

class StatusBarController: NSObject, NSMenuDelegate {
    var statusItem: NSStatusItem!
    var statusItemMenu: NSMenu!
    var timerModel = TimerModel()

    func addSubmenu(withTitle: String, action: Selector?) -> NSMenuItem {
        let item = NSMenuItem(title: withTitle, action: action, keyEquivalent: "")
        item.target = self
        return item
    }

    func fromReports(_ reports: [Report]) -> NSMenu {
        let submenu = NSMenu()
        for report in reports.sorted(by: { $0.timestamp > $1.timestamp }) {
            submenu.addItem(addSubmenu(withTitle: "\(report.timestamp) worked \(report.amount)", action: #selector(copyToPasteboard)))
        }
        return submenu
    }

    func fromReportsToday(_ reports: [Report]) -> NSMenu {
        let submenu = NSMenu()
        for report in reports.sorted(by: { $0.timestamp > $1.timestamp }) {
            submenu.addItem(addSubmenu(withTitle: "Started \(report.timestamp) worked \(report.amount)", action: #selector(copyToPasteboard)))
        }
        return submenu
    }

    @objc func copyToPasteboard() {}

    override
    init() {
        super.init()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItemMenu = NSMenu(title: "WorkHours")
        statusItemMenu.delegate = self
        let button: NSStatusBarButton = statusItem.button!
        let view = NSHostingView(rootView: TimerView(timerModel: timerModel))
        view.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(view)
        button.target = self
        button.isEnabled = true

        // Apply a series of Auto Layout constraints to its view:
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: button.topAnchor),
            view.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            view.widthAnchor.constraint(equalTo: button.widthAnchor),
            view.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])

        statusItem.menu = statusItemMenu

        Scheduler.repeating(withName: "timerUpdater", withInterval: 60) { completion in
            DispatchQueue.main.async {
                self.timerModel.update()
            }
            completion(.finished)
        }
    }

    func showMenu() {
        if let button = statusItem.button {
            _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                button.performClick(nil)
            }
        }
    }

    func updateMenu() {
        statusItemMenu.removeAllItems()
        addApplicationItems()
    }

    func menuDidClose(_: NSMenu) {
        timerModel.update()
    }

    func menuWillOpen(_: NSMenu) {
        updateMenu()
        timerModel.update()
    }

    @objc func toggle() {
        if timerModel.isRunning {
            timerModel.stop()
        } else {
            timerModel.start()
        }
    }

    func addApplicationItems() {
        if !timerModel.isRunning {
            let startItem = NSMenuItem(title: "Start Work", action: #selector(toggle), keyEquivalent: "s")
            startItem.target = self
            statusItemMenu.addItem(startItem)

        } else {
            let changeStart = NSMenuItem(title: "Change Start Time", action: #selector(toggle), keyEquivalent: "c")
            changeStart.target = self
            // statusItemMenu.addItem(changeStart)

            let stopItem = NSMenuItem(title: "Stop Work", action: #selector(toggle), keyEquivalent: "s")
            stopItem.target = self
            statusItemMenu.addItem(stopItem)
        }

        statusItemMenu.addItem(NSMenuItem.separator())
        if let events = Events.getEvents(), events.count > 0 {
            let todayItem = NSMenuItem(title: "Today", action: nil, keyEquivalent: "")
            if let todayReports = Events.generateReport(events: events.filter {
                Calendar.current.isDateInToday($0.startTimestamp) && Calendar.current.isDateInToday($0.endTimestamp)
            }, formatter: Date.HourMinutesFormatter) {
                todayItem.submenu = fromReportsToday(todayReports)
            }
            statusItemMenu.addItem(todayItem)

            let dailyItem = NSMenuItem(title: "Daily Reports", action: nil, keyEquivalent: "")
            if let dailyReports = Events.generateReport(events: events, formatter: Date.YearMonthDayFormatter) {
                dailyItem.submenu = fromReports(dailyReports.suffix(7))
            }
            statusItemMenu.addItem(dailyItem)

            let monthlyItem = NSMenuItem(title: "Monthly Reports", action: nil, keyEquivalent: "")
            if let monthlyReports = Events.generateReport(events: events, formatter: Date.YearMonthFormatter) {
                monthlyItem.submenu = fromReports(monthlyReports.suffix(12))
            }
            statusItemMenu.addItem(monthlyItem)
            statusItemMenu.addItem(NSMenuItem.separator())
        }

        let preferencesItem = NSMenuItem(title: "Preferences", action: #selector(AppDelegate.showPrefs), keyEquivalent: ",")
        preferencesItem.target = NSApp.delegate
        statusItemMenu.addItem(preferencesItem)

        statusItemMenu.addItem(NSMenuItem.separator())
        let quitItem = NSMenuItem(title: "Quit Work Hours", action: #selector(AppDelegate.quitApp), keyEquivalent: "q")
        quitItem.target = NSApp.delegate
        statusItemMenu.addItem(quitItem)
    }
}
