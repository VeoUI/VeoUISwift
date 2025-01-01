//
//  VeoFloatingButton.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 1/1/2025.
//

import SwiftUI

public struct VeoFloatingButton: View {
    let icon: VeoIcon.IconType
    let action: () -> Void
    
    var size: CGFloat = 56
    var backgroundColor: Color = VeoUI.primaryColor
    var foregroundColor: Color = .white
    
    @State private var isPressed = false
    
    public init(
        icon: VeoIcon.IconType,
        action: @escaping () -> Void,
        size: CGFloat = 56,
        backgroundColor: Color = VeoUI.primaryColor,
        foregroundColor: Color = .white
    ) {
        self.icon = icon
        self.action = action
        self.size = size
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    private func performAction() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isPressed = true
        }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = false
            }
            action()
        }
    }
    
    public var body: some View {
        Button(action: performAction) {
            ZStack {
                Circle()
                    .fill(backgroundColor.opacity(isPressed ? 0.8 : 1))
                
                VeoIcon(icon: icon, size: size * 0.5, color: foregroundColor)
            }
            .frame(width: size, height: size)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .contentShape(Circle())
        .position(x: UIScreen.main.bounds.width - 70, y: UIScreen.main.bounds.height - 140)
    }
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        mainFont: "Rubik-Regular"
    )
    
    struct VeoFloatingButtonPreview: View {
        @State private var count = 0
        
        var body: some View {
            ZStack {
                Color.orange.opacity(0.1).edgesIgnoringSafeArea(.all)
                
                VStack {
                    VeoText("Count: \(count)",
                            style: .title)
                        .padding()
                }
                
                VeoFloatingButton(
                    icon: .common(.add),
                    action: { count += 1 }
                )
            }
        }
    }
    
    return VeoFloatingButtonPreview()
}
