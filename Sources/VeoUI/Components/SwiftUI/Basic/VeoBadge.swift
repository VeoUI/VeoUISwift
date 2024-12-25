//
//  VeoBadge.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 9/12/2024.
//

import SwiftUI

public struct VeoBadge: View {
    let text: String
    let textColor: Color
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let cornerRadius: CGFloat
    let isRightToLeft: Bool

    public init(
        text: String,
        textColor: Color = .white,
        horizontalPadding: CGFloat = 8,
        verticalPadding: CGFloat = 4,
        cornerRadius: CGFloat = 12,
        isRightToLeft: Bool = false)
    {
        self.text = text
        self.textColor = textColor
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = cornerRadius
        self.isRightToLeft = isRightToLeft
    }

    public var body: some View {
        Text(text)
            .font(VeoFont.callout())
            .foregroundColor(textColor)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(textColor.opacity(0.1))
            .cornerRadius(cornerRadius)
            .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        mainFont: "Tajawal-Bold")

    return ScrollView {
        VStack(spacing: 24) {
            Group {
                VeoText("Basic Badges")
                HStack(spacing: 12) {
                    VeoBadge(text: "New", textColor: .blue)
                    VeoBadge(text: "Featured", textColor: .green)
                    VeoBadge(text: "Sale", textColor: .red)
                }
            }

            Divider()

            Group {
                Text("Padding Variations").font(.headline)
                HStack(spacing: 12) {
                    VeoBadge(
                        text: "Compact",
                        textColor: .purple,
                        horizontalPadding: 4,
                        verticalPadding: 1)
                    VeoBadge(
                        text: "Normal",
                        textColor: .orange,
                        horizontalPadding: 8,
                        verticalPadding: 2)
                    VeoBadge(
                        text: "Large",
                        textColor: .pink,
                        horizontalPadding: 16,
                        verticalPadding: 4)
                }
            }

            Divider()

            Group {
                Text("Corner Radius Variations").font(.headline)
                HStack(spacing: 12) {
                    VeoBadge(
                        text: "Square",
                        textColor: .blue,
                        cornerRadius: 0)
                    VeoBadge(
                        text: "Rounded",
                        textColor: .green,
                        cornerRadius: 12)
                    VeoBadge(
                        text: "Pill",
                        textColor: .red,
                        cornerRadius: 20)
                }
            }

            Divider()

            Group {
                Text("Arabic Badges").font(.headline)
                HStack(spacing: 12) {
                    VeoBadge(
                        text: "جديد",
                        textColor: .blue,
                        isRightToLeft: true)
                    VeoBadge(
                        text: "مميز",
                        textColor: .green,
                        isRightToLeft: true)
                    VeoBadge(
                        text: "تخفيض",
                        textColor: .red,
                        isRightToLeft: true)
                }
            }

            Group {
                HStack(spacing: 12) {
                    VeoBadge(
                        text: "صغير",
                        textColor: .purple,
                        horizontalPadding: 4,
                        verticalPadding: 1,
                        isRightToLeft: true)
                    VeoBadge(
                        text: "متوسط",
                        textColor: .orange,
                        horizontalPadding: 8,
                        verticalPadding: 2,
                        isRightToLeft: true)
                    VeoBadge(
                        text: "كبير",
                        textColor: .pink,
                        horizontalPadding: 16,
                        verticalPadding: 4,
                        isRightToLeft: true)
                }
            }

            Divider()

            Group {
                Text("Color Variations").font(.headline)
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        VeoBadge(text: "Primary", textColor: Color(hex: "#e74c3c"))
                        VeoBadge(text: "Secondary", textColor: Color(hex: "#3498db"))
                        VeoBadge(text: "Success", textColor: Color(hex: "#2ecc71"))
                    }
                    HStack(spacing: 8) {
                        VeoBadge(text: "Warning", textColor: Color(hex: "#f1c40f"))
                        VeoBadge(text: "Danger", textColor: Color(hex: "#e74c3c"))
                        VeoBadge(text: "Info", textColor: Color(hex: "#9b59b6"))
                    }
                }
            }

            Group {
                Text("Common Use Cases").font(.headline)
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        VeoBadge(
                            text: "IN STOCK",
                            textColor: .green,
                            horizontalPadding: 12,
                            cornerRadius: 16)
                        VeoBadge(
                            text: "متوفر",
                            textColor: .green,
                            horizontalPadding: 12,
                            cornerRadius: 16,
                            isRightToLeft: true)
                    }

                    HStack(spacing: 8) {
                        VeoBadge(
                            text: "PREMIUM",
                            textColor: Color(hex: "#f1c40f"),
                            horizontalPadding: 12,
                            cornerRadius: 4)
                        VeoBadge(
                            text: "مميز",
                            textColor: Color(hex: "#f1c40f"),
                            horizontalPadding: 12,
                            cornerRadius: 4,
                            isRightToLeft: true)
                    }
                }
            }
        }
        .padding()
    }
}
