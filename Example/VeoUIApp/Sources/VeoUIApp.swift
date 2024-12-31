//
//  VeoUIApp.swift
//  VeoUIApp
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI
import VeoUI

@main
struct VeoUIApp: App {
    init() {
        VeoUI.configure(
            primaryColor: Color(hex: "#f53d1b"),
            primaryDarkColor: Color(hex: "#c6062e"),
            mainFont: "BalsamiqSans-Bold")
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
