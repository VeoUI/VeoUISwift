//
//  VeoPost.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoPost: View {
    public struct PostData: Identifiable {
        public let id = UUID()
        let userAvatar: String
        let userName: String
        let badgeContent: String?
        let date: String
        let content: String
        let actionButtonTitle: String?
        let likes: Int?
        let comments: Int?

        public init(
            userAvatar: String,
            userName: String,
            badgeContent: String?,
            date: String,
            content: String,
            actionButtonTitle: String?,
            likes: Int?,
            comments: Int?)
        {
            self.userAvatar = userAvatar
            self.userName = userName
            self.badgeContent = badgeContent
            self.date = date
            self.content = content
            self.actionButtonTitle = actionButtonTitle
            self.likes = likes
            self.comments = comments
        }
    }

    @MainActor
    public struct PostStyle {
        let backgroundColor: Color
        let cornerRadius: CGFloat
        let shadowColor: Color
        let shadowRadius: CGFloat
        let badgeColor: Color
        let primaryTextColor: Color
        let secondaryTextColor: Color
        let actionButtonColor: Color
        let padding: EdgeInsets
        let font: PostFontConfig

        public init(
            backgroundColor: Color,
            cornerRadius: CGFloat,
            shadowColor: Color,
            shadowRadius: CGFloat,
            badgeColor: Color,
            primaryTextColor: Color,
            secondaryTextColor: Color,
            actionButtonColor: Color,
            padding: EdgeInsets,
            font: PostFontConfig)
        {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.shadowColor = shadowColor
            self.shadowRadius = shadowRadius
            self.badgeColor = badgeColor
            self.primaryTextColor = primaryTextColor
            self.secondaryTextColor = secondaryTextColor
            self.actionButtonColor = actionButtonColor
            self.padding = padding
            self.font = font
        }

        @MainActor
        public struct PostFontConfig {
            let userName: Font
            let newUserBadge: Font
            let location: Font
            let rating: Font
            let date: Font
            let content: Font
            let stats: Font
            let actionButton: Font

            public init(
                userName: Font,
                newUserBadge: Font,
                location: Font,
                rating: Font,
                date: Font,
                content: Font,
                stats: Font,
                actionButton: Font)
            {
                self.userName = userName
                self.newUserBadge = newUserBadge
                self.location = location
                self.rating = rating
                self.date = date
                self.content = content
                self.stats = stats
                self.actionButton = actionButton
            }

            public static let standard = PostFontConfig(
                userName: .system(size: 16, weight: .bold),
                newUserBadge: .system(size: 12),
                location: .system(size: 14),
                rating: .system(size: 14),
                date: .system(size: 12),
                content: .system(size: 15),
                stats: .system(size: 14),
                actionButton: .system(size: 14, weight: .bold))
        }

        public static let standard = PostStyle(
            backgroundColor: .white,
            cornerRadius: 20,
            shadowColor: Color.gray.opacity(0.2),
            shadowRadius: 8,
            badgeColor: VeoUI.primaryDarkColor,
            primaryTextColor: .black,
            secondaryTextColor: .gray,
            actionButtonColor: VeoUI.primaryDarkColor,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            font: .standard)
    }

    private let data: PostData
    private let style: PostStyle
    private let onLike: () -> Void
    private let onComment: () -> Void
    private let onAction: () -> Void

    public init(
        data: PostData,
        style: PostStyle = .standard,
        onLike: @escaping () -> Void = {},
        onComment: @escaping () -> Void = {},
        onAction: @escaping () -> Void = {})
    {
        self.data = data
        self.style = style
        self.onLike = onLike
        self.onComment = onComment
        self.onAction = onAction
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Image(data.userAvatar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        VeoText(data.userName)
                            .foregroundColor(style.primaryTextColor)

                        if let badgeContent = data.badgeContent {
                            VeoBadge(text: badgeContent, textColor: style.badgeColor)
                        }
                    }

                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .foregroundColor(style.secondaryTextColor)
                            VeoText(data.date)
                                .foregroundColor(style.secondaryTextColor)
                        }
                    }
                }
            }
            .padding(style.padding)

            VeoText(data.content)
                .foregroundColor(style.primaryTextColor)
                .padding(.horizontal, style.padding.leading)

            HStack {
                if let postLikesNumber = data.likes {
                    HStack(spacing: 4) {
                        Button(action: onLike) {
                            Image(systemName: "heart")
                                .foregroundColor(style.primaryTextColor)
                        }
                        VeoText("\(postLikesNumber)")
                            .foregroundColor(style.primaryTextColor)
                    }
                }

                if let postCommentsNumber = data.comments {
                    HStack(spacing: 4) {
                        Button(action: onComment) {
                            Image(systemName: "message")
                                .foregroundColor(style.primaryTextColor)
                        }
                        VeoText("\(postCommentsNumber)")
                            .foregroundColor(style.primaryTextColor)
                    }
                }

                Spacer()

                if let actionButtonTitle = data.actionButtonTitle {
                    VeoIconButton(
                        icon: "square.and.arrow.up",
                        title: actionButtonTitle,
                        style: .init(
                            backgroundColor: style.actionButtonColor,
                            foregroundColor: .white,
                            cornerRadius: 10,
                            font: VeoFont.callout(),
                            horizontalPadding: 12,
                            verticalPadding: 6),
                        action: onAction)
                }
            }
            .padding(style.padding)
        }
        .background(style.backgroundColor)
        .cornerRadius(style.cornerRadius)
        .shadow(color: style.shadowColor, radius: style.shadowRadius, y: 3)
        .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#27ae60"),
        primaryDarkColor: Color(hex: "#2ecc71"),
        mainFont: "Fresca-Regular")

    struct VeoPostPreview: View {
        let posts = [
            VeoPost.PostData(
                userAvatar: "photo1",
                userName: "John Smith",
                badgeContent: "New User",
                date: "01/01/2024",
                content: "Looking for recommendations on the best restaurants in downtown. Any suggestions ?",
                actionButtonTitle: "Share",
                likes: 24,
                comments: 8)
        ]

        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(posts, id: \.userName) { post in
                        VeoPost(
                            data: post,
                            onLike: {},
                            onComment: {},
                            onAction: {})
                    }
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
        }
    }

    return VeoPostPreview()
}
