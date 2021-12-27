//
//  Defaults.swift
//  Work Hours
//
//  Created by Janez Troha on 24/12/2021.
//

import Defaults
import Foundation

enum StatusBarIcon: String {
    case deskclock
    case deskclockFill = "deskclock.fill"
    case lanyardcardFill = "lanyardcard.fill"
    case clockArrowCirclepath = "clock.arrow.circlepath"
}

extension Defaults.Keys {
    static let statusBarIcon = Key<String>("statusBarIcon", default: StatusBarIcon.deskclock.rawValue)
    static let stopOnSleep = Key<Bool>("stopOnSleep", default: true)
    static let hideBackground = Key<Bool>("hideBackground", default: false)
}
