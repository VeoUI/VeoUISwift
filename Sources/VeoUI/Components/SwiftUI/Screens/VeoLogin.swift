//
//  VeoLogin.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoLogin: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showHome = false
    @State private var showRegister = false
    @State private var showForgotPassword = false

    var appName: String
    var appIcon: VeoIcon?
    var appLogo: VeoImage?
    var title = "Login"
    var emailPlaceholder = "Your Email"
    var passwordPlaceholder = "Your Password"
    var loginButtonTitle = "Login"
    var forgotPasswordButtonTitle = "Forgot Password ?"
    var dontHaveAccountButtonTitle = "Don't have an account? Register Now !"

    public init(
        appName: String,
        appIcon: VeoIcon? = nil,
        appLogo: VeoImage? = nil,
        title: String,
        emailPlaceholder: String,
        passwordPlaceholder: String,
        loginButtonTitle: String,
        forgotPasswordButtonTitle: String,
        dontHaveAccountButtonTitle: String)
    {
        self.appName = appName
        self.appIcon = appIcon
        self.appLogo = appLogo
        self.title = title
        self.emailPlaceholder = emailPlaceholder
        self.passwordPlaceholder = passwordPlaceholder
        self.loginButtonTitle = loginButtonTitle
        self.forgotPasswordButtonTitle = forgotPasswordButtonTitle
        self.dontHaveAccountButtonTitle = dontHaveAccountButtonTitle
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        VeoUI.primaryColor,
                        VeoUI.primaryDarkColor
                    ]),
                    startPoint: .top,
                    endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    if let appIcon = appIcon {
                        appIcon
                    }

                    VeoText(appName, style: .title, color: .white)

                    VeoText(title, style: .subtitle, color: .white)
                        .padding(.top, 20)

                    VStack(spacing: 20) {
                        VeoTextField(
                            text: $email,
                            icon: "envelope",
                            placeholder: emailPlaceholder)

                        VeoTextField(
                            text: $password,
                            icon: "lock",
                            placeholder: passwordPlaceholder,
                            isSecure: true)

                        HStack {
                            Spacer()
                            Button(action: {
                                showForgotPassword = true
                            }) {
                                VeoText(forgotPasswordButtonTitle, style: .subtitle, color: .white)
                            }
                        }
                        .padding(.top, -10)

                        VeoButton(title: loginButtonTitle, action: {
                            withAnimation {
                                isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    isLoading = false
                                    showHome = true
                                }
                            }
                        }).disabled(isLoading)

                        Button(action: {
                            showRegister = true
                        }) {
                            VeoText(
                                dontHaveAccountButtonTitle,
                                style: .subtitle,
                                color: .white.opacity(0.7))
                        }
                        .disabled(isLoading)
                    }
                    .padding(.top, 20)
                }
                .padding(20)

                if isLoading {
                    VeoLoader()
                }
            }
            .navigationDestination(isPresented: $showRegister) {
                // RegisterView()
            }
            .navigationDestination(isPresented: $showForgotPassword) {
                // ForgotPasswordView()
            }
        }.environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        isRTL: true,
        mainFont: "Tajawal-Bold")

    struct VeoLoginPreview: View {
        var body: some View {
            VeoLogin(
                appName: "تدويناتي",
                appIcon: VeoIcon(
                    icon: .common(.user),
                    size: 120,
                    color: .white),
                title: "تسجيل الدخول",
                emailPlaceholder: "البريد الإلكتروني",
                passwordPlaceholder: "كلمة المرور",
                loginButtonTitle: "دخول",
                forgotPasswordButtonTitle: "نسيت كلمة المرور ؟",
                dontHaveAccountButtonTitle: "ليس لديك حساب ؟ أنشئه الآن")
        }
    }

    return VeoLoginPreview()
}