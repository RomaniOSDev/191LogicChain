import SwiftUI

struct ScreenScaffold<Content: View>: View {
    let title: String?
    let subtitle: String?
    let onBack: (() -> Void)?
    @ViewBuilder let content: () -> Content

    init(
        title: String? = nil,
        subtitle: String? = nil,
        onBack: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.onBack = onBack
        self.content = content
    }

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 0) {
                if onBack != nil || title != nil {
                    navBar
                        .adaptiveContentWidth()
                        .adaptiveHorizontalPadding()
                }
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }

    private var navBar: some View {
        HStack(spacing: 12) {
            if let onBack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.body.weight(.semibold))
                        .foregroundColor(Theme.accent)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Theme.card, Theme.background.opacity(0.5)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(Circle().stroke(Theme.accent.opacity(0.25), lineWidth: 1))
                        )
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                if let title {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Theme.primaryText)
                }
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(Theme.secondaryText)
                }
            }

            Spacer()
        }
        .padding(.vertical, Theme.Spacing.sm)
        .background(
            LinearGradient(
                colors: [Theme.background.opacity(0.85), Theme.background.opacity(0.35)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct ScreenHeroHeader: View {
    let emoji: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Theme.accent.opacity(0.18), Theme.accent.opacity(0.04)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .frame(width: 88, height: 88)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Theme.accent.opacity(0.4), Theme.accent.opacity(0.12)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                Text(emoji)
                    .font(.system(size: 44))
            }
            Text(title)
                .font(.title2.bold())
                .foregroundColor(Theme.primaryText)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(Theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.sm)
    }
}

struct SectionHeaderView: View {
    let title: String
    var trailing: String? = nil

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            RoundedRectangle(cornerRadius: 2)
                .fill(
                    LinearGradient(
                        colors: [Theme.accent, Theme.accent.opacity(0.55)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 3, height: 18)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(Theme.primaryText)
            Spacer()
            if let trailing {
                Text(trailing)
                    .font(.caption)
                    .foregroundColor(Theme.secondaryText)
            }
        }
    }
}
