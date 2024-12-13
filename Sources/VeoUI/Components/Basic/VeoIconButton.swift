//
//  VeoIconButton.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoIconButton: View {
    private let icon: String
    private let title: String
    private let action: () -> Void
    private let style: ButtonStyle

    @MainActor
    public struct ButtonStyle {
        let backgroundColor: Color
        let foregroundColor: Color
        let cornerRadius: CGFloat
        let font: Font
        let horizontalPadding: CGFloat
        let verticalPadding: CGFloat

        public static let standard = ButtonStyle(
            backgroundColor: .white.opacity(0.2),
            foregroundColor: .white,
            cornerRadius: 15,
            font: .system(size: 16),
            horizontalPadding: 16,
            verticalPadding: 8)
    }

    public init(
        icon: String,
        title: String,
        style: ButtonStyle = .standard,
        action: @escaping () -> Void)
    {
        self.icon = icon
        self.title = title
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .font(VeoFont.title3())
            }
            .foregroundColor(style.foregroundColor)
            .padding(.horizontal, style.horizontalPadding)
            .padding(.vertical, style.verticalPadding)
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
            .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
        }
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Tajawal-Medium")

    struct VeoIconButtonPreview: View {
        var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Text("English Examples").font(.headline)

                        VeoIconButton(
                            icon: "heart.fill",
                            title: "Like",
                            action: {})

                        VeoIconButton(
                            icon: "star.fill",
                            title: "Favorite",
                            style: VeoIconButton.ButtonStyle(
                                backgroundColor: .yellow.opacity(0.2),
                                foregroundColor: .yellow,
                                cornerRadius: 15,
                                font: .system(size: 16),
                                horizontalPadding: 16,
                                verticalPadding: 8),
                            action: {})

                        VeoIconButton(
                            icon: "trash.fill",
                            title: "Delete",
                            style: VeoIconButton.ButtonStyle(
                                backgroundColor: .red.opacity(0.2),
                                foregroundColor: .red,
                                cornerRadius: 20,
                                font: .system(size: 16, weight: .semibold),
                                horizontalPadding: 20,
                                verticalPadding: 12),
                            action: {})

                        VeoIconButton(
                            icon: "square.and.arrow.up",
                            title: "Share",
                            style: VeoIconButton.ButtonStyle(
                                backgroundColor: .blue.opacity(0.2),
                                foregroundColor: .blue,
                                cornerRadius: 10,
                                font: .system(size: 14),
                                horizontalPadding: 12,
                                verticalPadding: 6),
                            action: {})
                    }

                    Divider()

                    VStack(spacing: 16) {
                        Text("Arabic Examples").font(.headline)

                        VeoIconButton(
                            icon: "heart.fill",
                            title: "إعجاب",
                            action: {})

                        VeoIconButton(
                            icon: "star.fill",
                            title: "المفضلة",
                            style: VeoIconButton.ButtonStyle(
                                backgroundColor: .yellow.opacity(0.2),
                                foregroundColor: .yellow,
                                cornerRadius: 15,
                                font: .system(size: 16),
                                horizontalPadding: 16,
                                verticalPadding: 8),
                            action: {})

                        VeoIconButton(
                            icon: "trash.fill",
                            title: "حذف",
                            style: VeoIconButton.ButtonStyle(
                                backgroundColor: .red.opacity(0.2),
                                foregroundColor: .red,
                                cornerRadius: 20,
                                font: .system(size: 16, weight: .semibold),
                                horizontalPadding: 20,
                                verticalPadding: 12),
                            action: {})

                        VeoIconButton(
                            icon: "square.and.arrow.up",
                            title: "مشاركة",
                            style: VeoIconButton.ButtonStyle(
                                backgroundColor: .blue.opacity(0.2),
                                foregroundColor: .blue,
                                cornerRadius: 10,
                                font: .system(size: 14),
                                horizontalPadding: 12,
                                verticalPadding: 6),
                            action: {})
                    }
                    .environment(\.layoutDirection, .rightToLeft)
                }
            }
        }
    }

    return VeoIconButtonPreview()
}
