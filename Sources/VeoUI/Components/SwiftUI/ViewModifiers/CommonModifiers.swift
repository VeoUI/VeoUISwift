//
//  CommonModifiers.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

struct AspectRatio: ViewModifier {
    let ratio: CGFloat

    func body(content: Content) -> some View {
        content.aspectRatio(ratio, contentMode: .fit)
    }
}
