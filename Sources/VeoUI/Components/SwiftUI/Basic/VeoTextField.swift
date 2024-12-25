//
//  VeoTextField.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoTextField: View {
    @Binding var text: String
    let icon: String
    let placeholder: String
    var isSecure = false
    var keyboardType: UIKeyboardType = .default
    var validation: ((String) -> Bool)?
    var onEditingChanged: ((Bool) -> Void)?
    var onCommit: (() -> Void)?

    @State private var isEditing = false
    @State private var isValid = true

    public init(
        text: Binding<String>,
        icon: String,
        placeholder: String,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        validation: ((String) -> Bool)? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil)
    {
        _text = text
        self.icon = icon
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.validation = validation
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isEditing ? .white : .white.opacity(0.7))
                    .frame(width: 20)
                    .padding(.leading, 20)

                if isSecure {
                    SecureField(placeholder, text: $text) {
                        onCommit?()
                    }
                    .font(VeoFont.caption1())
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                } else {
                    TextField(
                        placeholder,
                        text: $text,
                        onEditingChanged: { editing in
                            isEditing = editing
                            onEditingChanged?(editing)
                            if let validation = validation {
                                isValid = validation(text)
                            }
                        },
                        onCommit: {
                            onCommit?()
                        })
                        .font(VeoFont.caption1())
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .keyboardType(keyboardType)
                }
            }
            .background(Color.white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 30))

            if !isValid {
                Text("Invalid input")
                    .font(VeoFont.caption1())
                    .foregroundColor(Color.red)
                    .padding(.leading, 24)
            }
        }
        .environment(\.layoutDirection, .leftToRight)
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Rubik-Regular")

    struct VeoTextFieldPreview: View {
        @State private var standardText = ""
        @State private var secureText = ""
        @State private var emailText = ""
        @State private var phoneText = ""
        @State private var numberText = ""
        @State private var urlText = ""
        @State private var searchText = ""
        @State private var arabicText = ""

        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    Group {
                        Text("Standard Text Field").foregroundColor(.white)
                        VeoTextField(
                            text: $standardText,
                            icon: "person",
                            placeholder: "Enter your name")
                    }

                    Group {
                        Text("Secure Text Field").foregroundColor(.white)
                        VeoTextField(
                            text: $secureText,
                            icon: "lock",
                            placeholder: "Enter password",
                            isSecure: true)
                    }

                    Group {
                        Text("Email with Validation").foregroundColor(.white)
                        VeoTextField(
                            text: $emailText,
                            icon: "envelope",
                            placeholder: "Enter email",
                            keyboardType: .emailAddress,
                            validation: { email in
                                email.contains("@") && email.contains(".")
                            })
                    }

                    Group {
                        Text("Phone Number Field").foregroundColor(.white)
                        VeoTextField(
                            text: $phoneText,
                            icon: "phone",
                            placeholder: "Enter phone number",
                            keyboardType: .phonePad)
                    }

                    Group {
                        Text("Numeric Field").foregroundColor(.white)
                        VeoTextField(
                            text: $numberText,
                            icon: "number",
                            placeholder: "Enter amount",
                            keyboardType: .numberPad)
                    }

                    Group {
                        Text("URL Field").foregroundColor(.white)
                        VeoTextField(
                            text: $urlText,
                            icon: "link",
                            placeholder: "Enter website URL",
                            keyboardType: .URL)
                    }

                    Group {
                        Text("Search Field").foregroundColor(.white)
                        VeoTextField(
                            text: $searchText,
                            icon: "magnifyingglass",
                            placeholder: "Search...")
                    }

                    Group {
                        Text("Arabic Text Field").foregroundColor(.white)
                        VeoTextField(
                            text: $arabicText,
                            icon: "text.justify",
                            placeholder: "أدخل النص هنا")
                    }

                    Group {
                        Text("Field with Editing Changed").foregroundColor(.white)
                        VeoTextField(
                            text: $standardText,
                            icon: "pencil",
                            placeholder: "Start typing...",
                            onEditingChanged: { editing in
                                print("Editing changed: \(editing)")
                            })
                    }

                    Group {
                        Text("Field with Commit Action").foregroundColor(.white)
                        VeoTextField(
                            text: $standardText,
                            icon: "return",
                            placeholder: "Press return...",
                            onCommit: {
                                print("Committed!")
                            })
                    }
                }
                .padding()
            }
            .background(Color(hex: "#c0392b"))
        }
    }

    return VeoTextFieldPreview()
}
