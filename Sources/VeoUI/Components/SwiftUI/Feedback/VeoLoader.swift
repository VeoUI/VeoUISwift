//
//  VeoLoader.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoLoader: View {
    @State private var dotAnimations = [false, false, false]
    @State private var rotationDegree = 0.0
    @State private var scaleEffect = 1.0
    let isVisible: Bool
    let type: VeoLoaderType
    
    public init(isVisible: Bool = true, type: VeoLoaderType = .dots) {
        self.isVisible = isVisible
        self.type = type
    }

    public var body: some View {
        if isVisible {
            ZStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(true)
                
                Group {
                    switch type {
                    case .dots:
                        dotsLoader
                    case .pulse:
                        pulseLoader
                    case .circular:
                        circularLoader
                    case .bounce:
                        bounceLoader
                    case .wave:
                        waveLoader
                    case .spinner:
                        spinnerLoader
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
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(
                    color: VeoUI.primaryDarkColor.opacity(0.2),
                    radius: 25,
                    x: 0,
                    y: 5
                )
            }
            .transition(.opacity)
            .zIndex(999)
            .onAppear {
                startAnimations()
            }
        }
    }
    
    private var dotsLoader: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
                    .opacity(dotAnimations[index] ? 1.0 : 0.3)
                    .animation(
                        Animation
                            .easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(0.2 * Double(index)),
                        value: dotAnimations[index]
                    )
            }
        }
    }
    
    private var pulseLoader: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 30, height: 30)
            .scaleEffect(scaleEffect)
            .opacity(2 - scaleEffect)
            .animation(
                Animation
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: false),
                value: scaleEffect
            )
    }
    
    private var circularLoader: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Color.white, lineWidth: 3)
            .frame(width: 30, height: 30)
            .rotationEffect(Angle(degrees: rotationDegree))
            .animation(
                Animation
                    .linear(duration: 1)
                    .repeatForever(autoreverses: false),
                value: rotationDegree
            )
    }
    
    private var bounceLoader: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: 8, height: 8)
                    .offset(y: dotAnimations[index] ? -8 : 8)
                    .animation(
                        Animation
                            .interpolatingSpring(stiffness: 180, damping: 8)
                            .repeatForever(autoreverses: true)
                            .delay(0.2 * Double(index)),
                        value: dotAnimations[index]
                    )
            }
        }
    }
    
    private var waveLoader: some View {
        HStack(spacing: 4) {
            ForEach(0..<4) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white)
                    .frame(width: 2, height: dotAnimations[index % 3] ? 20 : 10)
                    .animation(
                        Animation
                            .easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(0.1 * Double(index)),
                        value: dotAnimations[index % 3]
                    )
            }
        }
    }
    
    private var spinnerLoader: some View {
        ZStack {
            ForEach(0..<8) { index in
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 2, height: 6)
                    .opacity(1.0 - (Double(index) * 0.1))
                    .offset(y: -12)
                    .rotationEffect(.degrees(Double(index) * 45 + rotationDegree))
            }
        }
        .frame(width: 30, height: 30)
        .animation(
            Animation
                .linear(duration: 1)
                .repeatForever(autoreverses: false),
            value: rotationDegree
        )
    }
    
    private func startAnimations() {
        for index in 0..<3 {
            withAnimation(
                Animation
                    .easeInOut(duration: 0.5)
                    .repeatForever()
                    .delay(0.2 * Double(index))
            ) {
                dotAnimations[index].toggle()
            }
        }
        
        withAnimation(
            Animation
                .linear(duration: 1)
                .repeatForever(autoreverses: false)
        ) {
            rotationDegree = 360
        }
        
        withAnimation(
            Animation
                .easeInOut(duration: 1)
                .repeatForever(autoreverses: false)
        ) {
            scaleEffect = 2.0
        }
    }
}

public enum VeoLoaderType: CaseIterable {
    case dots
    case pulse
    case circular
    case bounce
    case wave
    case spinner
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        isRTL: true,
        mainFont: "Rubik-Bold"
    )
    
    return ZStack {
        Color.black.opacity(0.1)
            .edgesIgnoringSafeArea(.all)
        
        VStack(spacing: 30) {
            
            VeoLoader(type: .dots)
            
            VeoLoader(type: .bounce)
            
            VeoLoader(type: .circular)
            
            VeoLoader(type: .pulse)
            
            VeoLoader(type: .spinner)
            
            VeoLoader(type: .wave)
        }
    }
}
