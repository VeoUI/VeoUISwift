//
//  VeoFont.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

@MainActor
public enum VeoFont {
    enum Style {
        case largeTitle
        case title1
        case title2
        case title3
        case headline
        case subheadline
        case body
        case callout
        case caption1
        case caption2
        case footnote

        var size: CGFloat {
            switch self {
            case .largeTitle:
                34
            case .title1:
                28
            case .title2:
                22
            case .title3:
                20
            case .headline:
                17
            case .subheadline:
                15
            case .body:
                16
            case .callout:
                16
            case .caption1:
                12
            case .caption2:
                11
            case .footnote:
                13
            }
        }
    }

    enum Weight {
        case ultraLight
        case thin
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
        case black

        var weight: Font.Weight {
            switch self {
            case .ultraLight:
                .ultraLight
            case .thin:
                .thin
            case .light:
                .light
            case .regular:
                .regular
            case .medium:
                .medium
            case .semibold:
                .semibold
            case .bold:
                .bold
            case .heavy:
                .heavy
            case .black:
                .black
            }
        }
    }

    enum Design {
        case `default`
        case rounded
        case serif
        case monospaced

        var design: Font.Design {
            switch self {
            case .default:
                .default
            case .rounded:
                .rounded
            case .serif:
                .serif
            case .monospaced:
                .monospaced
            }
        }
    }

    enum Modifier {
        case italic
        case smallCaps
        case lowercaseSmallCaps
        case uppercaseSmallCaps
        case monospacedDigit
    }

    static func custom(
        family _: String = VeoUI.mainFont,
        style: Style,
        weight: Weight = .regular,
        design _: Design = .default,
        modifiers: [Modifier] = [])
        -> Font
    {
        var font = Font.custom(VeoUI.mainFont, size: style.size)
            .weight(weight.weight)

        for modifier in modifiers {
            switch modifier {
            case .italic:
                font = font.italic()
            case .smallCaps:
                font = font.smallCaps()
            case .lowercaseSmallCaps:
                font = font.lowercaseSmallCaps()
            case .uppercaseSmallCaps:
                font = font.uppercaseSmallCaps()
            case .monospacedDigit:
                font = font.monospacedDigit()
            }
        }

        return font
    }

    static func largeTitle(
        family: String = VeoUI.mainFont,
        weight: Weight = .bold,
        modifiers: [Modifier] = [])
        -> Font
    {
        custom(family: family, style: .largeTitle, weight: weight, modifiers: modifiers)
    }

    static func title1(
        family: String = VeoUI.mainFont,
        weight: Weight = .bold,
        modifiers: [Modifier] = [])
        -> Font
    {
        custom(family: family, style: .title1, weight: weight, modifiers: modifiers)
    }

    static func title2(
        family: String = VeoUI.mainFont,
        weight: Weight = .bold,
        modifiers: [Modifier] = [])
        -> Font
    {
        custom(family: family, style: .title2, weight: weight, modifiers: modifiers)
    }

    static func title3(
        family: String = VeoUI.mainFont,
        weight: Weight = .semibold,
        modifiers: [Modifier] = [])
        -> Font
    {
        custom(family: family, style: .title3, weight: weight, modifiers: modifiers)
    }

    static func headline(
        family: String = VeoUI.mainFont,
        weight: Weight = .semibold,
        modifiers: [Modifier] = [])
        -> Font
    {
        custom(family: family, style: .headline, weight: weight, modifiers: modifiers)
    }

    static func subheadline(
        family: String = VeoUI.mainFont,
        weight: Weight = .regular,
        modifiers: [Modifier] = [])
        -> Font
    {
        custom(family: family, style: .subheadline, weight: weight, modifiers: modifiers)
    }

    static func body(
        family: String = VeoUI.mainFont,
        weight: Weight = .regular,
        modifiers: [Modifier] = [])
        -> Font
    {
        custom(family: family, style: .body, weight: weight, modifiers: modifiers)
    }

    static func callout(
        family: String = VeoUI.mainFont,
        weight: Weight = .regular,
        modifiers: [Modifier] = [])
        -> Font
    {
        custom(family: family, style: .callout, weight: weight, modifiers: modifiers)
    }

    static func caption1(
        family: String = VeoUI.mainFont,
        weight: Weight = .regular,
        modifiers: [Modifier] = [])
        -> Font
    {
        custom(family: family, style: .caption1, weight: weight, modifiers: modifiers)
    }

    static func caption2(
        family: String = VeoUI.mainFont,
        weight: Weight = .regular,
        modifiers: [Modifier] = [])
        -> Font
    {
        custom(family: family, style: .caption2, weight: weight, modifiers: modifiers)
    }

    static func footnote(
        family: String = VeoUI.mainFont,
        weight: Weight = .regular,
        modifiers: [Modifier] = [])
        -> Font
    {
        custom(family: family, style: .footnote, weight: weight, modifiers: modifiers)
    }
}
