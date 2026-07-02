import SwiftUI

struct HomeImageTile: View {
    let imageName: String
    let title: String
    let subtitle: String
    var accent: Color = Theme.accent
    var height: CGFloat = 148
    let action: () -> Void

    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .clipped()

                LinearGradient(
                    colors: [
                        Color.black.opacity(0.05),
                        Color.black.opacity(0.35),
                        Color.black.opacity(0.82)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.82))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }

                    Spacer(minLength: 8)

                    Image(systemName: "arrow.up.right.circle.fill")
                        .font(.title3)
                        .foregroundColor(accent)
                }
                .padding(14)
            }
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [accent.opacity(0.55), Color.white.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .elevatedShadow(.raised)
            .scaleEffect(pressed ? 0.97 : 1)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded { _ in pressed = false }
        )
    }
}
