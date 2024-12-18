//
//  VeoButton.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 17/12/2024.
//

import SwiftUI
import UIKit

public class VeoUIButton: UIButton {
    private let style: VeoButtonStyle
    private let buttonShape: VeoButtonShape
    private let elevation: CGFloat
    private let gradientColors: (UIColor, UIColor)?
    private let textDirection: NSTextAlignment
    private var gradientLayer: CAGradientLayer?
    private let action: () -> Void

    public init(
        title: String,
        style: VeoButtonStyle = .primary,
        shape: VeoButtonShape = .rounded,
        elevation: CGFloat = 5,
        gradientColors: (UIColor, UIColor)? = nil,
        textDirection: NSTextAlignment = .center,
        isEnabled: Bool = true,
        action: @escaping () -> Void)
    {
        self.style = style
        buttonShape = shape
        self.elevation = elevation
        self.gradientColors = gradientColors
        self.textDirection = textDirection
        self.action = action

        super.init(frame: .zero)

        setupButton()
        setTitle(title, for: .normal)
        self.isEnabled = isEnabled
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func buttonTapped() {
        action()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        gradientLayer?.frame = bounds
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }

    private func setupButton() {
        titleLabel?.font = UIFont(name: "Rubik-Bold", size: 16)
        setTitleColor(.white, for: .normal)
        titleLabel?.textAlignment = textDirection

        if let gradientColors = gradientColors {
            setupGradient(colors: gradientColors)
        } else {
            backgroundColor = backgroundColor(for: style)
        }

        layer.shadowColor = backgroundColor(for: style).cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = elevation
        layer.shadowOffset = CGSize(width: 0, height: elevation)
        contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        adjustsImageWhenDisabled = true
        layer.opacity = isEnabled ? 1.0 : 0.6
    }

    private func setupGradient(colors: (UIColor, UIColor)) {
        gradientLayer?.removeFromSuperlayer()
        let gradient = CAGradientLayer()
        gradient.colors = [colors.0.cgColor, colors.1.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }

    private var cornerRadius: CGFloat {
        switch buttonShape {
        case .square: return 0
        case .rounded: return 8
        case .circle: return 25
        case let .custom(radius): return radius
        }
    }

    private func backgroundColor(for style: VeoButtonStyle) -> UIColor {
        switch style {
        case .primary: return UIColor(hex: "#e74c3c")
        case .secondary: return UIColor(hex: "#3498db")
        case .info: return UIColor(hex: "#2ecc71")
        case .warning: return UIColor(hex: "#f1c40f")
        case .danger: return UIColor(hex: "#e74c3c")
        case .tertiary: return UIColor(hex: "#9b59b6")
        }
    }
}

class VeoButtonPreviewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addButtons()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }

    private func addButtons() {
        addSectionTitle("Button Styles")
        addButton(title: "Primary Button", style: .primary)
        addButton(title: "Secondary Button", style: .secondary)
        addButton(title: "Info Button", style: .info)
        addButton(title: "Warning Button", style: .warning)
        addButton(title: "Danger Button", style: .danger)
        addButton(title: "Tertiary Button", style: .tertiary)

        addDivider()

        addSectionTitle("Button Shapes")
        addButton(title: "Square Button", shape: .square)
        addButton(title: "Rounded Button", shape: .rounded)
        addButton(title: "Circle Button", shape: .circle)
        addButton(title: "Custom Radius", shape: .custom(cornerRadius: 15))

        addDivider()

        addSectionTitle("Elevation Variants")
        addButton(title: "No Elevation", elevation: 0)
        addButton(title: "Medium Elevation", elevation: 5)
        addButton(title: "High Elevation", elevation: 10)

        addDivider()

        addSectionTitle("Gradient Buttons")
        addButton(
            title: "Blue Gradient",
            gradientColors: (UIColor(hex: "#2980b9"), UIColor(hex: "#3498db")))
        addButton(
            title: "Purple Gradient",
            gradientColors: (UIColor(hex: "#8e44ad"), UIColor(hex: "#9b59b6")))

        addDivider()

        addSectionTitle("Text Alignment")
        addButton(title: "Left Aligned", textDirection: .left)
        addButton(title: "Center Aligned", textDirection: .center)
        addButton(title: "Right Aligned", textDirection: .right)

        addDivider()

        addSectionTitle("Button States")
        addButton(title: "Enabled Button", isEnabled: true)
        addButton(title: "Disabled Button", isEnabled: false)

        addDivider()

        addSectionTitle("RTL Support")
        addButton(title: "إنشاء حساب جديد")
        addButton(title: "زر التحذير", style: .warning, textDirection: .right)

        addSectionTitle("Complex")
        addButton(
            title: "Custom Gradient + Shape",
            shape: .custom(cornerRadius: 20),
            elevation: 8,
            gradientColors: (UIColor(hex: "#16a085"), UIColor(hex: "#2ecc71")))
        addButton(
            title: "High Impact Button",
            style: .danger,
            shape: .circle,
            elevation: 12,
            gradientColors: (UIColor(hex: "#c0392b"), UIColor(hex: "#e74c3c")))
    }

    private func addSectionTitle(_ title: String) {
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 20)
        stackView.addArrangedSubview(label)
    }

    private func addButton(
        title: String,
        style: VeoButtonStyle = .primary,
        shape: VeoButtonShape = .rounded,
        elevation: CGFloat = 5,
        gradientColors: (UIColor, UIColor)? = nil,
        textDirection: NSTextAlignment = .center,
        isEnabled: Bool = true)
    {
        let button = VeoUIButton(
            title: title,
            style: style,
            shape: shape,
            elevation: elevation,
            gradientColors: gradientColors,
            textDirection: textDirection,
            isEnabled: isEnabled,
            action: {
                print("Button tapped: \(title)")
            })
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        stackView.addArrangedSubview(button)
    }

    private func addDivider() {
        let divider = UIView()
        divider.backgroundColor = .systemGray4
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        stackView.addArrangedSubview(divider)
    }
}

struct VeoButtonPreviewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context _: Context) -> VeoButtonPreviewController {
        VeoButtonPreviewController()
    }

    func updateUIViewController(_: VeoButtonPreviewController, context _: Context) {}
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
        tertiaryColor: Color(hex: "#9b59b6"),
        mainFont: "Rubik-Bold")

    return VeoButtonPreviewWrapper()
        .edgesIgnoringSafeArea(.all)
}
