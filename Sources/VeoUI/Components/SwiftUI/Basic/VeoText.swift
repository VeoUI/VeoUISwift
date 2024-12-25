//
//  VeoText.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoText: View {
    let text: String
    let style: VeoTextStyle
    var alignment: TextAlignment = .leading
    var lineLimit: Int?
    var color: Color?

    public enum VeoTextStyle {
        case title
        case subtitle
        case body
        case caption
    }

    public init(
        _ text: String,
        style: VeoTextStyle = .body,
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil,
        color: Color? = nil)
    {
        self.text = text
        self.style = style
        self.alignment = alignment
        self.lineLimit = lineLimit
        self.color = color
    }

    private var font: Font {
        switch style {
        case .title:
            VeoFont.largeTitle()
        case .subtitle:
            VeoFont.subheadline()
        case .body:
            VeoFont.body()
        case .caption:
            VeoFont.caption1()
        }
    }

    public var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(color ?? (VeoUI.isDarkMode ? .white : .black))
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        mainFont: "Rubik-Regular")

    return ScrollView {
        VStack(spacing: 32) {
            Group {
                Text("English Text Styles").font(.headline)

                VStack(alignment: .leading, spacing: 16) {
                    VeoText("This is a Title Text", style: .title)
                    VeoText("This is a Subtitle Text", style: .subtitle)
                    VeoText(
                        "This is a Body Text that can span multiple lines and show how the text wraps when it gets longer.",
                        style: .body)
                    VeoText("This is a Caption Text", style: .caption)
                }
            }

            Divider()

            Group {
                Text("Arabic Text Styles").font(.headline)

                VStack(alignment: .trailing, spacing: 16) {
                    VeoText("هذا نص العنوان", style: .title)
                    VeoText("هذا نص العنوان الفرعي", style: .subtitle)
                    VeoText(
                        "هذا نص المحتوى الذي يمكن أن يمتد على عدة أسطر ويوضح كيفية التفاف النص عندما يصبح أطول.",
                        style: .body)
                    VeoText("هذا نص التسمية التوضيحية", style: .caption)
                }
            }

            Divider()

            Group {
                Text("Text Alignments").font(.headline)

                VStack(spacing: 16) {
                    VeoText("Left Aligned Text", style: .body, alignment: .leading)
                    VeoText("Centered Text", style: .body, alignment: .center)
                    VeoText("Right Aligned Text", style: .body, alignment: .trailing)

                    VeoText("نص محاذاة لليسار", style: .body, alignment: .leading)
                    VeoText("نص في المنتصف", style: .body, alignment: .center)
                    VeoText("نص محاذاة لليمين", style: .body, alignment: .trailing)
                }
            }

            Divider()

            Group {
                Text("Line Limits").font(.headline)

                VStack(spacing: 16) {
                    VeoText(
                        "This is a single line text with line limit set to 1. This text will be truncated.",
                        style: .body,
                        lineLimit: 1)

                    VeoText(
                        "هذا نص سطر واحد مع تحديد السطر إلى 1. سيتم اقتطاع هذا النص.",
                        style: .body,
                        lineLimit: 1)
                }
            }

            Divider()

            Group {
                Text("Custom Colors").font(.headline)

                VStack(spacing: 16) {
                    VeoText("Primary Colored Text", style: .body, color: .blue)
                    VeoText("Success Text", style: .body, color: .green)
                    VeoText("Warning Text", style: .body, color: .orange)
                    VeoText("Error Text", style: .body, color: .red)

                    VeoText("نص ملون أساسي", style: .body, color: .blue)
                    VeoText("نص النجاح", style: .body, color: .green)
                    VeoText("نص التحذير", style: .body, color: .orange)
                    VeoText("نص الخطأ", style: .body, color: .red)
                }
            }

            Group {
                Text("Real World Examples").font(.headline)

                VStack(alignment: .leading, spacing: 16) {
                    VeoText("Product Details", style: .title)
                    VeoText("Premium Package", style: .subtitle)
                    VeoText(
                        "This premium package includes all features and benefits of our standard package plus exclusive access to premium content.",
                        style: .body)
                    VeoText("*Terms and conditions apply", style: .caption)

                    Divider()

                    VeoText("تفاصيل المنتج", style: .title)
                    VeoText("الباقة المميزة", style: .subtitle)
                    VeoText(
                        "تتضمن هذه الباقة المميزة جميع ميزات ومزايا باقتنا القياسية بالإضافة إلى الوصول الحصري إلى المحتوى المميز.",
                        style: .body)
                    VeoText("*تطبق الشروط والأحكام", style: .caption)
                }
            }
        }
        .padding()
    }
}
