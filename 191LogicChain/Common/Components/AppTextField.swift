import SwiftUI

struct AppTextField: View {
    let placeholder: String
    @Binding var text: String
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 10) {
            if let icon {
                Image(systemName: icon)
                    .foregroundColor(Theme.accent)
                    .frame(width: 20)
            }
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .foregroundColor(Theme.primaryText)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .insetSurface(cornerRadius: Theme.Radius.md)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                .stroke(Theme.accent.opacity(0.22), lineWidth: 1)
        )
    }
}

struct WordChainBadge: View {
    let start: String
    let end: String
    var size: Font = .title3

    var body: some View {
        HStack(spacing: 8) {
            Text(start)
                .font(size.weight(.bold))
                .foregroundColor(Theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Image(systemName: "arrow.right")
                .font(.caption.weight(.bold))
                .foregroundColor(Theme.secondaryText)
            Text(end)
                .font(size.weight(.bold))
                .foregroundColor(Theme.danger)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }
}

struct TagBadge: View {
    let text: String
    var color: Color = Theme.accent

    var body: some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.2), color.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(Capsule().stroke(color.opacity(0.28), lineWidth: 1))
            )
    }
}

struct FilterChipView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(isSelected ? Theme.background : Theme.primaryText)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(
                            isSelected
                            ? LinearGradient(
                                colors: [Theme.accent, Theme.accent.opacity(0.78)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [Theme.card, Theme.background.opacity(0.45)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Capsule().stroke(Theme.accent.opacity(isSelected ? 0.35 : 0.22), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(.plain)
    }
}
