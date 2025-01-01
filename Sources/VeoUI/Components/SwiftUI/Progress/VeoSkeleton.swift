//
//  VeoSkeleton.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 1/1/2025.
//

import SwiftUI

public struct VeoSkeleton: View {
    let style: VeoSkeletonStyle
    let shape: VeoSkeletonShape
    let width: CGFloat?
    let height: CGFloat
    let shimmerSpeed: Double
    let gradient: (Color, Color)?
    
    public init(
        style: VeoSkeletonStyle = .default,
        shape: VeoSkeletonShape = .rounded,
        width: CGFloat? = nil,
        height: CGFloat = 20,
        shimmerSpeed: Double = 1.0,
        gradient: (Color, Color)? = nil
    ) {
        self.style = style
        self.shape = shape
        self.width = width
        self.height = height
        self.shimmerSpeed = shimmerSpeed
        self.gradient = gradient
    }
    
    private var cornerRadius: CGFloat {
        switch shape {
        case .square:
            return 0
        case .rounded:
            return VeoUI.defaultCornerRadius
        case .circle:
            return height / 2
        case let .custom(radius):
            return radius
        }
    }
    
    private var baseColor: Color {
        switch style {
        case .default:
            return Color.gray.opacity(0.15)
        case .primary:
            return VeoUI.primaryColor.opacity(0.15)
        case .secondary:
            return (VeoUI.secondaryColor ?? .gray).opacity(0.15)
        case let .custom(color):
            return color.opacity(0.15)
        }
    }
    
    @State private var shimmerOffset: CGFloat = -0.7
    
    private var shimmerGradient: LinearGradient {
        let gradientColors = gradient ?? (Color.white.opacity(0.0), Color.white.opacity(0.5))
        return LinearGradient(
            stops: [
                Gradient.Stop(color: baseColor, location: 0.1),
                Gradient.Stop(color: gradientColors.0, location: max(0, shimmerOffset)),
                Gradient.Stop(color: gradientColors.1, location: max(0, shimmerOffset + 0.2)),
                Gradient.Stop(color: baseColor, location: max(0, shimmerOffset + 0.4))
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    public var body: some View {
        Rectangle()
            .fill(shimmerGradient)
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5 / shimmerSpeed)
                    .repeatForever(autoreverses: false)
                ) {
                    shimmerOffset = 1.7
                }
            }
    }
}

public enum VeoSkeletonStyle {
    case `default`
    case primary
    case secondary
    case custom(Color)
}

public enum VeoSkeletonShape {
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
        mainFont: "Rubik-Regular"
    )
    
    return ScrollView {
        VStack(spacing: 32) {
            Group {
                VeoText("Basic Skeletons", style: .headline)
                VStack(spacing: 16) {
                    VeoSkeleton(style: .default)
                    VeoSkeleton(style: .primary)
                    VeoSkeleton(style: .secondary)
                    VeoSkeleton(style: .custom(.purple))
                }
            }
            
            Divider()
            
            Group {
                VeoText("Different Shapes", style: .headline)
                HStack(spacing: 16) {
                    VeoSkeleton(shape: .circle, width: 50, height: 50)
                    VeoSkeleton(shape: .rounded, width: 50, height: 50)
                    VeoSkeleton(shape: .square, width: 50, height: 50)
                }
            }
            
            Divider()
            
            Group {
                VeoText("Loading Card", style: .headline)
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        VeoSkeleton(
                            shape: .circle,
                            width: 40,
                            height: 40,
                            shimmerSpeed: 0.8
                        )
                        VStack(alignment: .leading, spacing: 8) {
                            VeoSkeleton(
                                width: 120,
                                height: 14,
                                shimmerSpeed: 0.8
                            )
                            VeoSkeleton(
                                width: 80,
                                height: 12,
                                shimmerSpeed: 0.8
                            )
                        }
                    }
                    
                    VeoSkeleton(
                        height: 200,
                        shimmerSpeed: 0.8,
                        gradient: (Color(hex: "#2980b9").opacity(0.2),
                                 Color(hex: "#3498db").opacity(0.4))
                    )
                    
                    HStack(spacing: 8) {
                        VeoSkeleton(
                            width: 60,
                            height: 24,
                            shimmerSpeed: 0.8
                        )
                        VeoSkeleton(
                            width: 60,
                            height: 24,
                            shimmerSpeed: 0.8
                        )
                        Spacer()
                        VeoSkeleton(
                            width: 100,
                            height: 24,
                            shimmerSpeed: 0.8
                        )
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(16)
            }
            
            Divider()
            
            Group {
                VeoText("Article Loading", style: .headline)
                VStack(alignment: .leading, spacing: 12) {
                    VeoSkeleton(width: 250, height: 24, shimmerSpeed: 1.2)
                    VStack(alignment: .leading, spacing: 8) {
                        VeoSkeleton(height: 14, shimmerSpeed: 1.2)
                        VeoSkeleton(height: 14, shimmerSpeed: 1.2)
                        VeoSkeleton(width: 250, height: 14, shimmerSpeed: 1.2)
                    }
                }
            }
        }
        .padding()
    }
}
