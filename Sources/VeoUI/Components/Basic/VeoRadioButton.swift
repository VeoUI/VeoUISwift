//
//  VeoRadioButton.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 10/12/2024.
//

import SwiftUI

public struct VeoRadioButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    var tintColor: Color = VeoUI.primaryColor
    var isEnabled = true

    private let size: CGFloat = 24
    private let innerPadding: CGFloat = 6

    public var body: some View {
        Button(action: {
            if isEnabled {
                action()
            }
        }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? tintColor : .gray, lineWidth: 2)
                        .frame(width: size, height: size)

                    if isSelected {
                        Circle()
                            .fill(tintColor)
                            .frame(width: size - innerPadding * 2)
                            .transition(.scale)
                    }
                }

                Text(title)
                    .font(VeoFont.body())
                    .foregroundColor(isEnabled ? .primary : .gray)
            }
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1 : 0.6)
        .animation(.spring(response: 0.2), value: isSelected)
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Rubik-Regular")

    struct VeoRadioCheckboxPreview: View {
        @State private var selectedRadio = 0
        @State private var selectedArabicRadio = 0
        @State private var checkboxStates = [false, false, true]
        @State private var arabicCheckboxStates = [false, true, false]

        var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    Group {
                        Text("Radio Buttons").font(.headline)
                        VStack(alignment: .leading, spacing: 16) {
                            VeoRadioButton(
                                title: "Option 1",
                                isSelected: selectedRadio == 0,
                                action: { selectedRadio = 0 })

                            VeoRadioButton(
                                title: "Option 2",
                                isSelected: selectedRadio == 1,
                                action: { selectedRadio = 1 })

                            VeoRadioButton(
                                title: "Disabled Option",
                                isSelected: selectedRadio == 2,
                                action: { selectedRadio = 2 },
                                isEnabled: false)

                            VeoRadioButton(
                                title: "Custom Color",
                                isSelected: selectedRadio == 3,
                                action: { selectedRadio = 3 },
                                tintColor: .blue)
                        }
                    }

                    Divider()

                    Group {
                        Text("أزرار الاختيار").font(.headline)
                        VStack(alignment: .trailing, spacing: 16) {
                            VeoRadioButton(
                                title: "الخيار الأول",
                                isSelected: selectedArabicRadio == 0,
                                action: { selectedArabicRadio = 0 })

                            VeoRadioButton(
                                title: "الخيار الثاني",
                                isSelected: selectedArabicRadio == 1,
                                action: { selectedArabicRadio = 1 },
                                tintColor: .purple)
                        }
                    }

                    Divider()

                    Group {
                        Text("Checkboxes").font(.headline)
                        VStack(alignment: .leading, spacing: 16) {
                            VeoCheckBox(
                                title: "Enable notifications",
                                isChecked: checkboxStates[0],
                                action: { checkboxStates[0].toggle() })

                            VeoCheckBox(
                                title: "Custom color checkbox",
                                isChecked: checkboxStates[1],
                                action: { checkboxStates[1].toggle() },
                                tintColor: .green)

                            VeoCheckBox(
                                title: "Disabled checkbox",
                                isChecked: checkboxStates[2],
                                action: { checkboxStates[2].toggle() },
                                isEnabled: false)
                        }
                    }

                    Divider()

                    Group {
                        Text("مربعات الاختيار").font(.headline)
                        VStack(alignment: .trailing, spacing: 16) {
                            VeoCheckBox(
                                title: "تفعيل الإشعارات",
                                isChecked: arabicCheckboxStates[0],
                                action: { arabicCheckboxStates[0].toggle() })

                            VeoCheckBox(
                                title: "حفظ التفضيلات",
                                isChecked: arabicCheckboxStates[1],
                                action: { arabicCheckboxStates[1].toggle() },
                                tintColor: .orange)

                            VeoCheckBox(
                                title: "الخيار المعطل",
                                isChecked: arabicCheckboxStates[2],
                                action: { arabicCheckboxStates[2].toggle() },
                                isEnabled: false)
                        }
                    }

                    Group {
                        Text("Use Case Example").font(.headline)
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Notification Preferences")
                                .font(.subheadline)

                            VeoCheckBox(
                                title: "Email notifications",
                                isChecked: checkboxStates[0],
                                action: { checkboxStates[0].toggle() })

                            Text("Newsletter Frequency")
                                .font(.subheadline)

                            VeoRadioButton(
                                title: "Daily updates",
                                isSelected: selectedRadio == 0,
                                action: { selectedRadio = 0 })

                            VeoRadioButton(
                                title: "Weekly digest",
                                isSelected: selectedRadio == 1,
                                action: { selectedRadio = 1 })
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
    }

    return VeoRadioCheckboxPreview()
}
