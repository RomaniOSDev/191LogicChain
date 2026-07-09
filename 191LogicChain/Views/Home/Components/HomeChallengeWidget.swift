import SwiftUI

struct HomeChallengeWidget: View {
    let imageName: String
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
            ZStack {
                tileBackground

                LinearGradient(
                    colors: [
                        Color.black.opacity(0.1),
                        Color.black.opacity(0.55),
                        Color.black.opacity(0.9)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        TagBadge(text: badge, color: accent)
                        Spacer(minLength: 8)
                        Image(systemName: isCompleted ? "checkmark.seal.fill" : "play.circle.fill")
                            .font(.title3)
                            .foregroundColor(accent)
                    }

                    Spacer(minLength: 8)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)

                        WordChainBadge(start: chainStart, end: chainEnd)

                        Text(meta)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.75))
                            .lineLimit(1)

                        if let footer {
                            Text(footer)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(accent)
                                .lineLimit(1)
                        } else if !isCompleted {
                            Text("Tap to play")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(accent)
                        }
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, minHeight: 176, maxHeight: 176)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [accent.opacity(isCompleted ? 0.55 : 0.38), Color.white.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .elevatedShadow(.raised)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .disabled(isCompleted)
        .opacity(isCompleted ? 0.8 : 1)
    }

    private var tileBackground: some View {
        GeometryReader { geo in
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}
