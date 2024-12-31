//
//  VeoRegister.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoRegister: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var currentToast: VeoToastMessage?
    
    var appName: String
    var appIcon: VeoIcon?
    var appLogo: String?
    var title = "Register"
    var fullNamePlaceholder = "Full Name"
    var emailPlaceholder = "Your Email"
    var passwordPlaceholder = "Your Password"
    var confirmPasswordPlaceholder = "Confirm Password"
    var registerButtonTitle = "Register"
    var alreadyHaveAccountButtonTitle = "Already have an account? Login Now!"
    var showToast: Bool = false
    var pleaseFillInAllFieldsToastMessage = "Please fill in all fields!"
    var passwordsDontMatchMessage = "Passwords don't match!"
    
    var onRegisterTapped: ((_ fullName: String, _ email: String, _ password: String) async throws -> Void)?
    var onLoginTapped: (() -> Void)?
    var onRegisterSuccess: (() -> Void)?
    var onRegisterError: ((Error) -> Void)?
    
    public init(
        appName: String,
        appIcon: VeoIcon? = nil,
        appLogo: String? = nil,
        title: String,
        fullNamePlaceholder: String,
        emailPlaceholder: String,
        passwordPlaceholder: String,
        confirmPasswordPlaceholder: String,
        registerButtonTitle: String,
        alreadyHaveAccountButtonTitle: String,
        showToast: Bool = false,
        pleaseFillInAllFieldsToastMessage: String = "Please fill in all fields!",
        passwordsDontMatchMessage: String = "Passwords don't match!",
        onRegisterTapped: ((_ fullName: String, _ email: String, _ password: String) async throws -> Void)? = nil,
        onLoginTapped: (() -> Void)? = nil,
        onRegisterSuccess: (() -> Void)? = nil,
        onRegisterError: ((Error) -> Void)? = nil
    ) {
        self.appName = appName
        self.appIcon = appIcon
        self.appLogo = appLogo
        self.title = title
        self.fullNamePlaceholder = fullNamePlaceholder
        self.emailPlaceholder = emailPlaceholder
        self.passwordPlaceholder = passwordPlaceholder
        self.confirmPasswordPlaceholder = confirmPasswordPlaceholder
        self.registerButtonTitle = registerButtonTitle
        self.alreadyHaveAccountButtonTitle = alreadyHaveAccountButtonTitle
        self.showToast = showToast
        self.pleaseFillInAllFieldsToastMessage = pleaseFillInAllFieldsToastMessage
        self.passwordsDontMatchMessage = passwordsDontMatchMessage
        self.onRegisterTapped = onRegisterTapped
        self.onLoginTapped = onLoginTapped
        self.onRegisterSuccess = onRegisterSuccess
        self.onRegisterError = onRegisterError
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
            
            ScrollView {
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
                            text: $fullName,
                            icon: "person",
                            placeholder: fullNamePlaceholder)
                        
                        VeoTextField(
                            text: $email,
                            icon: "envelope",
                            placeholder: emailPlaceholder)
                        
                        VeoTextField(
                            text: $password,
                            icon: "lock",
                            placeholder: passwordPlaceholder,
                            isSecure: true)
                        
                        VeoTextField(
                            text: $confirmPassword,
                            icon: "lock",
                            placeholder: confirmPasswordPlaceholder,
                            isSecure: true)
                        
                        VeoButton(
                            title: registerButtonTitle,
                            gradientColors: (VeoUI.primaryColor, VeoUI.primaryDarkColor),
                            action: handleRegister)
                            .disabled(isLoading)
                        
                        Button(action: handleLogin) {
                            VeoText(
                                alreadyHaveAccountButtonTitle,
                                style: .subtitle,
                                color: .white.opacity(0.7))
                        }
                        .disabled(isLoading)
                    }
                    .padding(.top, 20)
                }
                .padding(20)
            }
            
            if showToast {
                VeoToast(currentToast: $currentToast)
            }
            
            if isLoading {
                VeoLoader()
            }
        }
        .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
    }
    
    private func handleRegister() {
        guard !fullName.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            currentToast = VeoToastMessage(
                message: pleaseFillInAllFieldsToastMessage,
                style: .warning,
                position: .bottom
            )
            return
        }
        
        guard password == confirmPassword else {
            currentToast = VeoToastMessage(
                message: passwordsDontMatchMessage,
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
                try await onRegisterTapped?(fullName, email, password)
                await MainActor.run {
                    isLoading = false
                    onRegisterSuccess?()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    onRegisterError?(error)
                    currentToast = VeoToastMessage(
                        message: error.localizedDescription,
                        style: .error,
                        position: .bottom
                    )
                }
            }
        }
    }
    
    private func handleLogin() {
        onLoginTapped?()
    }
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        isRTL: true,
        mainFont: "Rubik-Bold")
    
    struct VeoRegisterPreview: View {
        var body: some View {
            VeoRegister(
                appName: "تدويناتي",
                appLogo: "logo",
                title: "إنشاء حساب",
                fullNamePlaceholder: "الاسم الكامل",
                emailPlaceholder: "البريد الإلكتروني",
                passwordPlaceholder: "كلمة المرور",
                confirmPasswordPlaceholder: "تأكيد كلمة المرور",
                registerButtonTitle: "تسجيل",
                alreadyHaveAccountButtonTitle: "لديك حساب بالفعل؟ سجل دخولك الآن",
                showToast: true,
                pleaseFillInAllFieldsToastMessage: "يرجى ملء جميع الحقول المطلوبة !",
                passwordsDontMatchMessage: "كلمات المرور غير متطابقة !",
                onRegisterTapped: { fullName, email, password in
                    print("Register tapped with name: \(fullName), email: \(email)")
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                },
                onLoginTapped: {
                    print("Login tapped")
                },
                onRegisterSuccess: {
                    print("Registration successful")
                },
                onRegisterError: { error in
                    print("Registration error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    return VeoRegisterPreview()
}
