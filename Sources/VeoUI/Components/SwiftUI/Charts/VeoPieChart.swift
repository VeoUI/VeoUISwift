//
//  VeoPieChart.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 1/1/2025.
//

import SwiftUI

public struct VeoPieChartData: Identifiable {
    public let id = UUID()
    let value: Double
    let label: String
    let color: Color?
    
    public init(label: String, value: Double, color: Color? = nil) {
        self.label = label
        self.value = value
        self.color = color
    }
}

public struct VeoPieChart: View {
    let data: [VeoPieChartData]
    let style: VeoChartStyle
    let showLabels: Bool
    let showValues: Bool
    let showPercentages: Bool
    let labelPosition: LabelPosition
    let animation: Animation
    let startAngle: Double
    let innerRadiusFraction: CGFloat
    let shadowRadius: CGFloat
    let gradient: [(Color, Color)]?
    
    @State private var selectedSlice: Int?
    @State private var animationProgress: CGFloat = 0
    
    public init(
        data: [VeoPieChartData],
        style: VeoChartStyle = .primary,
        showLabels: Bool = true,
        showValues: Bool = true,
        showPercentages: Bool = true,
        labelPosition: LabelPosition = .outside,
        animation: Animation = .easeInOut(duration: 0.8),
        startAngle: Double = -90,
        innerRadiusFraction: CGFloat = 0,
        shadowRadius: CGFloat = 0,
        gradient: [(Color, Color)]? = nil
    ) {
        self.data = data
        self.style = style
        self.showLabels = showLabels
        self.showValues = showValues
        self.showPercentages = showPercentages
        self.labelPosition = labelPosition
        self.animation = animation
        self.startAngle = startAngle
        self.innerRadiusFraction = innerRadiusFraction
        self.shadowRadius = shadowRadius
        self.gradient = gradient
    }
    
    private var total: Double {
        data.reduce(0) { $0 + $1.value }
    }
    
    private func color(for index: Int) -> Color {
        if let color = data[index].color {
            return color
        }
        
        switch style {
        case .primary:
            return VeoUI.primaryColor.opacity(1.0 - Double(index) * 0.2)
        case .secondary:
            return (VeoUI.secondaryColor ?? .blue).opacity(1.0 - Double(index) * 0.2)
        case .info:
            return VeoUI.infoColor.opacity(1.0 - Double(index) * 0.2)
        case .warning:
            return VeoUI.warningColor.opacity(1.0 - Double(index) * 0.2)
        case .danger:
            return VeoUI.dangerColor.opacity(1.0 - Double(index) * 0.2)
        case let .custom(baseColor):
            return baseColor.opacity(1.0 - Double(index) * 0.2)
        }
    }
    
    private func angleForSlice(_ index: Int) -> Double {
        let sliceValue = data[index].value
        return 360 * (sliceValue / total)
    }
    
    private func startAngleForSlice(_ index: Int) -> Double {
        var angle = startAngle
        for i in 0..<index {
            angle += angleForSlice(i)
        }
        return angle
    }
    
