//
//  FontLoader.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 10/12/2024.
//

import SwiftUI

internal class FontLoader {
    public static func loadFonts() {
        let fontNames = [
            "Rubik-Regular.ttf",
            "Fresca-Regular.ttf",
            "Rubik-Bold.ttf",
            "Rubik-Light.ttf",
            "Rubik-Medium.ttf",
            "Rubik-Regular.ttf",
            "Tajawal-Black.ttf",
            "Tajawal-Bold.ttf",
            "Tajawal-Light.ttf",
            "Tajawal-Medium.ttf",
            "Tajawal-Regular.ttf"
        ]

        fontNames.forEach { fontName in
            guard
                let url = Bundle.module.url(forResource: fontName, withExtension: nil),
                let fontDataProvider = CGDataProvider(url: url as CFURL),
                let font = CGFont(fontDataProvider) else
            {
                print("⚠️ Failed to load font: \(fontName)")
                return
            }

            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                print("⚠️ Error registering font: \(fontName)")
            }
        }
    }
}
