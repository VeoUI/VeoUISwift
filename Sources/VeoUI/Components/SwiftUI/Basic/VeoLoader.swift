//
//  VeoLoader.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoLoader: View {
    @State private var isVisible = true
    @State private var dotAnimations = [false, false, false]

    public init(isVisible: Bool = true, dotAnimations: [Bool] = [false, false, false]) {
        self.isVisible = isVisible
        self.dotAnimations = dotAnimations
    }

    public var body: some View {
        OpacityView(isVisible: isVisible) {
            HStack(spacing: 8) {
                ForEach(0 ..< 3) { index in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 10, height: 10)
                        .opacity(dotAnimations[index] ? 1.0 : 0.3)
                        .animation(
                            Animation
                                .easeInOut(duration: 0.5)
                                .repeatForever()
                                .delay(0.2 * Double(index)),
                            value: dotAnimations[index])
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        VeoUI.primaryColor,
                        VeoUI.primaryDarkColor
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(
                color: VeoUI.primaryDarkColor.opacity(0.2),
                radius: 25,
                x: 0,
                y: 5)
        }
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        for index in 0 ..< 3 {
            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.2 * Double(index))) {
                dotAnimations[index].toggle()
            }
        }
    }
}

private struct OpacityView<Content: View>: View {
    let isVisible: Bool
    let content: () -> Content

    init(isVisible: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.isVisible = isVisible
        self.content = content
    }

    var body: some View {
        content()
            .opacity(isVisible ? 1 : 0)
            .animation(.easeInOut(duration: 0.5), value: isVisible)
    }
}
