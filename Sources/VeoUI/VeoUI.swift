import SwiftUI

@MainActor
public class VeoUI {
    static var primaryColor: Color = .orange
    static var primaryDarkColor: Color = .red
    static var secondaryColor: Color?
    static var tertiaryColor: Color?
    static var successColor: Color?
    static var infoColor: Color?
    static var warningColor: Color?
    static var dangerColor: Color = .red
    static var isDarkMode = false
    static var mainFont = "SFUI-Medium"
    static var lightFont: String?
    static var regularFont: String?
    static var mediumFont: String?
    static var boldFont: String?
    static var italicFont: String?
    static var defaultCornerRadius: CGFloat = 24
    static var defaultElevation: CGFloat = 2
    static var isRTL = false

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
