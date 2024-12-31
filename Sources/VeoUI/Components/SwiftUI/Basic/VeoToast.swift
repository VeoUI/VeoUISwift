//
//  VeoToast.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 31/12/2024.
//

import SwiftUI

public enum VeoToastPosition {
    case top
    case bottom
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
    
    var alignment: Alignment {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        case .topLeading: return .topLeading
        case .topTrailing: return .topTrailing
        case .bottomLeading: return .bottomLeading
        case .bottomTrailing: return .bottomTrailing
        }
    }
    
    var edge: Edge {
        switch self {
        case .top, .topLeading, .topTrailing: return .top
        case .bottom, .bottomLeading, .bottomTrailing: return .bottom
        }
    }
}

public enum VeoToastStyle {
    case success
    case error
    case warning
    case info
    case custom(backgroundColor: Color, foregroundColor: Color)
    
    @MainActor
    var backgroundColor: Color {
        switch self {
        case .success:
            return VeoUI.successColor
        case .error:
            return VeoUI.dangerColor
        case .warning:
            return VeoUI.warningColor
        case .info:
            return VeoUI.infoColor
        case .custom(let backgroundColor, _):
            return backgroundColor
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .custom(_, let foregroundColor):
            return foregroundColor
        default:
            return .white
        }
    }
    
    var icon: VeoIcon.CommonIcons {
        switch self {
        case .success:
            return .success
        case .error:
            return .error
        case .warning:
            return .warning
        case .info:
            return .info
        case .custom:
            return .info
        }
    }
}

public class VeoToastConfig {
    @MainActor
    public static var shared = VeoToastConfig()
    
    public var defaultPosition: VeoToastPosition = .top
    public var defaultDuration: Double = 3
    public var defaultStyle: VeoToastStyle = .info
    public var defaultIsClosable: Bool = true
    public var iconSize: CGFloat = 20
    public var fontWeight: Font.Weight = .medium
    public var animationDuration: Double = 0.3
}

public struct VeoToastMessage: Equatable {
    let id: UUID
    let message: String
    var style: VeoToastStyle?
    var position: VeoToastPosition?
    var duration: Double?
    var isClosable: Bool?
    
    public init(
        message: String,
        style: VeoToastStyle? = nil,
        position: VeoToastPosition? = nil,
        duration: Double? = nil,
        isClosable: Bool? = nil
    ) {
        self.id = UUID()
        self.message = message
        self.style = style
        self.position = position
        self.duration = duration
        self.isClosable = isClosable
    }
    
    public static func == (lhs: VeoToastMessage, rhs: VeoToastMessage) -> Bool {
        lhs.id == rhs.id
    }
}

public struct VeoToast: View {
    @Binding var currentToast: VeoToastMessage?
    
    @State private var opacity: Double = 0
    @State private var offset: CGFloat = 50
    @State private var hideTimer: Timer?
    @State private var isAnimatingOut = false
    
    public init(currentToast: Binding<VeoToastMessage?>) {
        self._currentToast = currentToast
    }
    
    private var style: VeoToastStyle {
        currentToast?.style ?? VeoToastConfig.shared.defaultStyle
    }
    
    private var position: VeoToastPosition {
        currentToast?.position ?? VeoToastConfig.shared.defaultPosition
    }
    
    private var duration: Double? {
        currentToast?.duration ?? VeoToastConfig.shared.defaultDuration
    }
    
    private var isClosable: Bool {
        currentToast?.isClosable ?? VeoToastConfig.shared.defaultIsClosable
    }
    
    public var body: some View {
        if let toast = currentToast {
            GeometryReader { geometry in
                toastContent(for: toast)
                    .frame(maxWidth: geometry.size.width * 0.9)
                    .position(
                        x: geometry.size.width / 2,
                        y: position.edge == .top ? geometry.safeAreaInsets.top + 50 : geometry.size.height - 50
                    )
                    .opacity(opacity)
                    .offset(y: offset)
                    .onChange(of: toast) { _ in
                        resetAndShow()
                    }
                    .onAppear {
                        resetAndShow()
                    }
            }
        }
    }
    
    private func toastContent(for toast: VeoToastMessage) -> some View {
        HStack(spacing: 12) {
            VeoIcon(
                icon: .common(style.icon),
                size: VeoToastConfig.shared.iconSize,
                color: style.foregroundColor,
                weight: VeoToastConfig.shared.fontWeight
            )
            
            VeoText(
                toast.message,
                style: .subheadline,
                color: style.foregroundColor,
                lineSpacing: 4
            )
            
            if isClosable {
                VeoIcon(
                    icon: .common(.close),
                    size: VeoToastConfig.shared.iconSize,
                    color: style.foregroundColor,
                    weight: VeoToastConfig.shared.fontWeight,
                    action: dismiss
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: VeoUI.defaultCornerRadius)
                .fill(style.backgroundColor)
                .shadow(
                    color: style.backgroundColor.opacity(0.3),
                    radius: VeoUI.defaultElevation,
                    x: 0,
                    y: VeoUI.defaultElevation
                )
        )
    }
    
    private func resetAndShow() {
        hideTimer?.invalidate()
        hideTimer = nil
        
        if isAnimatingOut {
            opacity = 0
            offset = position.edge == .top ? -50 : 50
            isAnimatingOut = false
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            opacity = 1
            offset = 0
        }
        
        setupAutoDismiss()
    }
    
    private func dismiss() {
        guard !isAnimatingOut else { return }
        isAnimatingOut = true
        
        withAnimation(.easeInOut(duration: VeoToastConfig.shared.animationDuration)) {
            opacity = 0
            offset = position.edge == .top ? -50 : 50
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + VeoToastConfig.shared.animationDuration) {
            currentToast = nil
            isAnimatingOut = false
        }
    }
    
    
    private func setupAutoDismiss() {
        guard let duration = duration else { return }
        
        hideTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            // dismiss()
        }
    }
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#1abc9c"),
        primaryDarkColor: Color(hex: "#16a085"),
        mainFont: "Rubik-Medium"
    )
    
    struct VeoToastPreview: View {
        @State private var currentToast: VeoToastMessage?
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Group {
                        VeoText("Toast Examples", style: .title)
                        
                        VeoButton(
                            title: "Show Success Toast",
                            style: .info
                        ) {
                            currentToast = VeoToastMessage(
                                message: "Operation completed successfully!",
                                style: .success,
                                position: .top
                            )
                        }
                        
                        VeoButton(
                            title: "Show Error Toast",
                            style: .danger
                        ) {
                            currentToast = VeoToastMessage(
                                message: "An error occurred. Please try again.",
                                style: .error,
                                position: .topTrailing,
                                duration: 4
                            )
                        }
                        
                        VeoButton(
                            title: "Show Warning Toast",
                            style: .warning
                        ) {
                            currentToast = VeoToastMessage(
                                message: "Warning: Low storage space",
                                style: .warning,
                                position: .bottom
                            )
                        }
                        
                        VeoButton(
                            title: "Show Info Toast"
                        ) {
                            currentToast = VeoToastMessage(
                                message: "New features available!"
                            )
                        }
                        
                        VeoText("Arabic Examples", style: .title)
                        
                        VeoButton(
                            title: "عرض رسالة النجاح",
                            style: .primary,
                            textDirection: .trailing
                        ) {
                            VeoUI.isRTL = true
                            currentToast = VeoToastMessage(
                                message: "تمت العملية بنجاح! 🎉",
                                style: .success,
                                position: .bottom
                            )
                        }
                    }
                }
                
                VeoToast(currentToast: $currentToast)
            }
        }
    }
    
    return VeoToastPreview()
}
