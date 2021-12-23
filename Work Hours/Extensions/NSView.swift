//
//  NSView.swift
//  Work Hours
//
//  Created by Janez Troha on 19/12/2021.
//

import Foundation
import SwiftUI

class NoInsetHostingView<V>: NSHostingView<V> where V: View {
    override var safeAreaInsets: NSEdgeInsets {
        return .init()
    }
}

extension Image {
    func renderAsImage() -> NSImage? {
        let view = NoInsetHostingView(rootView: self)
        view.setFrameSize(view.fittingSize)
        return view.bitmapImage()
    }
}

public extension NSView {
    func bitmapImage() -> NSImage? {
        guard let rep = bitmapImageRepForCachingDisplay(in: bounds) else {
            return nil
        }

        cacheDisplay(in: bounds, to: rep)

        guard let cgImage = rep.cgImage else {
            return nil
        }

        return NSImage(cgImage: cgImage, size: bounds.size)
    }
}

extension View {
    func renderAsImage() -> NSImage? {
        let view = NoInsetHostingView(rootView: self)
        view.setFrameSize(view.fittingSize)
        return view.bitmapImage()
    }
}
