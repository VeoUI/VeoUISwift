//
//  LoginView.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 23/12/2024.
//

import SwiftUI
import VeoUI

struct LoginView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
            VeoLogin(
                appName: "VeoUI App",
                appLogo: "logo",
                title: "Sign In",
                emailPlaceholder: "Your email",
                passwordPlaceholder: "Your Password",
                loginButtonTitle: "Login",
                forgotPasswordButtonTitle: "You forgot your password ?",
                dontHaveAccountButtonTitle: "You don't have an account ? Create one now !",
                showToast: true,
                pleaseFillInAllFieldsToastMessage: "Please fill in all fields !",
                onLoginTapped: { email, password in
                    print("Login tapped with email: \(email) and password: \(password)")
                    try await Task.sleep(nanoseconds: 4_000_000_000)
                },
                onRegisterTapped: {
                    router.navigateTo(.register)
                },
                onForgotPasswordTapped: {
                    router.navigateTo(.resetPassword)
                },
                onLoginSuccess: {
                    withAnimation {
                        router.navigateTo(.home)
                    }
                },
                onLoginError: { error in
                    print("Login error: \(error.localizedDescription)")
                })
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView()
}
