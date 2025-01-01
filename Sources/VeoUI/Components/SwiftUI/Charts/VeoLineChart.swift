//
//  VeoLineChart.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 1/1/2025.
//

import SwiftUI

public struct VeoLineChartDataPoint: Identifiable, Equatable {
    public let id = UUID()
    let x: Double
    let y: Double
    let label: String
    
    public init(x: Double, y: Double, label: String) {
        self.x = x
        self.y = y
        self.label = label
    }
}

public struct VeoLineChartSeries: Identifiable {
    public let id = UUID()
    let data: [VeoLineChartDataPoint]
    let name: String
    let color: Color?
    let style: LineStyle
    let showPoints: Bool
    let lineWidth: CGFloat
    let dashPattern: [CGFloat]?
    
    public init(
        data: [VeoLineChartDataPoint],
        name: String,
        color: Color? = nil,
        style: LineStyle = .normal,
        showPoints: Bool = true,
        lineWidth: CGFloat = 2,
        dashPattern: [CGFloat]? = nil
    ) {
        self.data = data
        self.name = name
        self.color = color
        self.style = style
        self.showPoints = showPoints
        self.lineWidth = lineWidth
        self.dashPattern = dashPattern
    }
}

public struct VeoLineChart: View {
    let series: [VeoLineChartSeries]
    let style: VeoChartStyle
    let showGrid: Bool
    let showLegend: Bool
    let showLabels: Bool
    let showValues: Bool
    let animation: Animation
    let gradientBackground: Bool
    let gridColor: Color
    let axisColor: Color
    let pointSize: CGFloat
    let cornerRadius: CGFloat
    
    @State private var animationProgress: CGFloat = 0
    @State private var hoveredPoint: VeoLineChartDataPoint?
    @State private var selectedSeries: String?
    
    public init(
        series: [VeoLineChartSeries],
        style: VeoChartStyle = .primary,
        showGrid: Bool = true,
        showLegend: Bool = true,
        showLabels: Bool = true,
        showValues: Bool = true,
        animation: Animation = .easeInOut(duration: 1.0),
        gradientBackground: Bool = false,
        gridColor: Color = Color.gray.opacity(0.2),
        axisColor: Color = Color.gray.opacity(0.5),
        pointSize: CGFloat = 6,
        cornerRadius: CGFloat = 8
    ) {
        self.series = series
        self.style = style
        self.showGrid = showGrid
        self.showLegend = showLegend
        self.showLabels = showLabels
        self.showValues = showValues
        self.animation = animation
        self.gradientBackground = gradientBackground
        self.gridColor = gridColor
        self.axisColor = axisColor
        self.pointSize = pointSize
        self.cornerRadius = cornerRadius
    }
    
    private var allPoints: [VeoLineChartDataPoint] {
        series.flatMap { $0.data }
    }
    
    private var minX: Double {
        allPoints.map { $0.x }.min() ?? 0
    }
    
    private var maxX: Double {
        allPoints.map { $0.x }.max() ?? 1
    }
    
    private var minY: Double {
        allPoints.map { $0.y }.min() ?? 0
    }
    
    private var maxY: Double {
        allPoints.map { $0.y }.max() ?? 1
    }
    
