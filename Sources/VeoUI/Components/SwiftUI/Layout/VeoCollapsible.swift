//
//  VeoCollapsible.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 1/1/2025.
//

import SwiftUI

public struct VeoCollapsible<Content: View>: View {
    let title: String
    let content: () -> Content
    var icon: VeoIcon.IconType?
    var style: CollapsibleStyle
    var showDividers: Bool
    
    @State private var isExpanded = false
    
    public enum CollapsibleStyle {
        case plain
        case card
        case bordered
    }
    
    public init(
        title: String,
        icon: VeoIcon.IconType? = nil,
        style: CollapsibleStyle = .plain,
        showDividers: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.showDividers = showDividers
        self.content = content
    }
    
    private var headerView: some View {
        HStack {
            if let icon = icon {
                VeoIcon(icon: icon, color: VeoUI.primaryColor)
                    .padding(.trailing, 8)
            }
            
            VeoText(title, style: .headline)
            
            Spacer()
            
            VeoIcon(
                icon: .common(.forward),
                color: .gray
            )
            .rotationEffect(.degrees(isExpanded ? 90 : 0))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .background(style == .card ? Color(.systemBackground) : Color.clear)
    }
    
    private var contentView: some View {
        VStack {
            if showDividers {
                Divider()
            }
            
            content()
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
        }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                headerView
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                contentView
            }
        }
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style == .bordered ? Color.gray.opacity(0.2) : Color.clear, lineWidth: 1)
        )
        .shadow(
            color: style == .card ? Color.black.opacity(0.1) : Color.clear,
            radius: 4,
            x: 0,
            y: 2
        )
    }
    
    private var backgroundColor: Color {
        switch style {
        case .plain:
            return .clear
        case .card:
            return Color(.systemBackground)
        case .bordered:
            return .clear
        }
    }
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Rubik-Regular"
    )
    
    struct VeoCollapsiblePreview: View {
        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        VeoText("Plain Style", style: .title3)
                        
                        VeoCollapsible(
                            title: "Basic Information",
                            icon: .common(.info),
                            style: .plain
                        ) {
                            VeoText("This is a plain style collapsible with icon and divider.",
                                   style: .body)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VeoText("Card Style", style: .title3)
                        
                        VeoCollapsible(
                            title: "Settings",
                            icon: .common(.settings),
                            style: .card
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                VeoText("Card style with shadow and rounded corners.",
                                       style: .body)
                                
                                VeoButton(title: "Action Button") {
                                    print("Button tapped")
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VeoText("Bordered Style", style: .title3)
                        
                        VeoCollapsible(
                            title: "Additional Options",
                            icon: .common(.add),
                            style: .bordered
                        ) {
                            ForEach(1...3, id: \.self) { num in
                                HStack {
                                    VeoIcon(icon: .common(.success), color: .green)
                                    VeoText("Option \(num)", style: .body)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VeoText("RTL Support", style: .title3)
                        
                        VeoCollapsible(
                            title: "معلومات إضافية",
                            icon: .common(.info),
                            style: .card
                        ) {
                            VeoText("هذا مثال على المحتوى باللغة العربية", style: .body)
                        }
                        .environment(\.layoutDirection, .rightToLeft)
                    }
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
        }
    }
    
    return VeoCollapsiblePreview()
}
