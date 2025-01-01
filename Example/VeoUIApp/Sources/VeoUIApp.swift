//
//  VeoUIApp.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI
import VeoUI

@main
struct VeoUIApp: App {
    @StateObject private var appRouter = AppRouter()
    
    init() {
        
        NetworkInterceptor.setupDefaultMocks()
        NetworkInterceptor.register()
        URLSession.configureForMocking()
        
        VeoUI.configure(
            primaryColor: Color(hex: "#f53d1b"),
            primaryDarkColor: Color(hex: "#c6062e"),
            mainFont: "BalsamiqSans-Bold")
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appRouter.navigationPath) {
                SplashView()
                    .navigationDestination(for: AppRouter.Destination.self) { destination in
                        switch destination {
                        case .login:
                            LoginView()
                        case .register:
                            RegisterView()
                        case .resetPassword:
                            ResetPasswordView()
                        case .onboarding:
                            OnboardingView()
                        case .home:
                            PostsView()
                        }
                    }
            }
            .environmentObject(appRouter)
            .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
        }
    }
}
