//
//  FileManager.swift
//  Work Hours
//
//  Created by Janez Troha on 23/12/2021.
//

import Foundation

extension FileManager {
    static var documentDirectoryURL: URL {
        let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL
    }
}
