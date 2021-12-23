//
//  AboutSettingsView.swift
//  Work Hours
//
//  Created by Janez Troha on 24/12/2021.
//
import SwiftUI

struct AboutSettingsView: View {
    @State private var isLoading = false

    var body: some View {
        HStack {
            Image("Logo").resizable()
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading) {
                Link("Work Hours",
                     destination: URL(string: "https://niteo.co/work-hours-app")!).font(.title)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Version: \(AppInfo.appVersion) - \(AppInfo.buildVersion)")
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
            }
            
        }.frame(width: 350, height: 100).padding(25)
    }
    
}

struct AboutSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutSettingsView()
    }
}
