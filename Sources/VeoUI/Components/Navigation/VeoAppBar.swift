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
            VStack(spacing: 0) {
                VeoAppBar(appName: "تدويناتي")

                VeoIconButton(
                    icon: "plus.circle",
                    title: "إضافة تدوينة")
                {
                    print("Add post tapped")
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
                .clipShape(RoundedCorner(radius: 32, corners: [.topLeft, .topRight]))
            }
            .background(
                LinearGradient(
                    colors: [
                        VeoUI.primaryColor,
                        VeoUI.primaryDarkColor
                    ],
                    startPoint: .top,
                    endPoint: .bottom))
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
