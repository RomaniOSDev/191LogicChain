import SwiftUI

struct AppCard<Content: View>: View {
    var accent: Color? = nil
    var padding: CGFloat = 16
    var elevation: SurfaceElevation = .raised
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .surfaceStyle(
                cornerRadius: Theme.Radius.lg,
                accent: accent ?? Theme.accent,
                elevation: elevation
            )
    }
}

extension Theme {
    enum Radius {
        static let sm: CGFloat = 10
        static let md: CGFloat = 14
        static let lg: CGFloat = 18
        static let xl: CGFloat = 24
    }

    enum Spacing {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 10
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 28
        static let xxl: CGFloat = 36
    }
}

enum AdaptiveLayout {
    static func gridColumns(count: Int, spacing: CGFloat = 12) -> [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: count)
    }
}

private struct AdaptiveHorizontalPaddingModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.padding(.horizontal, Theme.Spacing.lg)
    }
}

extension View {
    func adaptiveContentWidth(_ maxWidth: CGFloat = .infinity) -> some View {
        frame(maxWidth: .infinity)
    }

    func adaptiveHorizontalPadding() -> some View {
        modifier(AdaptiveHorizontalPaddingModifier())
    }
}
