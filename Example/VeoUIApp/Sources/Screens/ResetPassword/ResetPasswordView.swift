//
//  ResetPasswordView.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 1/1/2025.
//

import SwiftUI
import VeoUI

struct ResetPasswordView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        VeoResetPassword(
            appName: "App Name",
            appLogo: "logo",
            title: "Reset Password",
            subtitle: "Enter your email and we'll send you a password reset link",
            emailPlaceholder: "Email",
            resetButtonTitle: "Send Reset Link",
            backToLoginButtonTitle: "Back to Login",
            showToast: true,
            pleaseFillEmailMessage: "Please enter your email!",
            onResetTapped: { email in
                print("Reset password tapped with email: \(email)")
                try await Task.sleep(nanoseconds: 2_000_000_000)
            },
            onBackToLoginTapped: {
                router.pop()
            },
            onResetSuccess: {
                print("Reset password email sent successfully")
            },
            onResetError: { error in
                print("Reset password error: \(error.localizedDescription)")
            }
        )
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ResetPasswordView()
}
