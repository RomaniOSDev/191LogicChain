import SwiftUI

struct HomeHeroWidget: View {
    let wins: Int
    let bestChain: Int
    let streak: Int
    let badges: Int

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("HomeHero")
                .resizable()
                .scaledToFill()
                .frame(height: 240)
                .clipped()

            LinearGradient(
                colors: [
                    Color.black.opacity(0.15),
                    Color.black.opacity(0.45),
                    Color.black.opacity(0.88)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                VStack(alignment: .leading, spacing: 6) {
                    TagBadge(text: "HOME", color: Theme.accent)
                    Text("Word Logic Chains")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Text("Connect words letter by letter")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.82))
                }

                HStack(spacing: 8) {
                    heroStat(icon: "🏆", value: "\(wins)", label: "Wins")
                    heroStat(icon: "📝", value: "\(bestChain)", label: "Best")
                    heroStat(icon: "🔥", value: "\(streak)", label: "Streak")
                    heroStat(icon: "🏅", value: "\(badges)", label: "Badges")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Theme.Spacing.md)
        }
        .frame(height: 240)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Theme.accent.opacity(0.5), Color.white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .elevatedShadow(.prominent)
    }

    private func heroStat(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(icon).font(.caption)
            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(.white)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.14), Color.white.opacity(0.06)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                        .stroke(Color.white.opacity(0.14), lineWidth: 1)
                )
        )
    }
}
