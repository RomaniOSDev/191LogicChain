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
                tileBackground

                LinearGradient(
                    colors: [
                        Color.black.opacity(0.05),
                        Color.black.opacity(0.35),
                        Color.black.opacity(0.82)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                HStack(alignment: .bottom, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.82))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "arrow.up.right.circle.fill")
                        .font(.title3)
                        .foregroundColor(accent)
                }
                .padding(12)
            }
            .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
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
        .frame(maxWidth: .infinity)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded { _ in pressed = false }
        )
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
