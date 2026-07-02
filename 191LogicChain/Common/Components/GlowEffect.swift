import SwiftUI

struct GlowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content.shadow(color: color.opacity(0.45), radius: radius, y: 0)
    }
}

extension View {
    func glow(color: Color = Theme.accent, radius: CGFloat = 8) -> some View {
        modifier(GlowEffect(color: color, radius: radius))
    }
}