    private func gradientForSlice(_ index: Int) -> LinearGradient {
        if let gradients = gradient, index < gradients.count {
            return LinearGradient(
                colors: [gradients[index].0, gradients[index].1],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            let baseColor = color(for: index)
            return LinearGradient(
                colors: [baseColor, baseColor.opacity(0.8)],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(data.enumerated()), id: \.element.id) { index, slice in
                    PieSlice(
                        startAngle: Angle(degrees: startAngleForSlice(index)),
                        endAngle: Angle(degrees: startAngleForSlice(index) + angleForSlice(index) * animationProgress),
                        innerRadiusFraction: innerRadiusFraction
                    )
                    .fill(gradientForSlice(index))
                    .shadow(radius: shadowRadius)
                    .scaleEffect(selectedSlice == index ? 1.1 : 1.0)
                    .animation(.spring(), value: selectedSlice)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedSlice = selectedSlice == index ? nil : index
                        }
                    }
                    
                    if showLabels && labelPosition == .outside {
                        let midAngle = startAngleForSlice(index) + angleForSlice(index) / 2
                        let radius = min(geometry.size.width, geometry.size.height) / 2 * 1.2
                        let x = cos(midAngle * .pi / 180) * radius
                        let y = sin(midAngle * .pi / 180) * radius
                        
                        VStack(alignment: .center) {
                            Text(slice.label)
                                .font(.caption)
                                .bold()
                            if showValues {
                                Text(String(format: "%.1f", slice.value))
                                    .font(.caption2)
                            }
                            if showPercentages {
                                Text(String(format: "%.1f%%", (slice.value / total) * 100))
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                        .position(
                            x: geometry.size.width / 2 + x,
                            y: geometry.size.height / 2 + y
                        )
                        .opacity(animationProgress)
                    }
                }
                
                if innerRadiusFraction > 0 {
                    Circle()
                        .fill(Color.white)
                        .frame(
                            width: min(geometry.size.width, geometry.size.height) * innerRadiusFraction,
                            height: min(geometry.size.width, geometry.size.height) * innerRadiusFraction
                        )
                }
            }
            .onAppear {
                withAnimation(animation) {
                    animationProgress = 1
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let innerRadiusFraction: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let innerRadius = radius * innerRadiusFraction
        
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        
        if innerRadiusFraction > 0 {
            path.addArc(
                center: center,
                radius: innerRadius,
                startAngle: endAngle,
                endAngle: startAngle,
                clockwise: true
            )
        }
        
        path.closeSubpath()
        return path
    }
}

public enum VeoChartStyle {
    case primary
    case secondary
    case info
    case warning
    case danger
    case custom(Color)
}

public enum LabelPosition {
    case inside
    case outside
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        secondaryColor: Color(hex: "#3498db"),
        infoColor: Color(hex: "#2ecc71"),
        warningColor: Color(hex: "#f1c40f"),
        dangerColor: Color(hex: "#e74c3c"),
        mainFont: "Rubik-Regular"
    )
    
    return ScrollView {
        VStack(spacing: 32) {
            Group {
                VeoText("Basic Pie Chart", style: .headline)
                VeoPieChart(data: [
                    VeoPieChartData(label: "Category A", value: 30),
                    VeoPieChartData(label: "Category B", value: 20),
                    VeoPieChartData(label: "Category C", value: 15),
                    VeoPieChartData(label: "Category D", value: 35)
                ])
            }
            
            Divider()
            
            Group {
                VeoText("Donut Chart", style: .headline)
                VeoPieChart(
                    data: [
                        VeoPieChartData(label: "Completed", value: 75),
                        VeoPieChartData(label: "In Progress", value: 15),
                        VeoPieChartData(label: "Not Started", value: 10)
                    ],
                    style: .info,
                    innerRadiusFraction: 0.6
                )
            }
            
            Divider()
            
            Group {
                VeoText("Custom Colors", style: .headline)
                VeoPieChart(
                    data: [
                        VeoPieChartData(label: "iOS", value: 45, color: .blue),
                        VeoPieChartData(label: "Android", value: 40, color: .green),
                        VeoPieChartData(label: "Web", value: 15, color: .orange)
                    ],
                    showPercentages: true
                )
            }
            
            Divider()
            
            Group {
                VeoText("Gradient Example", style: .headline)
                VeoPieChart(
                    data: [
                        VeoPieChartData(label: "Q1", value: 250),
                        VeoPieChartData(label: "Q2", value: 300),
                        VeoPieChartData(label: "Q3", value: 180),
                        VeoPieChartData(label: "Q4", value: 270)
                    ],
                    gradient: [
                        (Color(hex: "#2980b9"), Color(hex: "#3498db")),
                        (Color(hex: "#27ae60"), Color(hex: "#2ecc71")),
                        (Color(hex: "#f39c12"), Color(hex: "#f1c40f")),
                        (Color(hex: "#c0392b"), Color(hex: "#e74c3c"))
                    ]
                )
            }
            
            Divider()
            
            Group {
                VeoText("Real World Example", style: .headline)
                VStack(alignment: .leading, spacing: 8) {
                    VeoText("Expense Distribution", style: .title)
                    VeoText("Monthly breakdown by category", style: .caption)
                    
                    VeoPieChart(
                        data: [
                            VeoPieChartData(label: "Housing", value: 1200),
                            VeoPieChartData(label: "Transportation", value: 400),
                            VeoPieChartData(label: "Food", value: 600),
                            VeoPieChartData(label: "Utilities", value: 300),
                            VeoPieChartData(label: "Entertainment", value: 200)
                        ],
                        style: .custom(Color(hex: "#8e44ad")),
                        showValues: true,
                        showPercentages: true,
                        labelPosition: .outside,
                        innerRadiusFraction: 0.5,
                        shadowRadius: 2
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
