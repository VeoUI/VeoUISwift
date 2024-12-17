//
//  VeoAlert.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoAlert: View {
    public struct AlertContent {
        let icon: AlertIcon
        let title: String
        let message: String
        let primaryButton: AlertButton
        let secondaryButton: AlertButton?

        public init(
            icon: AlertIcon,
            title: String,
            message: String,
            primaryButton: AlertButton,
            secondaryButton: AlertButton? = nil)
        {
            self.icon = icon
            self.title = title
            self.message = message
            self.primaryButton = primaryButton
            self.secondaryButton = secondaryButton
        }
    }

    public struct AlertIcon {
        let systemName: String
        let color: Color
        let backgroundColor: Color
        let size: CGSize

        public static func system(
            name: String,
            color: Color = .red,
            backgroundColor: Color? = nil,
            size: CGSize = CGSize(width: 40, height: 40))
            -> AlertIcon
        {
            AlertIcon(
                systemName: name,
                color: color,
                backgroundColor: backgroundColor ?? color.opacity(0.1),
                size: size)
        }
    }

    public struct AlertButton {
        let title: String
        let style: ButtonStyle
        let action: () -> Void

        @MainActor
        public struct ButtonStyle {
            let backgroundColor: Color?
            let foregroundColor: Color
            let font: Font
            let cornerRadius: CGFloat
            let padding: EdgeInsets

            public static let primary = ButtonStyle(
                backgroundColor: .red,
                foregroundColor: .white,
                font: .system(size: 16, weight: .bold),
                cornerRadius: 25,
                padding: EdgeInsets(top: 12, leading: 32, bottom: 12, trailing: 32))

            public static let secondary = ButtonStyle(
                backgroundColor: nil,
                foregroundColor: .gray,
                font: .system(size: 16),
                cornerRadius: 25,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))

            public init(backgroundColor: Color?, foregroundColor: Color, font: Font, cornerRadius: CGFloat, padding: EdgeInsets) {
                self.backgroundColor = backgroundColor
                self.foregroundColor = foregroundColor
                self.font = font
                self.cornerRadius = cornerRadius
                self.padding = padding
            }
        }

        public init(
            title: String,
            style: ButtonStyle,
            action: @escaping () -> Void)
        {
            self.title = title
            self.style = style
            self.action = action
        }
    }

    @MainActor
    public struct AlertStyle {
        let backgroundColor: Color
        let cornerRadius: CGFloat
        let padding: EdgeInsets
        let spacing: CGFloat
        let titleFont: Font
        let messageFont: Font
        let backdropColor: Color

        public static let standard = AlertStyle(
            backgroundColor: .white,
            cornerRadius: 20,
            padding: EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24),
            spacing: 16,
            titleFont: .system(size: 22, weight: .bold),
            messageFont: .system(size: 16),
            backdropColor: Color.black.opacity(0.4))
    }

    @Binding private var isPresented: Bool
    private let content: AlertContent
    private let style: AlertStyle

    public init(
        isPresented: Binding<Bool>,
        content: AlertContent,
        style: AlertStyle = .standard)
    {
        _isPresented = isPresented
        self.content = content
        self.style = style
    }

    public var body: some View {
        ZStack {
            style.backdropColor
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }

            VStack(spacing: style.spacing) {
                Circle()
                    .fill(content.icon.backgroundColor)
                    .frame(width: 72, height: 72)
                    .overlay(
                        Image(systemName: content.icon.systemName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: content.icon.size.width, height: content.icon.size.height)
                            .foregroundColor(content.icon.color))

                Text(content.title)
                    .font(VeoFont.title2())
                    .multilineTextAlignment(.center)

                Text(content.message)
                    .font(VeoFont.subheadline())
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                HStack(spacing: 16) {
                    if let secondaryButton = content.secondaryButton {
                        Button(action: secondaryButton.action) {
                            Text(secondaryButton.title)
                                .font(secondaryButton.style.font)
                                .foregroundColor(secondaryButton.style.foregroundColor)
                                .padding(secondaryButton.style.padding)
                                .background(secondaryButton.style.backgroundColor)
                                .clipShape(RoundedRectangle(cornerRadius: secondaryButton.style.cornerRadius))
                        }
                    }

                    Button(action: content.primaryButton.action) {
                        Text(content.primaryButton.title)
                            .font(content.primaryButton.style.font)
                            .foregroundColor(content.primaryButton.style.foregroundColor)
                            .padding(content.primaryButton.style.padding)
                            .background(content.primaryButton.style.backgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: content.primaryButton.style.cornerRadius))
                    }
                }
            }
            .padding(style.padding)
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(style.backgroundColor)
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 2))
            .padding(.horizontal, 24)
            .frame(maxWidth: UIScreen.main.bounds.width - 48)
        }
        .transition(.opacity.combined(with: .scale))
        .zIndex(999)
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        secondaryColor: Color(hex: "#3498db"),
        infoColor: Color(hex: "#2ecc71"),
        warningColor: Color(hex: "#f1c40f"),
        dangerColor: Color(hex: "#e74c3c"),
        tertiaryColor: Color(hex: "#9b59b6"),
        mainFont: "Rubik-Bold")

    struct VeoAlertButtonPreview: View {
        @State private var showSuccessAlert = false
        @State private var showErrorAlert = false
        @State private var showWarningAlert = false
        @State private var showInfoAlert = false

        var body: some View {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        Group {
                            Text("Success Alert").font(.headline)
                            VeoButton(title: "Show Success Alert") {
                                showSuccessAlert = true
                            }
                        }

                        Divider()

                        Group {
                            Text("Error Alert").font(.headline)
                            VeoButton(
                                title: "Show Error Alert",
                                style: .danger)
                            {
                                showErrorAlert = true
                            }
                        }

                        Divider()

                        Group {
                            Text("Warning Alert").font(.headline)
                            VeoButton(
                                title: "Show Warning Alert",
                                style: .warning)
                            {
                                showWarningAlert = true
                            }
                        }

                        Divider()

                        Group {
                            Text("Info Alert").font(.headline)
                            VeoButton(
                                title: "Show Info Alert",
                                style: .info)
                            {
                                showInfoAlert = true
                            }
                        }
                    }
                    .padding()
                }

                if showSuccessAlert {
                    VeoAlert(
                        isPresented: $showSuccessAlert,
                        content: VeoAlert.AlertContent(
                            icon: .system(
                                name: "checkmark",
                                color: .green,
                                backgroundColor: Color.green.opacity(0.1)),
                            title: "Success!",
                            message: "Your action has been completed successfully.",
                            primaryButton: VeoAlert.AlertButton(
                                title: "OK",
                                style: .init(
                                    backgroundColor: .green,
                                    foregroundColor: .white,
                                    font: .system(size: 16, weight: .bold),
                                    cornerRadius: 25,
                                    padding: EdgeInsets(top: 12, leading: 32, bottom: 12, trailing: 32)))
                            {
                                showSuccessAlert = false
                            }))
                }

                if showErrorAlert {
                    VeoAlert(
                        isPresented: $showErrorAlert,
                        content: .init(
                            icon: .system(
                                name: "xmark",
                                color: .red,
                                backgroundColor: Color.red.opacity(0.1)),
                            title: "خطأ",
                            message: "حدث خطأ ما. يرجى المحاولة مرة أخرى.",
                            primaryButton: .init(
                                title: "إعادة المحاولة",
                                style: .primary)
                            {
                                showErrorAlert = false
                            },
                            secondaryButton: .init(
                                title: "إلغاء",
                                style: .secondary)
                            {
                                showErrorAlert = false
                            }))
                }

                if showWarningAlert {
                    VeoAlert(
                        isPresented: $showWarningAlert,
                        content: VeoAlert.AlertContent(
                            icon: .system(
                                name: "exclamationmark.triangle",
                                color: .orange,
                                backgroundColor: Color.orange.opacity(0.1)),
                            title: "Warning",
                            message: "This action cannot be undone. Are you sure you want to continue?",
                            primaryButton: VeoAlert.AlertButton(
                                title: "Continue",
                                style: .init(
                                    backgroundColor: .orange,
                                    foregroundColor: .white,
                                    font: .system(size: 16, weight: .bold),
                                    cornerRadius: 25,
                                    padding: EdgeInsets(top: 12, leading: 32, bottom: 12, trailing: 32)))
                            {
                                showWarningAlert = false
                            },
                            secondaryButton: VeoAlert.AlertButton(
                                title: "Cancel",
                                style: .secondary)
                            {
                                showWarningAlert = false
                            }))
                }

                if showInfoAlert {
                    VeoAlert(
                        isPresented: $showInfoAlert,
                        content: VeoAlert.AlertContent(
                            icon: .system(
                                name: "info.circle",
                                color: .blue,
                                backgroundColor: Color.blue.opacity(0.1)),
                            title: "Information",
                            message: "Here's some important information you should know.",
                            primaryButton: VeoAlert.AlertButton(
                                title: "Got it",
                                style: .init(
                                    backgroundColor: .blue,
                                    foregroundColor: .white,
                                    font: .system(size: 16, weight: .bold),
                                    cornerRadius: 25,
                                    padding: EdgeInsets(top: 12, leading: 32, bottom: 12, trailing: 32)))
                            {
                                showInfoAlert = false
                            }))
                }
            }
        }
    }

    return VeoAlertButtonPreview()
}
