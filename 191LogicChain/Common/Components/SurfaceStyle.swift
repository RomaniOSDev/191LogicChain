import SwiftUI

/// Depth level tuned for scroll performance.
/// Use `.flat` inside long lists; reserve shadows for a few cards per screen.
enum SurfaceElevation {
    case flat
    case raised
    case prominent
}

extension Theme {
    enum Shadow {
        static let raised = (color: Color.black.opacity(0.26), radius: CGFloat(8), y: CGFloat(4))
        static let prominent = (color: Color.black.opacity(0.34), radius: CGFloat(12), y: CGFloat(6))
    }
}

struct CardSurface: View {
    let cornerRadius: CGFloat
    let accent: Color

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Theme.card,
                        Theme.card.opacity(0.94),
                        Theme.background.opacity(0.5)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.13),
                                accent.opacity(0.26),
                                Color.white.opacity(0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

struct InsetSurface: View {
    let cornerRadius: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Theme.background.opacity(0.55),
                        Theme.background.opacity(0.32)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.07), lineWidth: 1)
            )
    }
}

struct AccentOrbBackground: View {
    let accent: Color
    var cornerRadius: CGFloat = 12
    var size: CGFloat = 48

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [accent.opacity(0.22), accent.opacity(0.08)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size, height: size)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(accent.opacity(0.28), lineWidth: 1)
            )
    }
}

private struct SurfaceShadowModifier: ViewModifier {
    let elevation: SurfaceElevation

    func body(content: Content) -> some View {
        switch elevation {
        case .flat:
            content
        case .raised:
            content.shadow(
                color: Theme.Shadow.raised.color,
                radius: Theme.Shadow.raised.radius,
                y: Theme.Shadow.raised.y
            )
        case .prominent:
            content.shadow(
                color: Theme.Shadow.prominent.color,
                radius: Theme.Shadow.prominent.radius,
                y: Theme.Shadow.prominent.y
            )
        }
    }
}

extension View {
    func surfaceBackground(
        cornerRadius: CGFloat = Theme.Radius.lg,
        accent: Color = Theme.accent
    ) -> some View {
        background(CardSurface(cornerRadius: cornerRadius, accent: accent))
    }

    func surfaceStyle(
        cornerRadius: CGFloat = Theme.Radius.lg,
        accent: Color = Theme.accent,
        elevation: SurfaceElevation = .flat
    ) -> some View {
        background(CardSurface(cornerRadius: cornerRadius, accent: accent))
            .modifier(SurfaceShadowModifier(elevation: elevation))
    }

    func insetSurface(cornerRadius: CGFloat = Theme.Radius.sm) -> some View {
        background(InsetSurface(cornerRadius: cornerRadius))
    }

    func elevatedShadow(_ elevation: SurfaceElevation) -> some View {
        modifier(SurfaceShadowModifier(elevation: elevation))
    }
}
