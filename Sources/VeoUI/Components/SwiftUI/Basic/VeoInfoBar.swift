//
//  VeoInfoBar.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoInfoBar: View {
    private let icon: String
    private let text: String
    private let actionTitle: String
    private let action: () -> Void
    private let style: InfoBarStyle

    @MainActor
    public struct InfoBarStyle {
        let backgroundColor: Color
        let textColor: Color
        let actionTextColor: Color
        let iconColor: Color
        let cornerRadius: CGFloat
        let padding: EdgeInsets
        let font: Font
        let actionFont: Font
        
        public init(backgroundColor: Color, textColor: Color, actionTextColor: Color, iconColor: Color, cornerRadius: CGFloat, padding: EdgeInsets, font: Font, actionFont: Font) {
            self.backgroundColor = backgroundColor
            self.textColor = textColor
            self.actionTextColor = actionTextColor
            self.iconColor = iconColor
            self.cornerRadius = cornerRadius
            self.padding = padding
            self.font = font
            self.actionFont = actionFont
        }

        public static let standard = InfoBarStyle(
            backgroundColor: .white.opacity(0.1),
            textColor: .white,
            actionTextColor: .white,
            iconColor: .white,
            cornerRadius: 12,
            padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16),
            font: .body,
            actionFont: VeoFont.caption2())
    }

    public init(
        icon: String,
        text: String,
        actionTitle: String,
        action: @escaping () -> Void,
        style: InfoBarStyle = .standard)
    {
        self.icon = icon
        self.text = text
        self.actionTitle = actionTitle
        self.action = action
        self.style = style
    }

    public var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(style.iconColor)

            Text(text)
                .foregroundColor(style.textColor)
                .font(style.font)

            Spacer()

            Button(action: action) {
                Text(actionTitle)
                    .foregroundColor(style.actionTextColor)
                    .font(style.actionFont)
            }
        }
        .padding(style.padding)
        .background(style.backgroundColor)
        .cornerRadius(style.cornerRadius)
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Rubik-Regular")

    struct VeoInfoBarPreview: View {
        var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        VeoInfoBar(
                            icon: "bell.fill",
                            text: "You have new notifications",
                            actionTitle: "View",
                            action: {})

                        VeoInfoBar(
                            icon: "exclamationmark.triangle",
                            text: "Your subscription is expiring soon",
                            actionTitle: "Renew",
                            action: {},
                            style: .init(
                                backgroundColor: .yellow.opacity(0.1),
                                textColor: .yellow,
                                actionTextColor: .yellow,
                                iconColor: .yellow,
                                cornerRadius: 12,
                                padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16),
                                font: .body,
                                actionFont: .headline))

                        VeoInfoBar(
                            icon: "xmark.circle",
                            text: "Failed to sync your data",
                            actionTitle: "Retry",
                            action: {},
                            style: .init(
                                backgroundColor: .red.opacity(0.1),
                                textColor: .red,
                                actionTextColor: .red,
                                iconColor: .red,
                                cornerRadius: 12,
                                padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16),
                                font: .body,
                                actionFont: .headline))

                        VeoInfoBar(
                            icon: "gift.fill",
                            text: "Special offer available",
                            actionTitle: "Claim",
                            action: {},
                            style: .init(
                                backgroundColor: .green.opacity(0.1),
                                textColor: .green,
                                actionTextColor: .green,
                                iconColor: .green,
                                cornerRadius: 12,
                                padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16),
                                font: .body,
                                actionFont: .headline))
                    }

                    VStack(spacing: 16) {
                        VeoInfoBar(
                            icon: "bell.fill",
                            text: "لديك إشعارات جديدة",
                            actionTitle: "عرض",
                            action: {})
                            .environment(\.layoutDirection, .rightToLeft)

                        VeoInfoBar(
                            icon: "exclamationmark.triangle",
                            text: "اشتراكك سينتهي قريباً",
                            actionTitle: "تجديد",
                            action: {},
                            style: .init(
                                backgroundColor: .yellow.opacity(0.1),
                                textColor: .yellow,
                                actionTextColor: .yellow,
                                iconColor: .yellow,
                                cornerRadius: 12,
                                padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16),
                                font: .body,
                                actionFont: .headline))
                            .environment(\.layoutDirection, .rightToLeft)

                        VeoInfoBar(
                            icon: "xmark.circle",
                            text: "فشل في مزامنة بياناتك",
                            actionTitle: "إعادة المحاولة",
                            action: {},
                            style: .init(
                                backgroundColor: .red.opacity(0.1),
                                textColor: .red,
                                actionTextColor: .red,
                                iconColor: .red,
                                cornerRadius: 12,
                                padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16),
                                font: .body,
                                actionFont: .headline))
                            .environment(\.layoutDirection, .rightToLeft)

                        VeoInfoBar(
                            icon: "gift.fill",
                            text: "عرض خاص متاح",
                            actionTitle: "احصل عليه",
                            action: {},
                            style: .init(
                                backgroundColor: .green.opacity(0.1),
                                textColor: .green,
                                actionTextColor: .green,
                                iconColor: .green,
                                cornerRadius: 12,
                                padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16),
                                font: .body,
                                actionFont: .headline))
                            .environment(\.layoutDirection, .rightToLeft)
                    }
                }
                .padding()
                .background(Color.black)
            }
        }
    }

    return VeoInfoBarPreview()
}
