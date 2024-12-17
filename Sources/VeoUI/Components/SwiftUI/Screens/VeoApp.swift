//
//  VeoApp.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoApp<HomeView: View>: View {
    private let title: String
    private let splash: VeoSplash?
    private let onboarding: VeoOnboarding?
    private let login: VeoLogin?
    private let home: HomeView

    @State private var currentScreen: AppScreen = .splash
    @State private var hasSeenOnboarding = false

    private enum AppScreen {
        case splash
        case onboarding
        case login
        case home
    }

    public init(
        title: String,
        splash: VeoSplash? = nil,
        onboarding: VeoOnboarding? = nil,
        login: VeoLogin? = nil,
        home: HomeView)
    {
        self.title = title
        self.splash = splash
        self.onboarding = onboarding
        self.login = login
        self.home = home

        if splash == nil {
            _currentScreen = State(initialValue: onboarding != nil ? .onboarding : .home)
        }
    }

    public var body: some View {
        Group {
            switch currentScreen {
            case .splash:
                if let splash = splash {
                    splash
                        .onAppear {
                            startSplashTimer()
                        }
                }

            case .onboarding:
                if let onboarding = onboarding {
                    onboarding
                        .onFinishOnboarding {
                            moveToNextScreen()
                        }
                }

            case .login:
                if let login = login {
                    login
                    /* .onLoginSuccess {
                         moveToNextScreen()
                     } */
                }

            case .home:
                home
            }
        }
    }

    private func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            moveToNextScreen()
        }
    }

    private func moveToNextScreen() {
        switch currentScreen {
        case .splash:
            currentScreen = onboarding != nil && !hasSeenOnboarding ? .onboarding : .home

        case .onboarding:
            hasSeenOnboarding = true
            currentScreen = login != nil ? .login : .home

        case .login:
            currentScreen = .home

        case .home:
            break
        }
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#27ae60"),
        primaryDarkColor: Color(hex: "#2ecc71"),
        isRTL: true,
        mainFont: "Rubik-Bold")

    let items: [VeoOnboarding.OnboardingItem] = [
        .init(
            title: "هذا هو عنوان العنصر التمهيدي الأول",
            description: "هذا هو أول وصف طويل للعنصر التمهيدي لوصفه بشكل أكثر تفصيلاً!",
            image: "onboarding1"),
        .init(
            title: "هذا هو عنوان العنصر التمهيدي الأول",
            description: "هذا هو أول وصف طويل للعنصر التمهيدي لوصفه بشكل أكثر تفصيلاً!",
            image: "onboarding2"),
        .init(
            title: "هذا هو عنوان العنصر التمهيدي الأول",
            description: "هذا هو أول وصف طويل للعنصر التمهيدي لوصفه بشكل أكثر تفصيلاً!",
            image: "onboarding3"),
        .init(
            title: "هذا هو عنوان العنصر التمهيدي الأول",
            description: "هذا هو أول وصف طويل للعنصر التمهيدي لوصفه بشكل أكثر تفصيلاً!",
            image: "onboarding4")
    ]

    return VeoApp(
        title: "تدويناتي",
        splash: VeoSplash(
            title: "تدويناتي",
            iconName: "person.circle"),

        onboarding: VeoOnboarding(
            items: items,
            skipButtonText: "تخطي",
            nextButtonText: "التالي",
            getStartedButtonText: "ابدأ الآن"),

        login: VeoLogin(
            appName: "تدويناتي",
            appIcon: VeoIcon(
                icon: .common(.user),
                size: 120,
                color: .white),
            title: "تسجيل الدخول",
            emailPlaceholder: "البريد الإلكتروني", passwordPlaceholder: "كلمة المرور",
            loginButtonTitle: "دخول",
            forgotPasswordButtonTitle: "نسيت كلمة المرور ؟",
            dontHaveAccountButtonTitle: "ليس لديك حساب ؟ أنشئه الآن"),
        home: EmptyView())
}
