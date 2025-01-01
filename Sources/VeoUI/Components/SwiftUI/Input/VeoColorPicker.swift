//
//  VeoColorPicker.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 1/1/2025.
//

import SwiftUI

public struct VeoColorPicker: View {
    @Binding var selectedColor: Color
    var title: String = "Select Color"
    var style: PickerStyle = .grid
    var presetColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink,
        .gray, .black, VeoUI.primaryColor, VeoUI.infoColor, VeoUI.warningColor,
        VeoUI.dangerColor, VeoUI.successColor
    ]
    
    public enum PickerStyle {
        case grid
        case horizontal
        case circle
    }
    
    public init(
        selectedColor: Binding<Color>,
        title: String = "Select Color",
        style: PickerStyle = .grid,
        presetColors: [Color]? = nil
    ) {
        self._selectedColor = selectedColor
        self.title = title
        self.style = style
        if let colors = presetColors {
            self.presetColors = colors
        }
    }
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 5
    )
    
    private func colorView(_ color: Color) -> some View {
        let isSelected = selectedColor.description == color.description
        
        return Button(action: { selectedColor = color }) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: style == .horizontal ? 32 : 44, height: style == .horizontal ? 32 : 44)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                if isSelected {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2)
                        .frame(width: style == .horizontal ? 36 : 48, height: style == .horizontal ? 36 : 48)
                    
                    VeoIcon(icon: .common(.success), size: 16, color: .white)
                }
            }
        }
    }
    
    private var gridLayout: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(presetColors, id: \.description) { color in
                colorView(color)
            }
        }
        .padding()
    }
    
    private var horizontalLayout: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(presetColors, id: \.description) { color in
                    colorView(color)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var circleLayout: some View {
        let radius: CGFloat = 100
        let count = presetColors.count
        
        return ZStack {
            ForEach(0..<count, id: \.self) { index in
                let angle = (2 * .pi * Double(index)) / Double(count)
                let x = cos(angle) * radius
                let y = sin(angle) * radius
                
                colorView(presetColors[index])
                    .offset(x: x, y: y)
            }
        }
        .frame(width: radius * 2.5, height: radius * 2.5)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !title.isEmpty {
                VeoText(title, style: .headline)
                    .padding(.horizontal)
            }
            
            switch style {
            case .grid:
                gridLayout
            case .horizontal:
                horizontalLayout
            case .circle:
                circleLayout
            }
        }
    }
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Rubik-Regular"
    )
    
    struct VeoColorPickerPreview: View {
        @State private var selectedColor1: Color = .blue
        @State private var selectedColor2: Color = .green
        @State private var selectedColor3: Color = .purple
        @State private var backgroundColor: Color = .white
        
        var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    Group {
                        VeoText("Grid Style", style: .title)
                        VeoColorPicker(
                            selectedColor: $selectedColor1,
                            title: "Choose Theme Color",
                            style: .grid
                        )
                        
                        Rectangle()
                            .fill(selectedColor1)
                            .frame(height: 60)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    Group {
                        VeoText("Horizontal Style", style: .title)
                        VeoColorPicker(
                            selectedColor: $selectedColor2,
                            title: "Pick Accent Color",
                            style: .horizontal
                        )
                        
                        HStack {
                            ForEach(0..<3) { _ in
                                Circle()
                                    .fill(selectedColor2)
                                    .frame(width: 44, height: 44)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    Group {
                        VeoText("Circle Style", style: .title)
                        VeoColorPicker(
                            selectedColor: $selectedColor3,
                            style: .circle,
                            presetColors: [.red, .orange, .yellow, .green, .blue, .purple, .pink, .gray]
                        )
                        .frame(maxWidth: .infinity)
                        
                        Circle()
                            .fill(selectedColor3)
                            .frame(width: 80, height: 80)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    Group {
                        VeoText("Custom Theme Colors", style: .title)
                        VeoColorPicker(
                            selectedColor: $backgroundColor,
                            title: "Background Color",
                            style: .horizontal,
                            presetColors: [
                                Color(hex: "#1abc9c"),
                                Color(hex: "#2ecc71"),
                                Color(hex: "#3498db"),
                                Color(hex: "#9b59b6"),
                                Color(hex: "#34495e"),
                                Color(hex: "#16a085"),
                                Color(hex: "#27ae60"),
                                Color(hex: "#2980b9"),
                                Color(hex: "#8e44ad"),
                                Color(hex: "#2c3e50"),
                            ]
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
    }
    
    return VeoColorPickerPreview()
}
