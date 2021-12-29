//
//  AboutSettingsView.swift
//  Work Hours
//
//  Created by Janez Troha on 24/12/2021.
//
import SwiftUI

struct AboutSettingsView: View {
    @State private var isLoading = false
    @State private var status = UpdateStates.Checking

    enum UpdateStates: String {
        case Checking = "Checking for updates"
        case NewVersion = "New version found"
        case Installing = "Installing new update"
        case Updated = "App is up to date"
        case Failed = "Failed to update, download manualy"
    }

    var body: some View {
        HStack {
            Image("Logo").resizable()
                .aspectRatio(contentMode: .fit)

            VStack(alignment: .leading) {
                Link("Work Hours",
                     destination: URL(string: "https://niteo.co/work-hours-app")!).font(.title)

                VStack(alignment: .leading, spacing: 0) {
                    Text("Version: \(AppInfo.appVersion) - \(AppInfo.buildVersion)")
                    HStack(spacing: 10) {
                        if status == UpdateStates.Failed {
                            HStack(spacing: 0) {
                                Text("Failed to update ")
                                Link("download manually",
                                     destination: URL(string: "https://github.com/niteoweb/work-hours-mac/releases/latest/download/WorkHours.dmg")!)
                            }
                        } else {
                            Text(status.rawValue)
                        }

                        if self.isLoading {
                            ProgressView().frame(width: 5.0, height: 5.0)
                                .scaleEffect(x: 0.5, y: 0.5, anchor: .center)
                        }
                    }
                }

                HStack(spacing: 0) {
                    Text("We’d love to ")
                    Link("hear from you!",
                         destination: URL(string: "https://niteo.co/contact")!)
                }

                HStack(spacing: 0) {
                    Text("Made with ❤️ at ")
                    Link("Niteo",
                         destination: URL(string: "https://niteo.co/about")!)
                }
            }.padding(.leading, 20.0)

        }.frame(width: 350, height: 100).padding(25).onAppear(perform: fetch)
    }

    private func fetch() {
        DispatchQueue.global(qos: .userInitiated).async {
            isLoading = true
            status = UpdateStates.Checking
            let currentVersion = Bundle.main.version
            if let release = try? AppDelegate.updater.getLatestRelease(allowPrereleases: false) {
                isLoading = false
                if currentVersion < release.version {
                    status = UpdateStates.NewVersion
                    if let zipURL = release.assets.filter({ $0.browserDownloadURL.path.hasSuffix(".zip") }).first {
                        status = UpdateStates.Installing
                        isLoading = true

                        let done = AppDelegate.updater.downloadAndUpdate(withAsset: zipURL)
                        if !done {
                            status = UpdateStates.Failed
                            isLoading = false
                        }

                    } else {
                        status = UpdateStates.Updated
                        isLoading = false
                    }
                } else {
                    status = UpdateStates.Updated
                    isLoading = false
                }
            } else {
                status = UpdateStates.Updated
                isLoading = false
            }
        }
    }
}

struct AboutSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutSettingsView()
    }
}
