//
//  VeoComment.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 29/12/2024.
//

import SwiftUI

public struct CommentData {
    let index: Int
    let username: String
    let date: Date
    let content: String
    let likes: Int?
    let dislikes: Int?
    
    public init(index: Int, username: String, date: Date, content: String, likes: Int? = nil, dislikes: Int? = nil) {
        self.index = index
        self.username = username
        self.date = date
        self.content = content
        self.likes = likes
        self.dislikes = dislikes
    }
}

public struct VeoComment: View {
    let comment: CommentData
    var onLikeTapped: (() -> Void)?
    var onDislikeTapped: (() -> Void)?
    
    public init(comment: CommentData, onLikeTapped: (() -> Void)? = nil, onDislikeTapped: (() -> Void)? = nil) {
        self.comment = comment
        self.onLikeTapped = onLikeTapped
        self.onDislikeTapped = onDislikeTapped
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                if let channelImage = UIImage(systemName: "\(comment.index).circle.fill") {
                    Image(uiImage: channelImage)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    VeoText(comment.username,
                            style: .headline,
                            color: VeoUI.primaryDarkColor)
                    VeoText(dateFormatter.string(from: comment.date), style: .caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            VeoText(comment.content, style: .body,
                    lineSpacing: 6)
                .fixedSize(horizontal: false, vertical: true)
            
            if comment.likes != nil || comment.dislikes != nil {
                HStack(spacing: 16) {
                    Spacer()
                    
                    if let likes = comment.likes {
                        Button(action: { onLikeTapped?() }) {
                            HStack(spacing: 4) {
                                Image(systemName: "hand.thumbsup")
                                VeoText("\(likes)", style: .caption)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(.gray)
                    }
                    
                    if let dislikes = comment.dislikes {
                        Button(action: { onDislikeTapped?() }) {
                            HStack(spacing: 4) {
                                Image(systemName: "hand.thumbsdown")
                                VeoText("\(dislikes)", style: .caption)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
    }
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        secondaryColor: Color(hex: "#3498db"),
        isRTL: true,
        mainFont: "Tajawal-Bold")
    
    let sampleComment = CommentData(
        index: 2,
        username: "أحمد شكري",
        date: Date(),
        content: "هذا تطور رائع في مجال التكنولوجيا. أتفق تماماً مع ما تم ذكره في المقال.",
        likes: 373,
        dislikes: nil
    )
    
    return VStack(spacing: 16) {
        VeoComment(
            comment: sampleComment,
            onLikeTapped: { print("Like tapped") },
            onDislikeTapped: { print("Dislike tapped") }
        )
        
        VeoComment(
            comment: CommentData(
                index: 1,
                username: "John Doe",
                date: Date(),
                content: "This is a sample comment with both like and dislike buttons.",
                likes: 42,
                dislikes: 5
            ),
            onLikeTapped: { print("Like tapped") },
            onDislikeTapped: { print("Dislike tapped") }
        )
        
        VeoComment(
            comment: CommentData(
                index: 3,
                username: "Jane Smith",
                date: Date(),
                content: "This is a sample comment without any reaction buttons.",
                likes: nil,
                dislikes: nil
            )
        )
    }
    .padding()
}
