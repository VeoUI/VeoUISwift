//
//  VeoAppBar.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoAppBar: View {
    var appName: String

    public var body: some View {
        ZStack {
            HStack {
                VeoIcon(
                    icon: .common(.menu),
                    color: .white,
                    action: {
                        
                    })
                
                VeoText(appName, style: .title, color: .white)

                Spacer()

                VeoIcon(
                    icon: .common(.bell),
                    color: .white)

                VeoIcon(
                    icon: .common(.logout),
                    color: .white)
            }
            .padding(16)
            .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
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

    struct VeoAppBarPreview: View {
        
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
        
        let posts: [VeoPost.PostData] = [
            .init(
                userAvatar: "photo1",
                userName: "أمينة أحمد",
                badgeContent: "مستخدم جديد",
                date: "01/01/2024",
                content: "مرحبا بالجميع",
                actionButtonTitle: "شارك الآن",
                likes: 24,
                comments: 8),
            .init(
                userAvatar: "photo2",
                userName: "أمينة أحمد",
                badgeContent: "مستخدم جديد",
                date: "01/01/2024",
                content: "مرحبا بالجميع",
                actionButtonTitle: "شارك الآن",
                likes: 24,
                comments: 8),
            .init(
                userAvatar: "photo3",
                userName: "أمينة أحمد",
                badgeContent: "مستخدم جديد",
                date: "01/01/2024",
                content: "مرحبا بالجميع",
                actionButtonTitle: "شارك الآن",
                likes: 24,
                comments: 8),
            .init(
                userAvatar: "photo4",
                userName: "أمينة أحمد",
                badgeContent: "مستخدم جديد",
                date: "01/01/2024",
                content: "مرحبا بالجميع",
                actionButtonTitle: "شارك الآن",
                likes: 24,
                comments: 8)
        ]

        var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    VeoAppBar(appName: "تدويناتي")
                    
                    VeoIconButton(
                        icon: "plus.circle",
                        title: "إضافة تدوينة")
                    {
                        print("Add post tapped")
                        withAnimation(.spring(response: 0.3)) {
                            isSidebarShowing.toggle()
                        }
                    }.padding()
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(posts, id: \.id) { post in
                                VeoPost(
                                    data: post,
                                    onLike: {},
                                    onComment: {},
                                    onAction: {
                                        print("Post Id = \(post.id)")
                                    })
                            }
                        }
                        .padding(16)
                    }
                    .background(Color.white)
                    .scrollIndicators(.hidden)
                    .clipShape(RoundedCorner(radius: 32, corners: [.topLeft, .topRight]))
                }
                .ignoresSafeArea(.container, edges: .bottom)
                .background(
                    LinearGradient(
                        colors: [
                            VeoUI.primaryColor,
                            VeoUI.primaryDarkColor
                        ],
                        startPoint: .top,
                        endPoint: .bottom))
               
                
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
            }.environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
                .alert("تسجيل الخروج", isPresented: $showLogoutAlert) {
                    Button("إلغاء", role: .cancel) {}
                    Button("تأكيد", role: .destructive) {
                        isSidebarShowing = false
                    }
                } message: {
                    Text("هل أنت متأكد من تسجيل الخروج؟")
                }
        }
    }

    struct RoundedCorner: Shape {
        var radius: CGFloat = .infinity
        var corners: UIRectCorner = .allCorners
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    return VeoAppBarPreview()
}
