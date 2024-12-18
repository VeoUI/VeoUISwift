//
//  View+Extensions.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

extension View {
    public func aspectRatio(_ ratio: CGFloat) -> some View {
        modifier(AspectRatio(ratio: ratio))
    }
}
