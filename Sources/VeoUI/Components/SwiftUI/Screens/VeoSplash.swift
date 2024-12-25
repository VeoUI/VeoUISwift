//
//  VeoSplash.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoSplash: View {
    @State private var isActive = false
    @State private var fadeOpacity = 0.0
    @State private var scale = 0.5

    let backgroundGradient: [Color]
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    let iconName: String?
    let appLogo: String?
    let iconSize: CGSize?
    let title: String
    let titleSize: CGFloat
    let titleColor: Color
    let fadeAnimationDuration: Double
    let springAnimationDuration: Double
    let springDampingFraction: Double
    let springBlendDuration: Double
    let screenDuration: Double
    let spacing: CGFloat

    public init(
        title: String,
        backgroundGradient: [Color] = [
            VeoUI.primaryColor,
            VeoUI.primaryDarkColor
        ],
        startPoint: UnitPoint = .top,
        endPoint: UnitPoint = .bottom,
        iconName: String? = nil,
        iconSize: CGSize = CGSize(width: 140, height: 140),
        appLogo: String? = nil,
        titleSize: CGFloat = 68,
        titleColor: Color = .white,
        fadeAnimationDuration: Double = 1.0,
        springAnimationDuration: Double = 1.0,
        springDampingFraction: Double = 0.5,
        springBlendDuration: Double = 1.0,
        screenDuration: Double = 3,
        spacing: CGFloat = 20)
    {
        self.title = title
        self.backgroundGradient = backgroundGradient
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.iconName = iconName
        self.iconSize = iconSize
        self.appLogo = appLogo
        self.titleSize = titleSize
        self.titleColor = titleColor
        self.fadeAnimationDuration = fadeAnimationDuration
        self.springAnimationDuration = springAnimationDuration
        self.springDampingFraction = springDampingFraction
        self.springBlendDuration = springBlendDuration
        self.screenDuration = screenDuration
        self.spacing = spacing
    }

    public var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: backgroundGradient),
                startPoint: startPoint,
                endPoint: endPoint)
                .ignoresSafeArea()

            VStack(spacing: spacing) {
                if let appLogo = appLogo {
                    VeoImage(name: appLogo,
                             maxWidth: 120,
                             maxHeight: 120)
                } else {
                    if let iconName = iconName,
                       let iconSize = iconSize{
                        Image(systemName: iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: iconSize.width,
                                height: iconSize.height)
                            .foregroundColor(titleColor)
                    }
                }
                VeoText(title, style: .title, color: .white)
            }
            .opacity(fadeOpacity)
            .scaleEffect(scale)
        }
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        withAnimation(.easeIn(duration: fadeAnimationDuration)) {
            fadeOpacity = 1.0
        }

        withAnimation(.spring(
            response: springAnimationDuration,
            dampingFraction: springDampingFraction,
            blendDuration: springBlendDuration))
        {
            scale = 1.0
        }
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        isRTL: true,
        mainFont: "Rubik-Bold")

    return VeoSplash(
        title: "تدويناتي",
        iconName: "person.circle")
}
