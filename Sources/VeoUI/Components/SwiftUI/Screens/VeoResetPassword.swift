//
//  VeoResetPassword.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 31/12/2024.
//

import SwiftUI

public struct VeoResetPassword: View {
    @State private var email = ""
    @State private var isLoading = false
    @State private var currentToast: VeoToastMessage?
    
    var appName: String
    var appIcon: VeoIcon?
    var appLogo: String?
    var title = "Reset Password"
    var subtitle = "Enter your email address and we'll send you a link to reset your password."
    var emailPlaceholder = "Your Email"
    var resetButtonTitle = "Send Reset Link"
    var backToLoginButtonTitle = "Back to Login"
    var showToast: Bool = false
    var pleaseFillEmailMessage = "Please enter your email!"
    
    var onResetTapped: ((_ email: String) async throws -> Void)?
    var onBackToLoginTapped: (() -> Void)?
    var onResetSuccess: (() -> Void)?
    var onResetError: ((Error) -> Void)?
    
    public init(
        appName: String,
        appIcon: VeoIcon? = nil,
        appLogo: String? = nil,
        title: String,
        subtitle: String,
        emailPlaceholder: String,
        resetButtonTitle: String,
        backToLoginButtonTitle: String,
        showToast: Bool = false,
        pleaseFillEmailMessage: String = "Please enter your email!",
        onResetTapped: ((_ email: String) async throws -> Void)? = nil,
        onBackToLoginTapped: (() -> Void)? = nil,
        onResetSuccess: (() -> Void)? = nil,
        onResetError: ((Error) -> Void)? = nil
    ) {
        self.appName = appName
        self.appIcon = appIcon
        self.appLogo = appLogo
        self.title = title
        self.subtitle = subtitle
        self.emailPlaceholder = emailPlaceholder
        self.resetButtonTitle = resetButtonTitle
        self.backToLoginButtonTitle = backToLoginButtonTitle
        self.showToast = showToast
        self.pleaseFillEmailMessage = pleaseFillEmailMessage
        self.onResetTapped = onResetTapped
        self.onBackToLoginTapped = onBackToLoginTapped
        self.onResetSuccess = onResetSuccess
        self.onResetError = onResetError
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
                
                VStack(spacing: 10) {
                    VeoText(title, style: .title2, color: .white)
                    
                    VeoText(subtitle, style: .body, color: .white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                
                VStack(spacing: 20) {
                    VeoTextField(
                        text: $email,
                        icon: "envelope",
                        placeholder: emailPlaceholder)
                    
                    VeoButton(
                        title: resetButtonTitle,
                        gradientColors: (VeoUI.primaryColor, VeoUI.primaryDarkColor),
                        action: handleReset)
                        .disabled(isLoading)
                    
                    Button(action: handleBackToLogin) {
                        VeoText(
                            backToLoginButtonTitle,
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
    
    private func handleReset() {
        guard !email.isEmpty else {
            currentToast = VeoToastMessage(
                message: pleaseFillEmailMessage,
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
                try await onResetTapped?(email)
                await MainActor.run {
                    isLoading = false
                    onResetSuccess?()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    onResetError?(error)
                    currentToast = VeoToastMessage(
                        message: error.localizedDescription,
                        style: .error,
                        position: .bottom
                    )
                }
            }
        }
    }
    
    private func handleBackToLogin() {
        onBackToLoginTapped?()
    }
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        isRTL: true,
        mainFont: "Rubik-Bold")
    
    struct VeoResetPasswordPreview: View {
        var body: some View {
            VeoResetPassword(
                appName: "تدويناتي",
                appLogo: "logo",
                title: "استعادة كلمة المرور",
                subtitle: "أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور",
                emailPlaceholder: "البريد الإلكتروني",
                resetButtonTitle: "إرسال رابط الاستعادة",
                backToLoginButtonTitle: "العودة لتسجيل الدخول",
                showToast: true,
                pleaseFillEmailMessage: "يرجى إدخال البريد الإلكتروني!",
                onResetTapped: { email in
                    print("Reset password tapped with email: \(email)")
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                },
                onBackToLoginTapped: {
                    print("Back to login tapped")
                },
                onResetSuccess: {
                    print("Reset password email sent successfully")
                },
                onResetError: { error in
                    print("Reset password error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    return VeoResetPasswordPreview()
}
