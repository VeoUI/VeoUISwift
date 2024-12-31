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
    var appLogo: String?
    var title = "Login"
    var emailPlaceholder = "Your Email"
    var passwordPlaceholder = "Your Password"
    var loginButtonTitle = "Login"
    var forgotPasswordButtonTitle = "Forgot Password ?"
    var dontHaveAccountButtonTitle = "Don't have an account? Register Now !"
    var showToast: Bool = false
    var pleaseFillInAllFieldsToastMessage = "Please fill in all fields !"

    var onLoginTapped: ((_ email: String, _ password: String) async throws -> Void)?
    var onRegisterTapped: (() -> Void)?
    var onForgotPasswordTapped: (() -> Void)?
    var onLoginSuccess: (() -> Void)?
    var onLoginError: ((Error) -> Void)?
    @State private var currentToast: VeoToastMessage?

    public init(
        appName: String,
        appIcon: VeoIcon? = nil,
        appLogo: String? = nil,
        title: String,
        emailPlaceholder: String,
        passwordPlaceholder: String,
        loginButtonTitle: String,
        forgotPasswordButtonTitle: String,
        dontHaveAccountButtonTitle: String,
        showToast: Bool = false,
        pleaseFillInAllFieldsToastMessage: String = "Please fill in all fields !",
        onLoginTapped: ((_ email: String, _ password: String) async throws -> Void)? = nil,
        onRegisterTapped: (() -> Void)? = nil,
        onForgotPasswordTapped: (() -> Void)? = nil,
        onLoginSuccess: (() -> Void)? = nil,
        onLoginError: ((Error) -> Void)? = nil)
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
        self.showToast = showToast
        self.pleaseFillInAllFieldsToastMessage = pleaseFillInAllFieldsToastMessage
        self.onLoginTapped = onLoginTapped
        self.onRegisterTapped = onRegisterTapped
        self.onForgotPasswordTapped = onForgotPasswordTapped
        self.onLoginSuccess = onLoginSuccess
        self.onLoginError = onLoginError
    }

    public var body: some View {
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

                if let appLogo = appLogo {
                    VeoImage(
                        name: appLogo,
                        maxWidth: 120,
                        maxHeight: 120)
                }

                VeoText(appName, style: .title, color: .white)

                VeoText(title, style: .title2, color: .white)
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
                        Button(action: handleForgotPassword) {
                            VeoText(forgotPasswordButtonTitle, style: .subtitle, color: .white)
                        }
                    }
                    .padding(.top, -10)

                    VeoButton(title: loginButtonTitle,
                              gradientColors: (VeoUI.primaryColor, VeoUI.primaryDarkColor), action: handleLogin)
                        .disabled(isLoading)

                    Button(action: handleRegister) {
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

            if showToast {
                VeoToast(currentToast: $currentToast)
            }
            
            if isLoading {
                VeoLoader()
            }
        }
        .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
    }

    private func handleLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            currentToast = VeoToastMessage(
                message: pleaseFillInAllFieldsToastMessage,
                style: .warning,
                position: .bottom
            )
            return
        }

        withAnimation {
            isLoading = true
        }

        Task {
            do {
                try await onLoginTapped?(email, password)
                await MainActor.run {
                    isLoading = false
                    onLoginSuccess?()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    onLoginError?(error)
                    currentToast = VeoToastMessage(
                        message: error.localizedDescription,
                        style: .error,
                        position: .bottom
                    )
                }
            }
        }
    }

    private func handleRegister() {
        onRegisterTapped?()
    }

    private func handleForgotPassword() {
        onForgotPasswordTapped?()
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        isRTL: true,
        mainFont: "Rubik-Bold")

    struct VeoLoginPreview: View {
        var body: some View {
            VeoLogin(
                appName: "تدويناتي",
                appLogo: "logo",
                title: "تسجيل الدخول",
                emailPlaceholder: "البريد الإلكتروني",
                passwordPlaceholder: "كلمة المرور",
                loginButtonTitle: "دخول",
                forgotPasswordButtonTitle: "نسيت كلمة المرور ؟",
                dontHaveAccountButtonTitle: "ليس لديك حساب ؟ أنشئه الآن",
                showToast: true,
                pleaseFillInAllFieldsToastMessage: "يرجى ملء جميع الحقول المطلوبة !",
                onLoginTapped: { email, password in
                    print("Login tapped with email: \(email) and password: \(password)")
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                },
                onRegisterTapped: {
                    print("Register tapped")
                },
                onForgotPasswordTapped: {
                    print("Forgot password tapped")
                },
                onLoginSuccess: {
                    print("Login successful")
                },
                onLoginError: { error in
                    print("Login error: \(error.localizedDescription)")
                })
        }
    }

    return VeoLoginPreview()
}
