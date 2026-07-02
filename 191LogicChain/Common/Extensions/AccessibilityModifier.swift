import SwiftUI

struct AccessibilityModifier: ViewModifier {
    let settings: AccessibilitySettings

    func body(content: Content) -> some View {
        content
            .dynamicTypeSize(settings.largeFont ? .xLarge ... .accessibility3 : .small ... .xxxLarge)
            .environment(\.colorScheme, settings.highContrast ? .dark : .dark)
    }
}

extension View {
    func applyAccessibility(_ settings: AccessibilitySettings) -> some View {
        modifier(AccessibilityModifier(settings: settings))
    }
}

struct HighContrastTheme {
    static let background = Color.black
    static let card = Color(white: 0.15)
    static let primaryText = Color.white
    static let secondaryText = Color(white: 0.75)
    static let accent = Color(hex: "00ffcc")
    static let danger = Color(hex: "ff4444")
}
