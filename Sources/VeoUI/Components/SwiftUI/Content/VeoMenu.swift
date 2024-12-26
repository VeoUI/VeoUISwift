//
//  VeoMenu.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 26/12/2024.
//

import SwiftUI

public struct VeoMenu: View {
    public struct MenuData: Identifiable {
        public let id = UUID()
        public let identifier: String
        let icon: String
        let title: String
        let badgeCount: Int?
        let isFavorite: Bool

        public init(
            identifier: String,
            icon: String,
            title: String,
            badgeCount: Int? = nil,
            isFavorite: Bool = false)
        {
            self.identifier = identifier
            self.icon = icon
            self.title = title
            self.badgeCount = badgeCount
            self.isFavorite = isFavorite
        }
    }

    public struct MenuStyle {
        let backgroundColor: Color
        let cornerRadius: CGFloat
        let shadowColor: Color
        let shadowRadius: CGFloat
        let titleColor: Color
        let badgeColor: Color
        let favoriteColor: Color
        let iconSize: CGFloat

        public init(
            backgroundColor: Color = .white,
            cornerRadius: CGFloat = 16,
            shadowColor: Color = Color.gray.opacity(0.2),
            shadowRadius: CGFloat = 8,
            titleColor: Color = .black,
            badgeColor: Color = .red,
            favoriteColor: Color = .yellow,
            iconSize: CGFloat = 32)
        {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.shadowColor = shadowColor
            self.shadowRadius = shadowRadius
            self.titleColor = titleColor
            self.badgeColor = badgeColor
            self.favoriteColor = favoriteColor
            self.iconSize = iconSize
        }
    }

    private let data: MenuData
    private let style: MenuStyle
    private let action: () -> Void

    @State private var isPressed = false

    public init(
        data: MenuData,
        style: MenuStyle = MenuStyle(),
        action: @escaping () -> Void)
    {
        self.data = data
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                    action()
                }
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(style.backgroundColor)
                    .shadow(color: style.shadowColor, radius: style.shadowRadius, y: 2)

                VStack(spacing: 12) {
                    ZStack {
                        Image(systemName: data.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: style.iconSize, height: style.iconSize)
                            .foregroundColor(VeoUI.primaryColor)

                        if let count = data.badgeCount {
                            VStack {
                                HStack {
                                    Circle()
                                        .fill(style.badgeColor)
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            VeoText(
                                                "\(count)",
                                                style: .callout,
                                                alignment: .center,
                                                color: .white))
                                        .offset(x: -5, y: -5)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }

                        if data.isFavorite {
                            VStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "star.fill")
                                        .foregroundColor(style.favoriteColor)
                                        .offset(x: 5, y: -5)
                                }
                                Spacer()
                            }
                        }
                    }
                    VeoText(
                        data.title,
                        style: .headline,
                        alignment: .center,
                        color: style.titleColor)
                }
                .padding(12)
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#27ae60"),
        primaryDarkColor: Color(hex: "#2ecc71"),
        mainFont: "Tajawal-Bold")

    struct VeoMenuPreview: View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

        let menuItems: [VeoMenu.MenuData] = [
            .init(
                identifier: "moneyTransfer",
                icon: "creditcard",
                title: "تحويل الأموال",
                badgeCount: 3,
                isFavorite: true),

            .init(
                identifier: "currentBalance",
                icon: "dollarsign.circle",
                title: "رصيد الحساب",
                isFavorite: false),

            .init(
                identifier: "transactions",
                icon: "arrow.left.arrow.right",
                title: "المعاملات",
                badgeCount: 1),

            .init(
                identifier: "notifications",
                icon: "bell",
                title: "الإشعارات",
                badgeCount: 5),

            .init(
                identifier: "myProfile",
                icon: "person",
                title: "حسابي",
                isFavorite: true),

            .init(
                identifier: "settings",
                icon: "gear",
                title: "الإعدادات"),

            .init(
                identifier: "help",
                icon: "questionmark.circle",
                title: "المساعدة"),

            .init(
                identifier: "contactUs",
                icon: "phone",
                title: "اتصل بنا"),

            .init(
                identifier: "logOut",
                icon: "rectangle.portrait.and.arrow.right",
                title: "تسجيل الخروج")
        ]

        var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(menuItems) { item in
                            VeoMenu(data: item, style: .init(
                                backgroundColor: .white,
                                cornerRadius: 16,
                                shadowColor: Color.gray.opacity(0.2),
                                shadowRadius: 8,
                                titleColor: VeoUI.primaryDarkColor,
                                badgeColor: .red,
                                favoriteColor: .yellow,
                                iconSize: 32))
                            {
                                handleMenuTap(item)
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .background(Color.gray.opacity(0.1))
        }

        private func handleMenuTap(_ item: VeoMenu.MenuData) {
            print(item.identifier)
        }
    }

    return VeoMenuPreview()
}
