//
//  VeoRow.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 26/12/2024.
//

import SwiftUI

public struct VeoRow: View {
    public struct RowData: Identifiable {
        public let id = UUID()
        let image: String?
        let imageURL: String?
        let title: String
        let subtitle: String?
        let badge: BadgeData?
        let rightContent: RightContentType
        let isRead: Bool?
        
        public init(
            image: String? = nil,
            imageURL: String? = nil,
            title: String,
            subtitle: String? = nil,
            badge: BadgeData? = nil,
            rightContent: RightContentType = .none,
            isRead: Bool? = nil
        ) {
            self.image = image
            self.imageURL = imageURL
            self.title = title
            self.subtitle = subtitle
            self.badge = badge
            self.rightContent = rightContent
            self.isRead = isRead
        }
    }
    
    public struct BadgeData {
        let text: String
        let color: Color
        
        @MainActor
        public init(text: String, color: Color = VeoUI.primaryColor) {
            self.text = text
            self.color = color
        }
    }
    
    public enum RightContentType {
        case none
        case button(title: String, action: () -> Void)
        case icon(systemName: String, action: () -> Void)
        case toggle(isOn: Binding<Bool>)
    }
    
    private let data: RowData
    private let onTap: () -> Void
    private let style: RowStyle
    @State private var isPressed = false
    
    public struct RowStyle {
        let backgroundColor: Color
        let cornerRadius: CGFloat
        let shadowRadius: CGFloat
        let imageSize: CGFloat
        let padding: EdgeInsets
        
        @MainActor
        public static let standard = RowStyle(
            backgroundColor: .white,
            cornerRadius: 16,
            shadowRadius: 5,
            imageSize: 48,
            padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        )
        
        public init(
            backgroundColor: Color = .white,
            cornerRadius: CGFloat = 16,
            shadowRadius: CGFloat = 5,
            imageSize: CGFloat = 48,
            padding: EdgeInsets = EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        ) {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.shadowRadius = shadowRadius
            self.imageSize = imageSize
            self.padding = padding
        }
    }
    
    public init(
        data: RowData,
        style: RowStyle = .standard,
        onTap: @escaping () -> Void = {}
    ) {
        self.data = data
        self.style = style
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
            onTap()
        }) {
            HStack(spacing: 12) {
                if let imageURL = data.imageURL {
                    VeoImage(url: imageURL,
                             cornerRadius: 50,
                             maxWidth: style.imageSize,
                             maxHeight: style.imageSize)
                } else if let image = data.image {
                    VeoImage(name: image,
                             cornerRadius: 50,
                             maxWidth: style.imageSize,
                             maxHeight: style.imageSize)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        VeoText(data.title)
                            .lineLimit(1)
                        
                        if let badge = data.badge {
                            VeoBadge(text: badge.text, textColor: badge.color)
                        }
                    }
                    
                    if let subtitle = data.subtitle {
                        VeoText(subtitle, style: .caption)
                            .lineLimit(2)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                switch data.rightContent {
                case .none:
                    EmptyView()
                case .button(let title, let action):
                    VeoButton(
                        title: title,
                        style: .primary,
                        shape: .custom(cornerRadius: 8),
                        elevation: 0,
                        action: action
                    )
                case .icon(let systemName, let action):
                    Button(action: action) {
                        Image(systemName: systemName)
                            .foregroundColor(VeoUI.primaryColor)
                            .font(.system(size: 20))
                    }
                case .toggle(let isOn):
                    Toggle("", isOn: isOn)
                        .labelsHidden()
                }
            }
            .padding(style.padding)
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(style.backgroundColor)
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: style.shadowRadius,
                        x: 0,
                        y: 2
                    )
            )
            .opacity(data.isRead == false ? 1 : 0.8)
            .scaleEffect(isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
    }
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#27ae60"),
        primaryDarkColor: Color(hex: "#2ecc71"),
        mainFont: "Rubik-Regular"
    )
    
    struct VeoRowPreview: View {
        @State private var toggleStates: [Bool] = [false, true, false]
        
        let rows: [VeoRow.RowData] = [
            .init(
                imageURL: "photo1",
                title: "John Doe",
                subtitle: "Software Engineer",
                badge: .init(text: "New", color: .blue),
                rightContent: .button(title: "Follow", action: {})
            ),
            .init(
                imageURL: "photo2",
                title: "Sarah Smith",
                subtitle: "Product Designer",
                rightContent: .icon(systemName: "message.fill", action: {})
            ),
            
            .init(
                imageURL: "bell",
                title: "New Message",
                subtitle: "You have a new message from Alex",
                badge: .init(text: "1m ago", color: .gray),
                rightContent: .none,
                isRead: false
            ),
            .init(
                imageURL: "bell",
                title: "System Update",
                subtitle: "Your app has been updated to version 2.0",
                rightContent: .none,
                isRead: true
            ),
            
            .init(
                imageURL: "gear",
                title: "Push Notifications",
                subtitle: "Receive notifications for new messages",
                rightContent: .toggle(isOn: .init(
                    get: { true },
                    set: { _ in }
                ))
            )
        ]
        
        var body: some View {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(rows) { row in
                        VeoRow(
                            data: row,
                            onTap: {
                                print("Tapped row: \(row.title)")
                            }
                        )
                    }
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
        }
    }
    
    return VeoRowPreview()
}
