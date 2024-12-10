//
//  VeoButton.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoButton: View {
    let title: String
    let action: () -> Void

    let style: VeoButtonStyle
    let shape: VeoButtonShape
    let elevation: CGFloat
    let gradientColors: (Color, Color)?
    let textDirection: TextAlignment
    let isEnabled: Bool

    init(
        title: String,
        style: VeoButtonStyle = .primary,
        shape: VeoButtonShape = .rounded,
        elevation: CGFloat = VeoUI.defaultElevation,
        gradientColors: (Color, Color)? = nil,
        textDirection: TextAlignment = .center,
        isEnabled: Bool = true,
        action: @escaping () -> Void)
    {
        self.title = title
        self.style = style
        self.shape = shape
        self.elevation = elevation
        self.gradientColors = gradientColors
        self.textDirection = textDirection
        self.isEnabled = isEnabled
        self.action = action
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:
            VeoUI.primaryColor
        case .secondary:
            VeoUI.secondaryColor ?? .white
        case .info:
            VeoUI.infoColor ?? .white
        case .warning:
            VeoUI.warningColor ?? .white
        case .danger:
            VeoUI.dangerColor
        case .tertiary:
            VeoUI.tertiaryColor ?? .white
        }
    }

    private var cornerRadius: CGFloat {
        switch shape {
        case .square:
            0
        case .rounded:
            VeoUI.defaultCornerRadius
        case .circle:
            25
        case let .custom(radius):
            radius
        }
    }

    private var backgroundView: some View {
        Group {
            if let gradientColors = gradientColors {
                LinearGradient(
                    gradient: Gradient(colors: [
                        gradientColors.0,
                        gradientColors.1
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing)
            } else {
                backgroundColor
            }
        }
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(VeoFont.body())
                .foregroundColor(.white)
                .multilineTextAlignment(textDirection)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundView)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .shadow(
                    color: backgroundColor.opacity(0.3),
                    radius: elevation,
                    x: 0,
                    y: elevation)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
        .padding(.horizontal)
    }
}

enum VeoButtonStyle {
    case primary
    case secondary
    case info
    case warning
    case danger
    case tertiary
}

enum VeoButtonShape {
    case square
    case rounded
    case circle
    case custom(cornerRadius: CGFloat)
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

    return ScrollView {
        VStack(spacing: 20) {
            Group {
                Text("Button Styles").font(.headline)
                VeoButton(title: "Primary Button", style: .primary) {}
                VeoButton(title: "Secondary Button", style: .secondary) {}
                VeoButton(title: "Info Button", style: .info) {}
                VeoButton(title: "Warning Button", style: .warning) {}
                VeoButton(title: "Danger Button", style: .danger) {}
                VeoButton(title: "Tertiary Button", style: .tertiary) {}
            }

            Divider()

            Group {
                Text("Button Shapes").font(.headline)
                VeoButton(title: "Square Button", shape: .square) {}
                VeoButton(title: "Rounded Button", shape: .rounded) {}
                VeoButton(title: "Circle Button", shape: .circle) {}
                VeoButton(title: "Custom Radius", shape: .custom(cornerRadius: 15)) {}
            }

            Divider()

            Group {
                Text("Elevation Variants").font(.headline)
                VeoButton(title: "No Elevation", elevation: 0) {}
                VeoButton(title: "Medium Elevation", elevation: 5) {}
                VeoButton(title: "High Elevation", elevation: 10) {}
            }

            Divider()

            Group {
                Text("Gradient Buttons").font(.headline)
                VeoButton(
                    title: "Blue Gradient",
                    gradientColors: (Color(hex: "#2980b9"), Color(hex: "#3498db"))) {}
                VeoButton(
                    title: "Purple Gradient",
                    gradientColors: (Color(hex: "#8e44ad"), Color(hex: "#9b59b6"))) {}
            }

            Divider()

            Group {
                Text("Text Alignment").font(.headline)
                VeoButton(title: "Left Aligned", textDirection: .leading) {}
                VeoButton(title: "Center Aligned", textDirection: .center) {}
                VeoButton(title: "Right Aligned", textDirection: .trailing) {}
            }

            Divider()

            Group {
                Text("Button States").font(.headline)
                VeoButton(title: "Enabled Button", isEnabled: true) {}
                VeoButton(title: "Disabled Button", isEnabled: false) {}
            }

            Divider()

            Group {
                VeoText("RTL Support")
                VeoButton(title: "إنشاء حساب جديد") {}
                VeoButton(
                    title: "زر التحذير",
                    style: .warning,
                    textDirection: .trailing) {}
            }

            Group {
                VeoText("Complex")

                VeoButton(
                    title: "Custom Gradient + Shape",
                    shape: .custom(cornerRadius: 20),
                    elevation: 8,
                    gradientColors: (Color(hex: "#16a085"), Color(hex: "#2ecc71"))) {}

                VeoButton(
                    title: "High Impact Button",
                    style: .danger,
                    shape: .circle,
                    elevation: 12,
                    gradientColors: (Color(hex: "#c0392b"), Color(hex: "#e74c3c")),
                    textDirection: .center) {}
            }
        }
        .padding()
    }
}
