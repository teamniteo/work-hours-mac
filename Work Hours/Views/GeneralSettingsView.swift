//
//  GeneralSettingsView.swift
//  Work Hours
//
//  Created by Janez Troha on 24/12/2021.
//

import Defaults
import LaunchAtLogin
import SwiftUI

struct GeneralSettingsView: View {
    @ObservedObject private var atLogin = LaunchAtLogin.observable
    @Default(.statusBarIcon) var statusBarIcon
    @Default(.stopOnSleep) var stopOnSleep

    var body: some View {
        Form {
            Section(
                footer: Text("To enable continuous monitoring and reporting.").font(.footnote)) {
                    VStack(alignment: .leading) {
                        Toggle("Automatically launch on system startup", isOn: $atLogin.isEnabled)
                    }
                }
            Section(
                footer: Text("Stops timer when your mac goes to sleep.").font(.footnote)) {
                    VStack(alignment: .leading) {
                        Toggle("Stop timer on sleep", isOn: $stopOnSleep)
                    }
                }
            Section(
                footer: Text("Your preffered icon in status bar.").font(.footnote)) {
                    VStack(alignment: .leading) {
                        VStack {
                            Picker("Icon", selection: $statusBarIcon, content: { // <2>
                                Image(systemName: StatusBarIcon.deskclock.rawValue).tag(StatusBarIcon.deskclock.rawValue)
                                Image(systemName: StatusBarIcon.deskclockFill.rawValue).tag(StatusBarIcon.deskclockFill.rawValue)
                                Image(systemName: StatusBarIcon.lanyardcardFill.rawValue).tag(StatusBarIcon.lanyardcardFill.rawValue)
                                Image(systemName: StatusBarIcon.clockArrowCirclepath.rawValue).tag(StatusBarIcon.clockArrowCirclepath.rawValue)
                            }).frame(maxWidth: 90)
                        }
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
