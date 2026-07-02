import SwiftUI

struct ChallengeHighlightCell: View {
    let badge: String
    let title: String
    let chainStart: String
    let chainEnd: String
    let meta: String
    var footer: String? = nil
    var accent: Color = Theme.accent
    var isCompleted: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    TagBadge(text: badge, color: accent)
                    Spacer()
                    Image(systemName: isCompleted ? "checkmark.seal.fill" : "arrow.up.right")
                        .foregroundColor(accent)
                }

                WordChainBadge(start: chainStart, end: chainEnd)

                Text(meta)
                    .font(.caption)
                    .foregroundColor(Theme.secondaryText)

                if let footer {
                    Text(footer)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(accent)
                }

                if !isCompleted {
                    HStack {
                        Spacer()
                        Text("Tap to play")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(accent)
                    }
                }
            }
            .padding(16)
            .surfaceStyle(cornerRadius: Theme.Radius.lg, accent: accent, elevation: .raised)
        }
        .buttonStyle(.plain)
        .disabled(isCompleted)
        .opacity(isCompleted ? 0.75 : 1)
    }
}
