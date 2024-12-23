//
//  VeoInfoBanner.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 9/12/2024.
//

import SwiftUI

public struct VeoInfoBanner: View {
    private let icon: String
    private let message: String
    private let style: BannerStyle

    @MainActor
    public struct BannerStyle {
        let backgroundColor: Color
        let foregroundColor: Color
        let cornerRadius: CGFloat
        let font: Font
        let padding: EdgeInsets

        public init(backgroundColor: Color, foregroundColor: Color, cornerRadius: CGFloat, font: Font, padding: EdgeInsets) {
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.cornerRadius = cornerRadius
            self.font = font
            self.padding = padding
        }

        public static let standard = BannerStyle(
            backgroundColor: .blue.opacity(0.4),
            foregroundColor: .white,
            cornerRadius: 12,
            font: VeoFont.caption2(),
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
    }

    public init(
        icon: String,
        message: String,
        style: BannerStyle = .standard)
    {
        self.icon = icon
        self.message = message
        self.style = style
    }

    public var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(style.foregroundColor)
            VeoText(message, style: .subtitle, color: style.foregroundColor)
        }
        .padding(style.padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(style.backgroundColor)
        .cornerRadius(style.cornerRadius)
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Rubik-Bold")

    struct VeoInfoBannerPreview: View {
        var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        VeoInfoBanner(
                            icon: "info.circle",
                            message: "This is an informational message")

                        VeoInfoBanner(
                            icon: "exclamationmark.circle",
                            message: "Warning: Your session will expire soon",
                            style: .init(
                                backgroundColor: .yellow.opacity(0.1),
                                foregroundColor: .yellow,
                                cornerRadius: 12,
                                font: .system(size: 14),
                                padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)))

                        VeoInfoBanner(
                            icon: "xmark.circle",
                            message: "Error occurred while processing your request",
                            style: .init(
                                backgroundColor: .red.opacity(0.1),
                                foregroundColor: .red,
                                cornerRadius: 12,
                                font: .system(size: 14),
                                padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)))

                        VeoInfoBanner(
                            icon: "checkmark.circle",
                            message: "Success! Your changes have been saved",
                            style: .init(
                                backgroundColor: .green.opacity(0.1),
                                foregroundColor: .green,
                                cornerRadius: 12,
                                font: .system(size: 14),
                                padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)))
                    }

                    VStack(spacing: 16) {
                        VeoInfoBanner(
                            icon: "info.circle",
                            message: "هذه رسالة إعلامية")
                            .environment(\.layoutDirection, .rightToLeft)

                        VeoInfoBanner(
                            icon: "exclamationmark.circle",
                            message: "تحذير: ستنتهي جلستك قريبًا",
                            style: .init(
                                backgroundColor: .yellow.opacity(0.1),
                                foregroundColor: .yellow,
                                cornerRadius: 12,
                                font: .system(size: 14),
                                padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)))
                            .environment(\.layoutDirection, .rightToLeft)

                        VeoInfoBanner(
                            icon: "xmark.circle",
                            message: "حدث خطأ أثناء معالجة طلبك",
                            style: .init(
                                backgroundColor: .red.opacity(0.1),
                                foregroundColor: .red,
                                cornerRadius: 12,
                                font: .system(size: 14),
                                padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)))
                            .environment(\.layoutDirection, .rightToLeft)

                        VeoInfoBanner(
                            icon: "checkmark.circle",
                            message: "تم بنجاح! تم حفظ التغييرات الخاصة بك",
                            style: .init(
                                backgroundColor: .green.opacity(0.1),
                                foregroundColor: .green,
                                cornerRadius: 12,
                                font: .system(size: 14),
                                padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)))
                            .environment(\.layoutDirection, .rightToLeft)
                    }
                }.padding()
            }
        }
    }

    return VeoInfoBannerPreview()
}
