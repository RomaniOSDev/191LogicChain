import SwiftUI

struct GradientBackground: View {
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            RadialGradient(
                colors: [Theme.accent.opacity(0.14), Theme.accent.opacity(0.04), .clear],
                center: UnitPoint(x: 0.12, y: 0.08),
                startRadius: 0,
                endRadius: 320
            )
            .ignoresSafeArea()

            RadialGradient(
                colors: [Theme.danger.opacity(0.1), .clear],
                center: UnitPoint(x: 0.88, y: 0.72),
                startRadius: 0,
                endRadius: 280
            )
            .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Theme.background.opacity(0.15),
                    Theme.background.opacity(0.72),
                    Theme.background
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}
