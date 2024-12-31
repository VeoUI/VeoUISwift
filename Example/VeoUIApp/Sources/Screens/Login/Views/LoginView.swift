//
//  LoginView.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 23/12/2024.
//

import SwiftUI
import VeoUI

struct LoginView: View {
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            PostsView()
        } else {
            VeoLogin(
                appName: "VeoUI App",
                appLogo: "logo",
                title: "Sign In",
                emailPlaceholder: "Your email",
                passwordPlaceholder: "Your Password",
                loginButtonTitle: "Login",
                forgotPasswordButtonTitle: "You forgot your password ?",
                dontHaveAccountButtonTitle: "You don't have an account ? Create one now !",
                onLoginTapped: { email, password in
                    print("Login tapped with email: \(email) and password: \(password)")
                    try await Task.sleep(nanoseconds: 4_000_000_000)
                },
                onRegisterTapped: {
                    print("Register tapped")
                },
                onForgotPasswordTapped: {
                    print("Forgot password tapped")
                },
                onLoginSuccess: {
                    withAnimation {
                        isLoggedIn = true
                    }
                },
                onLoginError: { error in
                    print("Login error: \(error.localizedDescription)")
                })
        }
    }
}

#Preview {
    LoginView()
}
