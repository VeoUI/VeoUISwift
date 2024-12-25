//
//  VeoCheckBox.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 10/12/2024.
//

import SwiftUI

public struct VeoCheckBox: View {
    let title: String
    let isChecked: Bool
    let action: () -> Void
    var tintColor: Color = VeoUI.primaryColor
    var isEnabled = true

    private let size: CGFloat = 24
    private let innerPadding: CGFloat = 6

    public init(
        title: String,
        isChecked: Bool,
        action: @escaping () -> Void,
        tintColor: Color = VeoUI.primaryColor,
        isEnabled: Bool = true)
    {
        self.title = title
        self.isChecked = isChecked
        self.action = action
        self.tintColor = tintColor
        self.isEnabled = isEnabled
    }

    public var body: some View {
        Button(action: {
            if isEnabled {
                action()
            }
        }) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isChecked ? tintColor : .gray, lineWidth: 2)
                        .frame(width: size, height: size)

                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(tintColor)
                            .transition(.scale.combined(with: .opacity))
                    }
                }

                Text(title)
                    .font(VeoFont.body())
                    .foregroundColor(isEnabled ? .primary : .gray)
            }
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1 : 0.6)
        .animation(.spring(response: 0.2), value: isChecked)
    }
}
