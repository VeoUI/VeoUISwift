//
//  VeoSlider.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 2/1/2025.
//

import SwiftUI

public struct VeoSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let style: SliderStyle
    
    @MainActor
    public struct SliderStyle {
        let trackColor: Color
        let activeTrackColor: Color
        let thumbColor: Color
        let thumbSize: CGFloat
        let trackHeight: CGFloat
        let showValue: Bool
        let valueFormat: String
        
        public static let standard = SliderStyle(
            trackColor: Color.gray.opacity(0.2),
            activeTrackColor: VeoUI.primaryColor,
            thumbColor: .white,
            thumbSize: 24,
            trackHeight: 4,
            showValue: false,
            valueFormat: "%.0f"
        )
        
        public init(
            trackColor: Color = Color.gray.opacity(0.2),
            activeTrackColor: Color = VeoUI.primaryColor,
            thumbColor: Color = .white,
            thumbSize: CGFloat = 24,
            trackHeight: CGFloat = 4,
            showValue: Bool = false,
            valueFormat: String = "%.0f"
        ) {
            self.trackColor = trackColor
            self.activeTrackColor = activeTrackColor
            self.thumbColor = thumbColor
            self.thumbSize = thumbSize
            self.trackHeight = trackHeight
            self.showValue = showValue
            self.valueFormat = valueFormat
        }
    }
    
    public init(
        value: Binding<Double>,
        range: ClosedRange<Double> = 0...1,
        step: Double = 0.1,
        style: SliderStyle = .standard
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.style = style
    }
    
    private var formattedValue: String {
        String(format: style.valueFormat, value)
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            if style.showValue {
                VeoText(formattedValue, style: .caption)
                    .foregroundColor(style.activeTrackColor)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: style.trackHeight / 2)
                        .fill(style.trackColor)
                        .frame(height: style.trackHeight)
                    
                    RoundedRectangle(cornerRadius: style.trackHeight / 2)
                        .fill(style.activeTrackColor)
                        .frame(width: thumbPosition(in: geometry), height: style.trackHeight)
                    
                    Circle()
                        .fill(style.thumbColor)
                        .frame(width: style.thumbSize, height: style.thumbSize)
                        .shadow(radius: 4, y: 2)
                        .offset(x: thumbPosition(in: geometry) - style.thumbSize / 2)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    updateValue(at: gesture.location.x, in: geometry)
                                }
                        )
                }
                .frame(height: style.thumbSize)
            }
            .frame(height: style.thumbSize)
        }
    }
    
    private func thumbPosition(in geometry: GeometryProxy) -> CGFloat {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return geometry.size.width * CGFloat(percentage)
    }
    
    private func updateValue(at position: CGFloat, in geometry: GeometryProxy) {
        let percentage = max(0, min(1, position / geometry.size.width))
        let newValue = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percentage)
        let steppedValue = round(newValue / step) * step
        value = max(range.lowerBound, min(range.upperBound, steppedValue))
    }
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Rubik-Regular"
    )
    
    struct VeoSliderPreview: View {
        @State private var value1: Double = 50
        @State private var value2: Double = 0.5
        @State private var value3: Double = 25
        @State private var value4: Double = 75
        
        var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    Group {
                        VeoText("Default Style", style: .headline)
                        VeoSlider(
                            value: $value1,
                            range: 0...100,
                            step: 1
                        )
                    }
                    
                    Divider()
                    
                    Group {
                        VeoText("With Value Display", style: .headline)
                        VeoSlider(
                            value: $value2,
                            range: 0...1,
                            step: 0.1,
                            style: .init(
                                showValue: true,
                                valueFormat: "%.1f"
                            )
                        )
                    }
                    
                    Divider()
                    
                    Group {
                        VeoText("Custom Style", style: .headline)
                        VeoSlider(
                            value: $value3,
                            range: 0...100,
                            step: 5,
                            style: .init(
                                trackColor: .blue.opacity(0.2),
                                activeTrackColor: .blue,
                                thumbColor: .white,
                                thumbSize: 30,
                                trackHeight: 6,
                                showValue: true
                            )
                        )
                    }
                    
                    Divider()
                    
                    Group {
                        VeoText("Warning Style", style: .headline)
                        VeoSlider(
                            value: $value4,
                            range: 0...100,
                            step: 1,
                            style: .init(
                                trackColor: VeoUI.warningColor.opacity(0.2),
                                activeTrackColor: VeoUI.warningColor,
                                thumbColor: .white,
                                thumbSize: 28,
                                trackHeight: 8,
                                showValue: true
                            )
                        )
                    }
                    
                    Group {
                        VeoText("Usage Examples", style: .headline)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            VeoText("Volume Control", style: .caption)
                            HStack {
                                Image(systemName: "speaker.fill")
                                    .foregroundColor(.gray)
                                VeoSlider(
                                    value: $value1,
                                    range: 0...100,
                                    step: 1
                                )
                                Image(systemName: "speaker.wave.3.fill")
                                    .foregroundColor(.gray)
                            }
                            
                            VeoText("Brightness", style: .caption)
                            HStack {
                                Image(systemName: "sun.min.fill")
                                    .foregroundColor(.gray)
                                VeoSlider(
                                    value: $value2,
                                    range: 0...1,
                                    step: 0.05,
                                    style: .init(
                                        trackColor: .orange.opacity(0.2),
                                        activeTrackColor: .orange
                                    )
                                )
                                Image(systemName: "sun.max.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    return VeoSliderPreview()
}
