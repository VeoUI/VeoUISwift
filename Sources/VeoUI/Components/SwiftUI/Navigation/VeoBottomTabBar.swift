//
//  VeoBottomTabBar.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 18/12/2024.
//

import SwiftUI

public struct VeoBottomTabBar: View {
    public struct TabItem: Identifiable {
        public let id = UUID()
        let icon: String
        let title: String
        
        public init(icon: String, title: String) {
            self.icon = icon
            self.title = title
        }
    }

    @Binding var selectedIndex: Int
    let items: [TabItem]

    public init(selectedIndex: Binding<Int>, items: [TabItem]) {
        _selectedIndex = selectedIndex
        self.items = items
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: 4) {
                    Image(systemName: item.icon)
                        .font(.system(size: 24))

                    VeoText(
                        item.title,
                        style: selectedIndex == index ? .subtitle : .caption,
                        color: selectedIndex == index ? VeoUI.primaryColor : .black)

                    Circle()
                        .fill(VeoUI.primaryColor)
                        .frame(width: 4, height: 4)
                        .scaleEffect(selectedIndex == index ? 1 : 0)
                        .opacity(selectedIndex == index ? 1 : 0)
                }
                .foregroundColor(selectedIndex == index ? VeoUI.primaryColor : .gray)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedIndex = index
                    }
                }
            }
        }
        .padding(.vertical, 12)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: -5))
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#27ae60"),
        primaryDarkColor: Color(hex: "#2ecc71"),
        isRTL: true,
        mainFont: "Rubik-Bold")

    struct VeoBottomTabBarPreview: View {
        @State private var selectedIndex = 0

        let items: [VeoBottomTabBar.TabItem] = [
            .init(
                icon: "house.fill",
                title: "الرئيسية"),
            .init(icon: "magnifyingglass", title: "البحث"),
            .init(icon: "plus.circle.fill", title: "جديد"),
            .init(icon: "bell.fill", title: "الإشعارات"),
            .init(icon: "person.fill", title: "حسابي")
        ]

        var body: some View {
            ZStack {
                Color.gray.opacity(0.1)
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    VeoBottomTabBar(selectedIndex: $selectedIndex, items: items)
                }
            }.ignoresSafeArea(.container, edges: .bottom)
                .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
        }
    }

    return VeoBottomTabBarPreview()
}
