//
//  VeoSidebar.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 17/12/2024.
//

import SwiftUI

public struct VeoSidebar: View {
    let config: VeoSidebarConfig
    let menuItems: [VeoSidebarItem]
    @Binding var selectedItem: VeoSidebarItem?
    @Binding var isShowing: Bool
    @State private var dragOffset: CGFloat = 0

    public init(
        config: VeoSidebarConfig,
        menuItems: [VeoSidebarItem],
        selectedItem: Binding<VeoSidebarItem?>,
        isShowing: Binding<Bool>)
    {
        self.config = config
        self.menuItems = menuItems
        _selectedItem = selectedItem
        _isShowing = isShowing
    }

    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                if VeoUI.isRTL {
                    sidebarContent
                    Spacer()
                } else {
                    Spacer()
                    sidebarContent
                }
            }
            .frame(width: geometry.size.width)
            .offset(x: sidebarOffset(width: config.width))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translation = VeoUI.isRTL ? -value.translation.width : value.translation.width
                        if isShowing {
                            dragOffset = min(0, translation)
                        } else {
                            dragOffset = max(0, translation)
                        }
                    }
                    .onEnded { value in
                        let translation = VeoUI.isRTL ? -value.translation.width : value.translation.width
                        withAnimation(.spring(response: 0.3)) {
                            if isShowing, translation < -50 {
                                isShowing = false
                            } else if !isShowing, translation > 50 {
                                isShowing = true
                            }
                            dragOffset = 0
                        }
                    })
        }.onAppear(perform: {
            selectedItem = menuItems.first
        })
    }

    private var sidebarContent: some View {
        ZStack {
            config.backgroundColor
                .edgesIgnoringSafeArea(.vertical)

            VStack(spacing: 20) {
                Image(config.topLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top, 30)

                VeoText(config.headerText, style: .title, color: config.textColor)

                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(menuItems) { item in
                            menuItemView(item: item)
                        }
                    }
                    .padding(.vertical)
                }

                Spacer()

                if let bottomLogo = config.bottomLogo {
                    Image(bottomLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(.bottom, 20)
                }
            }
        }
        .frame(width: config.width)
    }

    private func sidebarOffset(width: CGFloat) -> CGFloat {
        let baseOffset = isShowing ? 0 : (!VeoUI.isRTL ? width : -width)
        let dragDirection = !VeoUI.isRTL ? -1 : 1
        return baseOffset + (dragOffset * CGFloat(dragDirection))
    }

    private func menuItemView(item: VeoSidebarItem) -> some View {
        HStack(spacing: 15) {
            Circle()
                .fill(config.selectedColor)
                .frame(width: 12, height: 12)
                .opacity(selectedItem?.id == item.id ? 1 : 0)

            Image(systemName: item.icon)
                .foregroundColor(config.textColor)
                .frame(width: 32, height: 32)

            VeoText(item.title, style: .subtitle, color: config.textColor)

            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(selectedItem?.id == item.id ? 0.1 : 0))
                .padding(.horizontal, 10))
        .onTapGesture {
            selectedItem = item
            item.action?()
            withAnimation {
                isShowing = false
            }
        }
    }

    public struct VeoSidebarItem: Identifiable {
        public let id: Int
        let icon: String
        let title: String
        var action: (() -> Void)? = nil

        public init(id: Int, icon: String, title: String, action: (() -> Void)? = nil) {
            self.id = id
            self.icon = icon
            self.title = title
            self.action = action
        }
    }

    public struct VeoSidebarConfig {
        let topLogo: String
        let headerText: String
        let bottomLogo: String?
        let width: CGFloat
        let backgroundColor: Color
        let selectedColor: Color
        let textColor: Color

        public init(
            topLogo: String,
            headerText: String,
            bottomLogo: String?,
            width: CGFloat,
            backgroundColor: Color,
            selectedColor: Color,
            textColor: Color)
        {
            self.topLogo = topLogo
            self.headerText = headerText
            self.bottomLogo = bottomLogo
            self.width = width
            self.backgroundColor = backgroundColor
            self.selectedColor = selectedColor
            self.textColor = textColor
        }
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#27ae60"),
        primaryDarkColor: Color(hex: "#2ecc71"),
        isRTL: true,
        mainFont: "Rubik-Bold")

    struct HomeView: View {
        var body: some View {
            VStack {
                VeoText(
                    "الصفحة الرئيسية",
                    style: .title,
                    color: VeoUI.primaryColor)
            }
        }
    }

    struct ProfileView: View {
        var body: some View {
            VStack {
                VeoText(
                    "حسابي",
                    style: .title,
                    color: VeoUI.primaryColor)
            }
        }
    }

    struct SettingsView: View {
        var body: some View {
            VStack {
                VeoText(
                    "الإعدادات",
                    style: .title,
                    color: VeoUI.primaryColor)
            }
        }
    }

    struct NotificationsView: View {
        var body: some View {
            VStack {
                VeoText(
                    "الإشعارات",
                    style: .title,
                    color: VeoUI.primaryColor)
            }
        }
    }

    struct HelpView: View {
        var body: some View {
            VStack {
                VeoText(
                    "المساعدة",
                    style: .title,
                    color: VeoUI.primaryColor)
            }
        }
    }

    struct VeoSidebarPreview: View {
        @State private var isSidebarShowing = false
        @State private var showLogoutAlert = false
        @State private var selectedMenuItem: VeoSidebar.VeoSidebarItem?

        var menuItems: [VeoSidebar.VeoSidebarItem] {
            [
                .init(id: 0, icon: "house.fill", title: "الرئيسية"),
                .init(id: 1, icon: "person.fill", title: "حسابي"),
                .init(id: 2, icon: "gear", title: "الإعدادات"),
                .init(id: 3, icon: "bell.fill", title: "الإشعارات"),
                .init(id: 4, icon: "questionmark.circle", title: "مساعدة"),
                .init(
                    id: 5,
                    icon: "rectangle.portrait.and.arrow.right",
                    title: "تسجيل الخروج",
                    action: {
                        showLogoutAlert = true
                    })
            ]
        }

        let sidebarConfig = VeoSidebar.VeoSidebarConfig(
            topLogo: "logo",
            headerText: "تدويناتي",
            bottomLogo: "logo",
            width: 280,
            backgroundColor: VeoUI.primaryColor,
            selectedColor: VeoUI.dangerColor,
            textColor: .white)

        var body: some View {
            ZStack {
                VStack {
                    HStack {
                        if VeoUI.isRTL {
                            menuButton
                            Spacer()
                        } else {
                            Spacer()
                            menuButton
                        }
                    }

                    if let selectedItem = self.selectedMenuItem {
                        switch selectedItem.id {
                        case 0: HomeView()
                        case 1: ProfileView()
                        case 2: SettingsView()
                        case 3: NotificationsView()
                        case 4: HelpView()
                        default: EmptyView()
                        }
                    } else {
                        HomeView()
                    }

                    Spacer()
                }

                if isSidebarShowing {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isSidebarShowing = false
                            }
                        }
                }

                VeoSidebar(
                    config: sidebarConfig,
                    menuItems: menuItems,
                    selectedItem: $selectedMenuItem,
                    isShowing: $isSidebarShowing)
            }
            .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
            .alert("تسجيل الخروج", isPresented: $showLogoutAlert) {
                Button("إلغاء", role: .cancel) {}
                Button("تأكيد", role: .destructive) {
                    isSidebarShowing = false
                }
            } message: {
                Text("هل أنت متأكد من تسجيل الخروج؟")
            }
        }

        private var menuButton: some View {
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    isSidebarShowing.toggle()
                }
            }) {
                Image(systemName: "line.horizontal.3")
                    .font(.title)
                    .foregroundColor(.black)
            }
            .padding()
        }
    }

    return VeoSidebarPreview()
}
