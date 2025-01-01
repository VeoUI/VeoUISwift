//
//  AppRouter.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 1/1/2025.
//

import SwiftUI

final class AppRouter: ObservableObject {
    @Published var navigationPath = NavigationPath()

    enum Destination: Hashable {
        case onboarding
        case register
        case login
        case resetPassword
        case home
    }

    func navigateTo(_ destination: Destination) {
        navigationPath.append(destination)
    }

    func navigateToRoot() {
        navigationPath = NavigationPath()
    }

    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }

    func pop() {
        navigationPath.removeLast()
    }
}
