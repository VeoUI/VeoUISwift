//
//  VeoSwitch.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoSwitch: View {
    @Binding var isOn: Bool
    let label: String
    var tintColor: Color = VeoUI.primaryColor
    var isEnabled = true
    var onChange: ((Bool) -> Void)?

    private let switchWidth: CGFloat = 50
    private let switchHeight: CGFloat = 30
    private let toggleSize: CGFloat = 24
    private let togglePadding: CGFloat = 3
    private let animationDuration = 0.2

    public var body: some View {
        HStack {
            Text(label)
                .font(VeoFont.body())
                .foregroundColor(isEnabled ? .primary : .gray)

            Spacer()

            ZStack {
                Capsule()
                    .fill(isOn ? tintColor : Color.gray.opacity(0.3))
                    .frame(width: switchWidth, height: switchHeight)

                // Knob
                Circle()
                    .fill(Color.white)
                    .shadow(radius: 1)
                    .frame(width: toggleSize, height: toggleSize)
                    .offset(
                        x: isOn
                            ? (switchWidth - toggleSize - togglePadding * 2) / 2
                            : -(switchWidth - toggleSize - togglePadding * 2) / 2)
                        .animation(.easeInOut(duration: animationDuration), value: isOn)
            }
        }
        .padding(.horizontal)
        .opacity(isEnabled ? 1.0 : 0.6)
        .onTapGesture {
            if isEnabled {
                withAnimation {
                    isOn.toggle()
                    onChange?(isOn)
                }
            }
        }
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Rubik-Regular")

    struct VeoSwitchPreview: View {
        @State private var switch1 = false
        @State private var switch2 = true
        @State private var switch3 = false
        @State private var switch4 = true
        @State private var switch5 = false
        @State private var arabicSwitch1 = false
        @State private var arabicSwitch2 = true

        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    Group {
                        Text("Basic Switches").font(.headline)
                        VeoSwitch(isOn: $switch1, label: "Enable notifications")
                        VeoSwitch(isOn: $switch2, label: "Dark mode")
                    }

                    Divider()

                    Group {
                        Text("Custom Colors").font(.headline)
                        VeoSwitch(
                            isOn: $switch3,
                            label: "Enable sync",
                            tintColor: .blue)
                        VeoSwitch(
                            isOn: $switch4,
                            label: "Auto-update",
                            tintColor: .green)
                    }

                    Divider()

                    Group {
                        Text("Disabled State").font(.headline)
                        VeoSwitch(
                            isOn: $switch5,
                            label: "Premium feature",
                            isEnabled: false)
                    }

                    Divider()

                    Group {
                        Text("Arabic Switches").font(.headline)
                        VeoSwitch(
                            isOn: $arabicSwitch1,
                            label: "تفعيل الإشعارات")
                        VeoSwitch(
                            isOn: $arabicSwitch2,
                            label: "الوضع المظلم",
                            tintColor: .purple)
                    }

                    Divider()

                    Group {
                        Text("With Callbacks").font(.headline)
                        VeoSwitch(
                            isOn: $switch1,
                            label: "With callback",
                            onChange: { newValue in
                                print("Switch value changed to: \(newValue)")
                            })

                        VeoSwitch(
                            isOn: $arabicSwitch1,
                            label: "مع رد الاتصال",
                            tintColor: .orange,
                            onChange: { newValue in
                                print("تغيرت قيمة المفتاح إلى: \(newValue)")
                            })
                    }
                }
                .padding()
            }
        }
    }

    return VeoSwitchPreview()
}
