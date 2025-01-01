//
//  OnboardingView.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 23/12/2024.
//

import SwiftUI
import VeoUI

struct OnboardingView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        VeoOnboarding(
            items: [
                .init(
                    title: "This is the first onboarding item title",
                    description: "This is a long description for the first onboarding item to describe it in more detail!",
                    image: "onboarding1"),
                .init(
                    title: "This is the second onboarding item title",
                    description: "This is a long description for the second onboarding item to describe it in more detail!",
                    image: "onboarding2"),
                .init(
                    title: "This is the third onboarding item title",
                    description: "This is a long description for the third onboarding item to describe it in more detail!",
                    image: "onboarding3"),
                .init(
                    title: "This is the fourth onboarding item title",
                    description: "This is a long description for the fourth onboarding item to describe it in more detail!",
                    image: "onboarding4")
            ],
            skipButtonText: "Skip",
            nextButtonText: "Next",
            getStartedButtonText: "Start Now",
            onFinish: {
                // UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                router.navigateTo(.login)
            })
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OnboardingView()
}
