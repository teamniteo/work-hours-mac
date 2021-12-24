//
//  TimerView.swift
//  Work Hours
//
//  Created by Janez Troha on 19/12/2021.
//

import Defaults
import SwiftUI

struct TimerView: View {
    @ObservedObject var timerModel: TimerModel
    @Environment(\.colorScheme) var colorScheme
    @Default(.statusBarIcon) var statusBarIcon

    var body: some View {
        if timerModel.isRunning {
            ZStack {
                Text(timerModel.display)
                    .foregroundColor(.black.opacity(0.8))
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 4.0)
                    .padding(.vertical, 1.0)
                    .background(.white.opacity(0.8))
                    .cornerRadius(15)

            }.frame(minWidth: 46, idealHeight: 16, alignment: .center).padding(.horizontal, 4.0).padding(.top, 3.0).padding(.bottom, 3.0).transition(.slide)
        } else {
            ZStack {
                // Moves in from leading out, out to trailing edge.
                Image(systemName: statusBarIcon)
                    .resizable()
                    .opacity(0.9)
                    .frame(width: 16, height: 16, alignment: .center)

            }.frame(width: 16, height: 16, alignment: .center).padding(.horizontal, 4.0)
                .padding(.vertical, 2.0)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            TimerView(timerModel: TimerModel()).preferredColorScheme($0)
        }
    }
}

struct TimerView_Previews_Running: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            TimerView(timerModel: TimerModel(isRunning: true)).preferredColorScheme($0)
        }
    }
}
