//
//  RegisterView.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 1/1/2025.
//

import SwiftUI
import VeoUI

struct RegisterView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        VeoRegister(
            appName: "App Name",
            appLogo: "logo",
            title: "Create Account",
            fullNamePlaceholder: "Full Name",
            emailPlaceholder: "Email",
            passwordPlaceholder: "Password",
            confirmPasswordPlaceholder: "Confirm Password",
            registerButtonTitle: "Register",
            alreadyHaveAccountButtonTitle: "Already have an account? Login now",
            showToast: true,
            pleaseFillInAllFieldsToastMessage: "Please fill in all required fields!",
            passwordsDontMatchMessage: "Passwords don't match!",
            onRegisterTapped: { fullName, email, password in
                print("Register tapped with name: \(fullName), email: \(email)")
                try await Task.sleep(nanoseconds: 2_000_000_000)
            },
            onLoginTapped: {
                router.pop()
            },
            onRegisterSuccess: {
                router.pop()
            },
            onRegisterError: { error in
                print("Registration error: \(error.localizedDescription)")
            }
        )
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RegisterView()
}
