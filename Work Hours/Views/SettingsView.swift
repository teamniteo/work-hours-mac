//
//  SettingsView.swift
//  Work Hours
//
//  Created by Janez Troha on 24/12/2021.
//

import SwiftUI
import AppKit


struct SettingsView: View {
    @State var selected: Tabs
    enum Tabs: Hashable {
        case general, about
    }
    
    var body: some View {
        TabView(selection: $selected) {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            AboutSettingsView()
                .tabItem {
                    Label("About", systemImage: "info")
                }
                .tag(Tabs.about)
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView(selected: SettingsView.Tabs.general)
        }
    }
}
