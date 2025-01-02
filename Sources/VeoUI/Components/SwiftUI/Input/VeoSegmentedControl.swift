//
//  VeoSegmentedControl.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 2/1/2025.
//

import SwiftUI

public struct VeoSegmentedControl: View {
    let items: [String]
    @Binding var selectedIndex: Int
    let style: SegmentStyle
    
    @MainActor
    public struct SegmentStyle {
        let backgroundColor: Color
        let selectedBackgroundColor: Color
        let textColor: Color
        let selectedTextColor: Color
        let cornerRadius: CGFloat
        let padding: EdgeInsets
        
        public static let standard = SegmentStyle(
            backgroundColor: Color.gray.opacity(0.1),
            selectedBackgroundColor: VeoUI.primaryColor,
            textColor: .gray,
            selectedTextColor: .white,
            cornerRadius: VeoUI.defaultCornerRadius,
            padding: EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        )
        
        public init(
            backgroundColor: Color = Color.gray.opacity(0.1),
            selectedBackgroundColor: Color = VeoUI.primaryColor,
            textColor: Color = .gray,
            selectedTextColor: Color = .white,
            cornerRadius: CGFloat = VeoUI.defaultCornerRadius,
            padding: EdgeInsets = EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        ) {
            self.backgroundColor = backgroundColor
            self.selectedBackgroundColor = selectedBackgroundColor
            self.textColor = textColor
            self.selectedTextColor = selectedTextColor
            self.cornerRadius = cornerRadius
            self.padding = padding
        }
    }
    
    public init(
        items: [String],
        selectedIndex: Binding<Int>,
        style: SegmentStyle = .standard
    ) {
        self.items = items
        self._selectedIndex = selectedIndex
        self.style = style
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(style.selectedBackgroundColor)
                    .frame(width: geometry.size.width / CGFloat(items.count))
                    .offset(x: CGFloat(selectedIndex) * (geometry.size.width / CGFloat(items.count)))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedIndex)
                
                HStack(spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedIndex = index
                            }
                        }) {
                            VeoText(
                                item,
                                style: .body,
                                color: selectedIndex == index ? style.selectedTextColor : style.textColor
                            )
                            .padding(style.padding)
                            .frame(width: geometry.size.width / CGFloat(items.count))
                            .contentShape(Rectangle())
                        }
                    }
                }
            }
            .background(style.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
        }
        .frame(height: 40)
        .environment(\.layoutDirection, VeoUI.isRTL ? .rightToLeft : .leftToRight)
    }
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Tajawal-Bold"
    )
    
    struct VeoSegmentedControlPreview: View {
        @State private var selectedIndex1 = 0
        @State private var selectedIndex2 = 0
        @State private var selectedIndex3 = 0
        @State private var selectedIndexRTL = 0
        
        var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    Group {
                        VeoText("Default Style", style: .headline)
                        VeoSegmentedControl(
                            items: ["First", "Second", "Third"],
                            selectedIndex: $selectedIndex1
                        )
                    }
                    
                    Divider()
                    
                    Group {
                        VeoText("Custom Style", style: .headline)
                        VeoSegmentedControl(
                            items: ["Day", "Week", "Month"],
                            selectedIndex: $selectedIndex2,
                            style: .init(
                                backgroundColor: .blue.opacity(0.1),
                                selectedBackgroundColor: .blue,
                                textColor: .blue,
                                selectedTextColor: .white,
                                cornerRadius: 8,
                                padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                            )
                        )
                    }
                    
                    Divider()
                    
                    Group {
                        VeoText("Warning Style", style: .headline)
                        VeoSegmentedControl(
                            items: ["Low", "Medium", "High"],
                            selectedIndex: $selectedIndex3,
                            style: .init(
                                backgroundColor: VeoUI.warningColor.opacity(0.1),
                                selectedBackgroundColor: VeoUI.warningColor,
                                textColor: VeoUI.warningColor,
                                selectedTextColor: .white,
                                cornerRadius: VeoUI.defaultCornerRadius
                            )
                        )
                    }
                    
                    Divider()
                    
                    Group {
                        VeoText("RTL Support", style: .headline)
                        VeoSegmentedControl(
                            items: ["الأول", "الثاني", "الثالث"],
                            selectedIndex: $selectedIndexRTL
                        )
                        .environment(\.layoutDirection, .rightToLeft)
                    }
                }
                .padding()
            }
        }
    }
    
    return VeoSegmentedControlPreview()
}
