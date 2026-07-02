import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Theme.accent.opacity(0.2), Theme.accent.opacity(0.04)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 56
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Theme.accent.opacity(0.45), Theme.accent.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                Text(icon)
                    .font(.system(size: 48))
            }
            Text(title)
                .font(.title3.bold())
                .foregroundColor(Theme.primaryText)
            Text(message)
                .font(.subheadline)
                .foregroundColor(Theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}
