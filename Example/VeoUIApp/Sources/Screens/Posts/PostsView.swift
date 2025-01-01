//
//  MainView.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI
import VeoUI

struct PostsView: View {
    @StateObject private var viewModel = PostsViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VeoAppBar(
                    appName: "My Posts",
                    onMenuTap: {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.isSidebarShowing.toggle()
                        }
                    },
                    onNotificationTap: {
                        viewModel.selectedIndex = 3
                    },
                    onLogoutTap: {
                        viewModel.showLogoutAlert = true
                    })

                VeoIconButton(
                    icon: "plus.circle",
                    title: "Add Post")
                {
                    print("Add post tapped")
                }

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.veoPosts) { post in
                            VeoPost(
                                data: post,
                                onLike: { print("Liked") },
                                onComment: { print("Comment") },
                                onAction: { print("Action") })
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

            if viewModel.isLoading {
                VeoLoader()
            }

            VStack {
                Spacer()
                VeoBottomTabBar(selectedIndex: $viewModel.selectedIndex, items: viewModel.items)
            }

            if viewModel.isSidebarShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            viewModel.isSidebarShowing = false
                        }
                    }
            }

            VeoSidebar(
                config: viewModel.sidebarConfig,
                menuItems: viewModel.menuItems,
                selectedItem: $viewModel.selectedMenuItem,
                isShowing: $viewModel.isSidebarShowing)

            if viewModel.showLogoutAlert {
                VeoAlert(
                    isPresented: $viewModel.showLogoutAlert,
                    content: VeoAlert.AlertContent(
                        icon: .system(
                            name: "checkmark",
                            color: .green,
                            backgroundColor: Color.green.opacity(0.1)),
                        title: "Log Out",
                        message: "Are you sure you want to log out ?",
                        primaryButton: VeoAlert.AlertButton(
                            title: "Yes",
                            style: .init(
                                backgroundColor: .green,
                                foregroundColor: .white,
                                font: .system(size: 16, weight: .bold),
                                cornerRadius: 25,
                                padding: EdgeInsets(top: 12, leading: 32, bottom: 12, trailing: 32)), action: {
                                viewModel.showLogoutAlert = false
                                viewModel.isSidebarShowing = false
                            }),
                        secondaryButton: VeoAlert.AlertButton(
                            title: "No",
                            style: .init(
                                backgroundColor: .green,
                                foregroundColor: .white,
                                font: .system(size: 16, weight: .bold),
                                cornerRadius: 25,
                                padding: EdgeInsets(top: 12, leading: 32, bottom: 12, trailing: 32)), action: {})))
            }
            
            if viewModel.error != nil {
                VeoAlert(
                    isPresented: $viewModel.showLogoutAlert,
                    content: VeoAlert.AlertContent(
                        icon: .system(
                            name: "xmark",
                            color: VeoUI.dangerColor,
                            backgroundColor: Color.red.opacity(0.1)),
                        title: "Error",
                        message: viewModel.error?.localizedDescription ?? "",
                        primaryButton: VeoAlert.AlertButton(
                            title: "Retry",
                            style: .primary, action: {
                                viewModel.fetchPosts()
                            })))
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.fetchPosts()
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

#Preview {
    PostsView()
}
