//
//  PostsViewModel.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 23/12/2024.
//

import SwiftUI
import VeoUI

@MainActor
final class PostsViewModel: ObservableObject {
    private var posts: [Post] = []
    @Published private(set) var veoPosts: [VeoPost.PostData] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published var sidebarConfig: VeoSidebar.VeoSidebarConfig
    @Published var selectedIndex = 0
    @Published var isSidebarShowing = false
    @Published var showLogoutAlert = false
    @Published var selectedMenuItem: VeoSidebar.VeoSidebarItem?

    var menuItems: [VeoSidebar.VeoSidebarItem] {
        [
            .init(id: 0, icon: "house.fill", title: "Home"),
            .init(id: 1, icon: "person.fill", title: "Profile"),
            .init(id: 2, icon: "gear", title: "Settings"),
            .init(id: 3, icon: "bell.fill", title: "Notifications"),
            .init(id: 4, icon: "questionmark.circle", title: "Help"),
            .init(
                id: 5,
                icon: "rectangle.portrait.and.arrow.right",
                title: "Log out",
                action: {
                    self.showLogoutAlert = true
                })
        ]
    }

    let items: [VeoBottomTabBar.TabItem] = [
        .init(
            icon: "house.fill",
            title: "Home"),
        .init(icon: "magnifyingglass", title: "Search"),
        .init(icon: "plus.circle.fill", title: "New"),
        .init(icon: "bell.fill", title: "Notifications"),
        .init(icon: "person.fill", title: "Profile")
    ]

    private let service: PostsServiceProtocol

    init(service: PostsServiceProtocol = PostsService()) {
        self.service = service
        sidebarConfig = .init(
            topLogo: "logo",
            headerText: "My Posts",
            bottomLogo: "logo",
            width: 280,
            backgroundColor: VeoUI.primaryColor,
            selectedColor: VeoUI.dangerColor,
            textColor: .white)
    }

    func fetchPosts() {
        Task {
            do {
                isLoading = true
                error = nil
                posts = try await service.fetchPosts()

                veoPosts = []
                for post in posts {
                    let veoPost: VeoPost.PostData = .init(
                        userAvatar: "photo1",
                        userName: "John Smith",
                        badgeContent: "New User",
                        date: "12-12-2024",
                        content: post.body,
                        actionButtonTitle: "Share",
                        likes: 1,
                        comments: 2)
                    veoPosts.append(veoPost)
                }
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
}
