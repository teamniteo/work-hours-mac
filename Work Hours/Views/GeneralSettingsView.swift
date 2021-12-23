//
//  GeneralSettingsView.swift
//  Work Hours
//
//  Created by Janez Troha on 24/12/2021.
//

import LaunchAtLogin
import SwiftUI

struct GeneralSettingsView: View {
    @ObservedObject private var atLogin = LaunchAtLogin.observable
    
    var body: some View {
        Form {
            Section(
                footer: Text("To enable continuous monitoring and reporting.").font(.footnote)) {
                    VStack(alignment: .leading) {
                        Toggle("Automatically launch on system startup", isOn: $atLogin.isEnabled)
                    }
                }
        }
        
        .frame(width: 350, height: 100).padding(25)
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