    private func color(for series: VeoLineChartSeries) -> Color {
        if let color = series.color {
            return color
        }
        
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
    
    private func point(for value: VeoLineChartDataPoint, in size: CGSize) -> CGPoint {
        let xScale = size.width / (maxX - minX)
        let yScale = size.height / (maxY - minY)
        
        return CGPoint(
            x: (value.x - minX) * xScale,
            y: size.height - (value.y - minY) * yScale
        )
    }
    
    public var body: some View {
        VStack {
            if showLegend {
                HStack(spacing: 16) {
                    ForEach(series) { series in
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedSeries = selectedSeries == series.name ? nil : series.name
                            }
                        }) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(color(for: series))
                                    .frame(width: 8, height: 8)
                                
                                Text(series.name)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                            .opacity(selectedSeries == nil || selectedSeries == series.name ? 1 : 0.3)
                        }
                    }
                }
                .padding(.bottom, 8)
            }
            
            GeometryReader { geometry in
                ZStack {
                    if showGrid {
                        GridBackground(
                            horizontalLines: 5,
                            verticalLines: 7,
                            color: gridColor
                        )
                    }
                    
                    if gradientBackground {
                        LinearGradient(
                            colors: [
                                color(for: series[0]).opacity(0.2),
                                color(for: series[0]).opacity(0.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    
                    ForEach(series) { series in
                        LinePath(
                            points: series.data.map { point(for: $0, in: geometry.size) },
                            style: series.style,
                            progress: animationProgress
                        )
                        .stroke(
                            color(for: series),
                            style: StrokeStyle(
                                lineWidth: series.lineWidth,
                                lineCap: .round,
                                lineJoin: .round,
                                dash: series.dashPattern ?? []
                            )
                        )
                        .opacity(selectedSeries == nil || selectedSeries == series.name ? 1 : 0.3)
                        
                        if series.showPoints {
                            ForEach(series.data) { point in
                                Circle()
                                    .fill(color(for: series))
                                    .frame(width: pointSize, height: pointSize)
                                    .position(self.point(for: point, in: geometry.size))
                                    .opacity(selectedSeries == nil || selectedSeries == series.name ? 1 : 0.3)
                                    .scaleEffect(hoveredPoint?.id == point.id ? 1.5 : 1.0)
                                    .animation(.spring(), value: hoveredPoint)
                                    .onTapGesture {
                                        hoveredPoint = hoveredPoint?.id == point.id ? nil : point
                                    }
                            }
                        }
                    }
                    
                    if let hoveredPoint = hoveredPoint {
                        VStack {
                            Text(hoveredPoint.label)
                                .font(.caption)
                                .bold()
                            if showValues {
                                Text(String(format: "%.1f", hoveredPoint.y))
                                    .font(.caption2)
                            }
                        }
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .position(point(for: hoveredPoint, in: geometry.size))
                        .offset(y: -40)
                    }
                }
            }
            .aspectRatio(16/9, contentMode: .fit)
            .onAppear {
                withAnimation(animation) {
                    animationProgress = 1
                }
            }
        }
    }
}

struct GridBackground: View {
    let horizontalLines: Int
    let verticalLines: Int
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let horizontalSpacing = geometry.size.height / CGFloat(horizontalLines - 1)
                for i in 0..<horizontalLines {
                    let y = CGFloat(i) * horizontalSpacing
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
                
                let verticalSpacing = geometry.size.width / CGFloat(verticalLines - 1)
                for i in 0..<verticalLines {
                    let x = CGFloat(i) * verticalSpacing
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
            }
            .stroke(color, lineWidth: 1)
        }
    }
}

struct LinePath: Shape {
    let points: [CGPoint]
    let style: LineStyle
    let progress: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard !points.isEmpty else { return path }
        
        let progressPoints = Array(points.prefix(Int(ceil(CGFloat(points.count) * progress))))
        
        if progressPoints.count > 1 {
            path.move(to: progressPoints[0])
            
            switch style {
            case .normal:
                for point in progressPoints.dropFirst() {
                    path.addLine(to: point)
                }
                
            case .curved:
                for i in 1..<progressPoints.count {
                    let previous = progressPoints[i-1]
                    let current = progressPoints[i]
                    let control1 = CGPoint(
                        x: previous.x + (current.x - previous.x) / 2,
                        y: previous.y
                    )
                    let control2 = CGPoint(
                        x: previous.x + (current.x - previous.x) / 2,
                        y: current.y
                    )
                    path.addCurve(to: current, control1: control1, control2: control2)
                }
                
            case .stepped:
                for i in 1..<progressPoints.count {
                    let previous = progressPoints[i-1]
                    let current = progressPoints[i]
                    path.addLine(to: CGPoint(x: current.x, y: previous.y))
                    path.addLine(to: current)
                }
            }
        }
        
        return path
    }
}

