//
//  VeoOnboarding.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoOnboarding: View {
    public struct OnboardingItem: Identifiable {
        public let id = UUID()
        let title: String
        let description: String
        let image: String

        public init(title: String, description: String, image: String) {
            self.title = title
            self.description = description
            self.image = image
        }
    }

    public enum NavigationStyle {
        case swipe
        case button
        case both
    }

    public enum ButtonAlignment {
        case bottom
        case bottomTrailing
    }

    private let items: [OnboardingItem]
    private let titleFontSize: CGFloat
    private let descriptionFontSize: CGFloat
    private let skipButtonText: String
    private let nextButtonText: String
    private let getStartedButtonText: String
    private let navigationStyle: NavigationStyle
    private let showSkipButton: Bool
    private let showNextButton: Bool
    private let buttonAlignment: ButtonAlignment
    private let onFinish: () -> Void

    @State private var currentPage = 0
    @State private var shouldFinish = false

    @Environment(\.onboardingCompletion) private var onboardingCompletion

    private var currentItem: OnboardingItem {
        items[currentPage]
    }

    private var isLastPage: Bool {
        currentPage == items.count - 1
    }

    private var buttonTitle: String {
        if isLastPage {
            return getStartedButtonText
        }
        return nextButtonText
    }

    private var skipButtonTitle: String {
        skipButtonText
    }

    public init(
        items: [OnboardingItem],
        titleFontSize: CGFloat = 28,
        descriptionFontSize: CGFloat = 20,
        navigationStyle: NavigationStyle = .both,
        skipButtonText: String = "Skip",
        nextButtonText: String = "Next",
        getStartedButtonText: String = "Get Started",
        showSkipButton: Bool = true,
        showNextButton: Bool = true,
        buttonAlignment: ButtonAlignment = .bottom,
        onFinish: @escaping () -> Void = {})
    {
        self.items = items
        self.titleFontSize = titleFontSize
        self.descriptionFontSize = descriptionFontSize
        self.navigationStyle = navigationStyle
        self.skipButtonText = skipButtonText
        self.nextButtonText = nextButtonText
        self.getStartedButtonText = getStartedButtonText
        self.showSkipButton = showSkipButton
        self.showNextButton = showNextButton
        self.buttonAlignment = buttonAlignment
        self.onFinish = onFinish
    }

    public var body: some View {
        ZStack {
            if navigationStyle != .button {
                TabView(selection: $currentPage) {
                    ForEach(0 ..< items.count, id: \.self) { index in
                        pageView
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
            } else {
                pageView
            }

            VStack {
                if showSkipButton {
                    HStack {
                        Spacer()
                        Button(action: skipOnboarding) {
                            VeoText(skipButtonTitle, style: .caption, color: VeoUI.primaryColor)
                        }
                        .padding()
                    }
                }

                Spacer()

                pageIndicators
                    .padding(.bottom, 20)

                if showNextButton {
                    VeoButton(title: buttonTitle, action: nextPage)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
        }
        .onChange(of: shouldFinish) { finished in
            if finished {
                onboardingCompletion?()
                onFinish()
            }
        }
        .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
    }

    private var pageView: some View {
        VStack(spacing: 20) {
            Image(currentItem.image, bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(height: 260)

            VStack(spacing: 20) {
                VeoText(
                    currentItem.title,
                    style: .title,
                    alignment: .center,
                    color: VeoUI.primaryDarkColor)

                VeoText(
                    currentItem.description,
                    style: .subtitle,
                    alignment: .center,
                    color: VeoUI.primaryColor)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
    }

    private var pageIndicators: some View {
        HStack(spacing: 5) {
            ForEach(0 ..< items.count, id: \.self) { index in
                Capsule()
                    .fill(currentPage == index ? VeoUI.primaryColor : Color.gray)
                    .frame(width: currentPage == index ? 24 : 8, height: 8)
                    .animation(.easeInOut, value: currentPage)
            }
        }
    }

    private func nextPage() {
        if currentPage < items.count - 1 {
            currentPage += 1
        } else {
            shouldFinish = true
        }
    }

    private func skipOnboarding() {
        shouldFinish = true
    }
}

private struct OnboardingCompletionKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    var onboardingCompletion: (() -> Void)? {
        get { self[OnboardingCompletionKey.self] }
        set { self[OnboardingCompletionKey.self] = newValue }
    }
}

extension View {
    func onFinishOnboarding(_ action: @escaping () -> Void) -> some View {
        environment(\.onboardingCompletion, action)
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#27ae60"),
        primaryDarkColor: Color(hex: "#2ecc71"),
        isRTL: true,
        mainFont: "Rubik-Bold")

    struct VeoOnboardingPreview: View {
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

        var body: some View {
            VeoOnboarding(
                items: items,
                skipButtonText: "تخطي",
                nextButtonText: "التالي",
                getStartedButtonText: "ابدأ الآن",
                onFinish: {
                    print("Onboarding completed!")
                })
        }
    }

    return VeoOnboardingPreview()
}
