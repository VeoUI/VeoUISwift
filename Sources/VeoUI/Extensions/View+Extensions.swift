//
//  View+Extensions.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public extension View {
    func aspectRatio(_ ratio: CGFloat) -> some View {
        modifier(AspectRatio(ratio: ratio))
    }
}