public enum LineStyle : Sendable{
    case normal
    case curved
    case stepped
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
                VeoText("Basic Line Chart", style: .headline)
                VeoLineChart(series: [
                    VeoLineChartSeries(
                        data: [
                            VeoLineChartDataPoint(x: 0, y: 10, label: "Jan"),
                            VeoLineChartDataPoint(x: 1, y: 25, label: "Feb"),
                            VeoLineChartDataPoint(x: 2, y: 15, label: "Mar"),
                            VeoLineChartDataPoint(x: 3, y: 30, label: "Apr"),
                            VeoLineChartDataPoint(x: 4, y: 20, label: "May")
                        ],
                        name: "Revenue"
                    )
                ])
            }
            
            Divider()
            
            Group {
                VeoText("Multiple Series", style: .headline)
                VeoLineChart(
                    series: [
                        VeoLineChartSeries(
                            data: [
                                VeoLineChartDataPoint(x: 0, y: 100, label: "Week 1"),
                                VeoLineChartDataPoint(x: 1, y: 120, label: "Week 2"),
                                VeoLineChartDataPoint(x: 2, y: 110, label: "Week 3"),
                                VeoLineChartDataPoint(x: 3, y: 140, label: "Week 4")
                            ],
                            name: "2024",
                            color: .blue
                        ),
                        VeoLineChartSeries(
                            data: [
                                VeoLineChartDataPoint(x: 0, y: 90, label: "Week 1"),
                                VeoLineChartDataPoint(x: 1, y: 100, label: "Week 2"),
                                VeoLineChartDataPoint(x: 2, y: 95, label: "Week 3"),
                                VeoLineChartDataPoint(x: 3, y: 120, label: "Week 4")
                            ],
                            name: "2023",
                            color: .gray,
                            style: .curved
                        )
                    ],
                    gradientBackground: true
                )
            }
            
            Divider()
            
            Group {
                VeoText("Line Styles", style: .headline)
                VStack(spacing: 24) {
                    VeoLineChart(
                        series: [
                            VeoLineChartSeries(
                                data: [
                                    VeoLineChartDataPoint(x: 0, y: 10, label: "A"),
                                    VeoLineChartDataPoint(x: 1, y: 20, label: "B"),
                                    VeoLineChartDataPoint(x: 2, y: 15, label: "C")
                                ],
                                name: "Normal",
                                style: .normal
                            )
                        ]
                    )
                    
                    VeoLineChart(
                        series: [
                            VeoLineChartSeries(
                                data: [
                                    VeoLineChartDataPoint(x: 0, y: 10, label: "A"),
                                    VeoLineChartDataPoint(x: 1, y: 20, label: "B"),
                                    VeoLineChartDataPoint(x: 2, y: 15, label: "C")
                                ],
                                name: "Curved",
                                style: .curved
                            )
                        ]
                    )
                    
                    VeoLineChart(
                        series: [
                            VeoLineChartSeries(
                                data: [
                                    VeoLineChartDataPoint(x: 0, y: 10, label: "A"),
                                    VeoLineChartDataPoint(x: 1, y: 20, label: "B"),
                                    VeoLineChartDataPoint(x: 2, y: 15, label: "C")
                                ],
                                name: "Stepped",
                                style: .stepped
                            )
                        ]
                    )
                }
            }
            
            Divider()
            
            Group {
                VeoText("Custom Styling", style: .headline)
                VeoLineChart(
                    series: [
                        VeoLineChartSeries(
                            data: [
                                VeoLineChartDataPoint(x: 0, y: 50, label: "Mon"),
                                VeoLineChartDataPoint(x: 1, y: 80, label: "Tue"),
                                VeoLineChartDataPoint(x: 2, y: 60, label: "Wed"),
                                VeoLineChartDataPoint(x: 3, y: 90, label: "Thu"),
                                VeoLineChartDataPoint(x: 4, y: 70, label: "Fri")
                            ],
                            name: "Dashed",
                            color: .purple,
                            lineWidth: 3,
                            dashPattern: [5, 5]
                        )
                    ],
                    style: .custom(.purple),
                    gridColor: Color.purple.opacity(0.1),
                    axisColor: Color.purple.opacity(0.3),
                    pointSize: 8
                )
            }
            
            Divider()
            
            Group {
                VeoText("Real World Example", style: .headline)
                VStack(alignment: .leading, spacing: 8) {
                    VeoText("Stock Performance", style: .title)
                    VeoText("Last 6 months comparison", style: .caption)
                    
                    VeoLineChart(
                        series: [
                            VeoLineChartSeries(
                                data: [
                                    VeoLineChartDataPoint(x: 0, y: 150, label: "Jul"),
                                    VeoLineChartDataPoint(x: 1, y: 158, label: "Aug"),
                                    VeoLineChartDataPoint(x: 2, y: 162, label: "Sep"),
                                    VeoLineChartDataPoint(x: 3, y: 151, label: "Oct"),
                                    VeoLineChartDataPoint(x: 4, y: 172, label: "Nov"),
                                    VeoLineChartDataPoint(x: 5, y: 185, label: "Dec")
                                ],
                                name: "AAPL",
                                color: .green,
                                style: .curved
                            ),
                            VeoLineChartSeries(
                                data: [
                                    VeoLineChartDataPoint(x: 0, y: 140, label: "Jul"),
                                    VeoLineChartDataPoint(x: 1, y: 145, label: "Aug"),
                                    VeoLineChartDataPoint(x: 2, y: 155, label: "Sep"),
                                    VeoLineChartDataPoint(x: 3, y: 148, label: "Oct"),
                                    VeoLineChartDataPoint(x: 4, y: 160, label: "Nov"),
                                    VeoLineChartDataPoint(x: 5, y: 175, label: "Dec")
                                ],
                                name: "Market Index",
                                color: .gray,
                                style: .curved,
                                dashPattern: [5, 5]
                            )
                        ],
                        gradientBackground: true,
                        gridColor: Color.gray.opacity(0.1)
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
