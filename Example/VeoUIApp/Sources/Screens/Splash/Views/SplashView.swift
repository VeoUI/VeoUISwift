//
//  SplashView.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 23/12/2024.
//

import SwiftUI
import VeoUI

struct SplashView: View {
    @State private var isSplash = true

    var body: some View {
        if isSplash {
            VeoSplash(
                title: "VeoUI App",
                appLogo: "logo")
                .onAppear {
                    startSplashTimer()
                }
        } else {
            OnboardingView()
        }
    }

    func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSplash = false
        }
    }
}

#Preview {
    SplashView()
}
