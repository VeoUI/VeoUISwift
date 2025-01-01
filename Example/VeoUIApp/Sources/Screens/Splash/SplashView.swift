//
//  SplashView.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 23/12/2024.
//

import SwiftUI
import VeoUI

struct SplashView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
            VeoSplash(
                title: "VeoUI App",
                appLogo: "logo")
                .onAppear {
                    startSplashTimer()
                }
    }

    func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            router.navigateTo(.onboarding)
        }
    }
}

#Preview {
    SplashView()
}
