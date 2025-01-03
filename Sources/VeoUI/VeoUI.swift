import SwiftUI

@MainActor
public class VeoUI {
    public static var primaryColor: Color = .init(hex: "#1abc9c")
    public static var primaryDarkColor: Color = .init(hex: "#16a085")
    public static var secondaryColor: Color?
    public static var tertiaryColor: Color?
    public static var successColor: Color = .init(hex: "#2ecc71")
    public static var infoColor: Color = .init(hex: "#3498db")
    public static var warningColor: Color = .init(hex: "#f1c40f")
    public static var dangerColor: Color = .init(hex: "#e74c3c")
    public static var isDarkMode = false
    public static var mainFont = "SFUI-Medium"
    public static var lightFont: String?
    public static var regularFont: String?
    public static var mediumFont: String?
    public static var boldFont: String?
    public static var italicFont: String?
    public static var defaultCornerRadius: CGFloat = 24
    public static var defaultElevation: CGFloat = 2
    public static var isRTL = false

    public static func configure(
        primaryColor: Color? = nil,
        primaryDarkColor: Color? = nil,
        secondaryColor: Color? = nil,
        infoColor: Color? = nil,
        warningColor: Color? = nil,
        dangerColor: Color? = nil,
        tertiaryColor: Color? = nil,
        isRTL: Bool? = false,
        mainFont: String? = nil,
        lightFont: String? = nil,
        regularFont: String? = nil,
        mediumFont: String? = nil,
        boldFont: String? = nil,
        italicFont: String? = nil,
        bodyFont _: Font? = nil,
        isDarkMode: Bool? = nil,
        defaultCornerRadius: CGFloat? = nil,
        defaultElevation: CGFloat? = nil)
    {
        if let primaryColor = primaryColor { Self.primaryColor = primaryColor }
        if let primaryDarkColor = primaryDarkColor { Self.primaryDarkColor = primaryDarkColor }
        if let secondaryColor = secondaryColor { Self.secondaryColor = secondaryColor }
        if let infoColor = infoColor { Self.infoColor = infoColor }
        if let warningColor = warningColor { Self.warningColor = warningColor }
        if let dangerColor = dangerColor { Self.dangerColor = dangerColor }
        if let tertiaryColor = tertiaryColor { Self.tertiaryColor = tertiaryColor }
        if let mainFont = mainFont { Self.mainFont = mainFont }
        if let lightFont = lightFont { Self.lightFont = lightFont }
        if let regularFont = regularFont { Self.regularFont = regularFont }
        if let mediumFont = mediumFont { Self.mediumFont = mediumFont }
        if let italicFont = italicFont { Self.italicFont = italicFont }
        if let boldFont = boldFont { Self.boldFont = boldFont }
        if let isDarkMode = isDarkMode { Self.isDarkMode = isDarkMode }
        if let defaultCornerRadius = defaultCornerRadius { Self.defaultCornerRadius = defaultCornerRadius }
        if let defaultElevation = defaultElevation { Self.defaultElevation = defaultElevation }
        if let isRTL = isRTL { Self.isRTL = isRTL }
    }
}
