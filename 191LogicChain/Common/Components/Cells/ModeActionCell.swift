import SwiftUI

struct ModeActionCell: View {
    let icon: String
    let title: String
    let subtitle: String
    let accent: Color
    let action: () -> Void

    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    AccentOrbBackground(accent: accent)
                    Text(icon)
                        .font(.title2)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Theme.primaryText)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(Theme.secondaryText)
                        .lineLimit(2)
                }

                Spacer(minLength: 4)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(accent)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [accent.opacity(0.18), accent.opacity(0.08)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            }
            .padding(14)
            .surfaceStyle(cornerRadius: Theme.Radius.lg, accent: accent, elevation: .flat)
            .scaleEffect(pressed ? 0.98 : 1)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded { _ in pressed = false }
        )
    }
}

struct QuickActionCell: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(Theme.accent)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Theme.accent.opacity(0.18), Theme.accent.opacity(0.08)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Theme.accent.opacity(0.22), lineWidth: 1)
                            )
                    )
                Text(label)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(Theme.primaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .surfaceStyle(cornerRadius: Theme.Radius.md, accent: Theme.accent, elevation: .flat)
        }
        .buttonStyle(.plain)
    }
}
