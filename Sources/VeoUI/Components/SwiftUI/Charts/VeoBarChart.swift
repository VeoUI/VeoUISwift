//
//  VeoBarChart.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 1/1/2025.
//

import SwiftUI

public struct VeoBarChartData: Identifiable {
    public let id = UUID()
    let label: String
    let value: Double
    let color: Color?
    
    public init(label: String, value: Double, color: Color? = nil) {
        self.label = label
        self.value = value
        self.color = color
    }
}

public struct VeoBarChart: View {
    let data: [VeoBarChartData]
    let style: VeoBarChartStyle
    let barWidth: CGFloat?
    let spacing: CGFloat
    let showLabels: Bool
    let showValues: Bool
    let maxHeight: CGFloat
    let animation: Animation
    let cornerRadius: CGFloat
    let gradient: (Color, Color)?
    
    @State private var animatedValues: [Double]
    
    public init(
        data: [VeoBarChartData],
        style: VeoBarChartStyle = .primary,
        barWidth: CGFloat? = nil,
        spacing: CGFloat = 16,
        showLabels: Bool = true,
        showValues: Bool = true,
        maxHeight: CGFloat = 300,
        animation: Animation = .spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8),
        cornerRadius: CGFloat = 8,
        gradient: (Color, Color)? = nil
    ) {
        self.data = data
        self.style = style
        self.barWidth = barWidth
        self.spacing = spacing
        self.showLabels = showLabels
        self.showValues = showValues
        self.maxHeight = maxHeight
        self.animation = animation
        self.cornerRadius = cornerRadius
        self.gradient = gradient
        self._animatedValues = State(initialValue: Array(repeating: 0, count: data.count))
    }
    
    private var maxValue: Double {
        data.map { $0.value }.max() ?? 0
    }
    
    private var barColor: Color {
        switch style {
        case .primary:
            return VeoUI.primaryColor
        case .secondary:
            return VeoUI.secondaryColor ?? .blue
        case .info:
            return VeoUI.infoColor
        case .warning:
            return VeoUI.warningColor
        case .danger:
            return VeoUI.dangerColor
        case let .custom(color):
            return color
        }
    }
    
    private var calculatedBarWidth: CGFloat {
        if let width = barWidth { return width }
        let totalSpacing = spacing * CGFloat(data.count - 1)
        return (UIScreen.main.bounds.width - 32 - totalSpacing) / CGFloat(data.count)
    }
    
    private var barGradient: some ShapeStyle {
        if let gradient = gradient {
            LinearGradient(
                colors: [gradient.0, gradient.1],
                startPoint: .bottom,
                endPoint: .top
            )
        } else {
            LinearGradient(
                colors: [barColor, barColor.opacity(0.8)],
                startPoint: .bottom,
                endPoint: .top
            )
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .bottom, spacing: spacing) {
                ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                    VStack(spacing: 8) {
                        if showValues {
                            VeoText(
                                String(format: "%.1f", animatedValues[index]),
                                style: .caption,
                                alignment: .center
                            )
                        }
                        
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(barGradient)
                                .frame(
                                    width: calculatedBarWidth,
                                    height: maxHeight * animatedValues[index] / maxValue
                                )
                            
                            .frame(
                                width: calculatedBarWidth,
                                height: maxHeight * animatedValues[index] / maxValue
                            )
                        
                        if showLabels {
                            VeoText(
                                item.label,
                                style: .caption,
                                alignment: .center
                            )
                        }
                    }
                }
            }
        }
        .onAppear {
            withAnimation(animation) {
                animatedValues = data.map { $0.value }
            }
        }
    }
}

public enum VeoBarChartStyle {
    case primary
    case secondary
    case info
    case warning
    case danger
    case custom(Color)
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Rubik-Regular"
    )
    
    return ScrollView {
        VStack(spacing: 32) {
            Group {
                VeoText("Basic Bar Chart", style: .headline)
                VeoBarChart(data: [
                    VeoBarChartData(label: "Jan", value: 65),
                    VeoBarChartData(label: "Feb", value: 85),
                    VeoBarChartData(label: "Mar", value: 45),
                    VeoBarChartData(label: "Apr", value: 95),
                    VeoBarChartData(label: "May", value: 75)
                ])
            }
            
            Divider()
            
            Group {
                VeoText("Chart Styles", style: .headline)
                VStack(spacing: 24) {
                    VeoBarChart(
                        data: [
                            VeoBarChartData(label: "A", value: 70),
                            VeoBarChartData(label: "B", value: 90),
                            VeoBarChartData(label: "C", value: 60)
                        ],
                        style: .primary
                    )
                    
                    VeoBarChart(
                        data: [
                            VeoBarChartData(label: "X", value: 80),
                            VeoBarChartData(label: "Y", value: 50),
                            VeoBarChartData(label: "Z", value: 70)
                        ],
                        style: .secondary
                    )
                    
                    VeoBarChart(
                        data: [
                            VeoBarChartData(label: "1", value: 55),
                            VeoBarChartData(label: "2", value: 85),
                            VeoBarChartData(label: "3", value: 65)
                        ],
                        style: .custom(.purple)
                    )
                }
            }
            
            Divider()
            
            Group {
                VeoText("Custom Colors Per Bar", style: .headline)
                VeoBarChart(
                    data: [
                        VeoBarChartData(label: "Q1", value: 75, color: .blue),
                        VeoBarChartData(label: "Q2", value: 85, color: .green),
                        VeoBarChartData(label: "Q3", value: 45, color: .orange),
                        VeoBarChartData(label: "Q4", value: 95, color: .red)
                    ],
                    showValues: true
                )
            }
            
            Divider()
            
            Group {
                VeoText("Gradient Bars", style: .headline)
                VeoBarChart(
                    data: [
                        VeoBarChartData(label: "Mon", value: 65),
                        VeoBarChartData(label: "Tue", value: 85),
                        VeoBarChartData(label: "Wed", value: 75),
                        VeoBarChartData(label: "Thu", value: 95),
                        VeoBarChartData(label: "Fri", value: 55)
                    ],
                    gradient: (Color(hex: "#2980b9"), Color(hex: "#3498db"))
                )
            }
            
            Divider()
            
            Group {
                VeoText("Real World Example", style: .headline)
                VStack(alignment: .leading, spacing: 8) {
                    VeoText("Monthly Revenue", style: .title)
                    VeoText("Last 6 months performance", style: .caption)
                    
                    VeoBarChart(
                        data: [
                            VeoBarChartData(label: "Jul", value: 45000),
                            VeoBarChartData(label: "Aug", value: 58000),
                            VeoBarChartData(label: "Sep", value: 62000),
                            VeoBarChartData(label: "Oct", value: 51000),
                            VeoBarChartData(label: "Nov", value: 72000),
                            VeoBarChartData(label: "Dec", value: 85000)
                        ],
                        style: .custom(Color(hex: "#27ae60")),
                        maxHeight: 200,
                        gradient: (Color(hex: "#27ae60"), Color(hex: "#2ecc71"))
                    )
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(16)
            }
        }
        .padding()
    }
}
