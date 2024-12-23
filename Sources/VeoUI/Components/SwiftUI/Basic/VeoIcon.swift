//
//  VeoIcon.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoIcon: View {
    public enum IconType {
        case system(String)
        case custom(String)
        case common(CommonIcons)
    }

    let icon: IconType
    var size: CGFloat = 24
    var color: Color = .primary
    var weight: Font.Weight = .regular
    var renderingMode: Image.TemplateRenderingMode = .template
    var isEnabled = true
    var background: Color? = nil
    var backgroundOpacity = 0.1
    var padding: CGFloat = 4
    var action: (() -> Void)? = nil
    
    public init(
        icon: IconType,
        size: CGFloat = 24,
        color: Color = .primary,
        weight: Font.Weight = .regular,
        renderingMode: Image.TemplateRenderingMode = .template,
        isEnabled: Bool = true,
        background: Color? = nil,
        backgroundOpacity: Double = 0.1,
        padding: CGFloat = 4,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.size = size
        self.color = color
        self.weight = weight
        self.renderingMode = renderingMode
        self.isEnabled = isEnabled
        self.background = background
        self.backgroundOpacity = backgroundOpacity
        self.padding = padding
        self.action = action
    }
    
    private var iconImage: Image {
        switch icon {
        case let .system(name):
            return Image(systemName: name)
        case let .custom(name):
            return Image(name)
        case let .common(common):
            return Image(systemName: common.rawValue)
        }
    }

    public var body: some View {
        iconImage
            .font(.system(size: size, weight: weight))
            .foregroundColor(isEnabled ? color : .gray)
            .frame(width: size, height: size)
            .padding(padding)
            .background(
                Group {
                    if let background = background {
                        Circle()
                            .fill(background.opacity(backgroundOpacity))
                    }
                })
            .opacity(isEnabled ? 1 : 0.5)
            .onTapGesture {
                action?()
            }
    }
}

extension VeoIcon {
    public enum CommonIcons: String {
        case home = "house.fill"
        case back = "chevron.left"
        case forward = "chevron.right"
        case menu = "line.3.horizontal"
        case bell
        case logout = "rectangle.portrait.and.arrow.right"

        case add = "plus"
        case delete = "trash"
        case edit = "pencil"
        case share = "square.and.arrow.up"

        case message
        case email = "envelope"
        case call = "phone"
        case video

        case success = "checkmark.circle"
        case error = "xmark.circle"
        case warning = "exclamationmark.triangle"
        case info = "info.circle"

        case photo
        case camera
        case mic
        case play = "play.circle"

        case search = "magnifyingglass"
        case settings = "gear"
        case user = "person.circle"
        case calendar
    }

    static func common(_ icon: CommonIcons, size: CGFloat = 24) -> VeoIcon {
        VeoIcon(icon: .system(icon.rawValue), size: size)
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Rubik-Regular")

    struct VeoIconPreview: View {
        var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    Group {
                        Text("Basic Icons").font(.headline)
                        HStack(spacing: 20) {
                            VeoIcon(icon: .system("star.fill"))
                            VeoIcon(icon: .system("heart.fill"), color: .red)
                            VeoIcon(icon: .system("bell.fill"), color: .blue)
                            VeoIcon(icon: .system("bookmark.fill"), color: .green)
                        }
                    }

                    Divider()

                    Group {
                        Text("Icon Sizes").font(.headline)
                        HStack(spacing: 20) {
                            VeoIcon(icon: .system("star.fill"), size: 16)
                            VeoIcon(icon: .system("star.fill"), size: 24)
                            VeoIcon(icon: .system("star.fill"), size: 32)
                            VeoIcon(icon: .system("star.fill"), size: 40)
                        }
                    }

                    Divider()

                    Group {
                        Text("Navigation Icons").font(.headline)
                        HStack(spacing: 20) {
                            VeoIcon.common(.home)
                            VeoIcon.common(.back)
                            VeoIcon.common(.forward)
                            VeoIcon.common(.menu)
                        }
                    }

                    Divider()

                    Group {
                        Text("Action Icons").font(.headline)
                        HStack(spacing: 20) {
                            VeoIcon.common(.add, size: 28)
                            VeoIcon.common(.delete, size: 28)
                            VeoIcon.common(.edit, size: 28)
                            VeoIcon.common(.share, size: 28)
                        }
                    }

                    Divider()

                    Group {
                        Text("Icons with Background").font(.headline)
                        HStack(spacing: 20) {
                            VeoIcon(
                                icon: .system("star.fill"),
                                color: .yellow,
                                background: .yellow)
                            VeoIcon(
                                icon: .system("heart.fill"),
                                color: .red,
                                background: .red)
                            VeoIcon(
                                icon: .system("bell.fill"),
                                color: .blue,
                                background: .blue)
                        }
                    }

                    Divider()

                    Group {
                        Text("Icon Weights").font(.headline)
                        HStack(spacing: 20) {
                            VeoIcon(
                                icon: .system("star.fill"),
                                weight: .light)
                            VeoIcon(
                                icon: .system("star.fill"),
                                weight: .regular)
                            VeoIcon(
                                icon: .system("star.fill"),
                                weight: .medium)
                            VeoIcon(
                                icon: .system("star.fill"),
                                weight: .bold)
                        }
                    }

                    Divider()

                    Group {
                        Text("Enabled vs Disabled").font(.headline)
                        HStack(spacing: 20) {
                            VeoIcon(
                                icon: .system("star.fill"),
                                isEnabled: true)
                            VeoIcon(
                                icon: .system("star.fill"),
                                isEnabled: false)
                        }
                    }

                    Group {
                        Text("Common Use Cases").font(.headline)

                        HStack(spacing: 24) {
                            VeoIcon.common(.menu)
                            Spacer()
                            VeoIcon.common(.search)
                            VeoIcon.common(.user)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)

                        HStack(spacing: 24) {
                            VeoIcon.common(.camera)
                            VeoIcon.common(.photo)
                            VeoIcon.common(.mic)
                            VeoIcon.common(.play)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
    }

    return VeoIconPreview()
}
