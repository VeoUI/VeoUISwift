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
            primaryColor: Color(hex: "#27ae60"),
            primaryDarkColor: Color(hex: "#2ecc71"),
            mainFont: "Nunito-Medium")
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
