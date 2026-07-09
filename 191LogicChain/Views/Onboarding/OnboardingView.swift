import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel

    init(onComplete: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(onComplete: onComplete))
    }

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Skip", action: viewModel.skip)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(Theme.secondaryText)
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.top, Theme.Spacing.sm)

                TabView(selection: $viewModel.currentPage) {
                    ForEach(viewModel.pages) { page in
                        OnboardingPageContent(page: page)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.25), value: viewModel.currentPage)

                pageIndicator
                    .padding(.bottom, Theme.Spacing.md)

                actionButton
                    .adaptiveContentWidth()
                    .adaptiveHorizontalPadding()
                    .padding(.bottom, Theme.Spacing.xl)
            }
            .adaptiveContentWidth()
            .adaptiveHorizontalPadding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.pages) { page in
                Capsule()
                    .fill(
                        page.id == viewModel.currentPage
                        ? viewModel.pages[viewModel.currentPage].accent
                        : Theme.secondaryText.opacity(0.25)
                    )
                    .frame(width: page.id == viewModel.currentPage ? 24 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.currentPage)
            }
        }
    }

    private var actionButton: some View {
        AnimatedButton(
            title: viewModel.isLastPage ? "Get Started" : "Continue",
            icon: viewModel.isLastPage ? "arrow.right" : "chevron.right",
            color: viewModel.pages[viewModel.currentPage].accent,
            action: viewModel.next
        )
    }
}

private struct OnboardingPageContent: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [page.accent.opacity(0.22), page.accent.opacity(0.04)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 90
                        )
                    )
                    .frame(width: 160, height: 160)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [page.accent.opacity(0.45), page.accent.opacity(0.12)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )

                Text(page.icon)
                    .font(.system(size: 72))
            }
            .elevatedShadow(.raised)

            VStack(spacing: Theme.Spacing.sm) {
                Text(page.title)
                    .font(.title.bold())
                    .foregroundColor(Theme.primaryText)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.body)
                    .foregroundColor(Theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, Theme.Spacing.lg)
            }

            pagePreview
                .padding(.horizontal, Theme.Spacing.md)

            Spacer()
        }
    }

    @ViewBuilder
    private var pagePreview: some View {
        switch page.id {
        case 0:
            AppCard(accent: page.accent, elevation: .raised) {
                VStack(spacing: 12) {
                    Text("Example chain")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(Theme.secondaryText)
                    WordChainBadge(start: "Cat", end: "Rabbit", size: .title3)
                    HStack(spacing: 6) {
                        miniWord("Cat", color: Theme.accent)
                        arrow
                        miniWord("Tiger", color: Theme.primaryText)
                        arrow
                        miniWord("Rabbit", color: Theme.danger)
                    }
                    .font(.caption.weight(.semibold))
                }
                .frame(maxWidth: .infinity)
            }
        case 1:
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                spacing: 10
            ) {
                modeChip("Solo", icon: "person.fill", color: Theme.accent)
                modeChip("Battle", icon: "bolt.fill", color: Theme.danger)
                modeChip("Puzzles", icon: "puzzlepiece.fill", color: Color(hex: "7b68ee"))
                modeChip("Daily", icon: "sun.max.fill", color: Color(hex: "ffa500"))
                modeChip("Weekly", icon: "calendar", color: Theme.accent)
                modeChip("Friends", icon: "person.2.fill", color: Color(hex: "4ecdc4"))
            }
            .padding(Theme.Spacing.md)
            .surfaceStyle(cornerRadius: Theme.Radius.lg, accent: page.accent, elevation: .raised)
        default:
            HStack(spacing: 10) {
                progressChip(icon: "tree.fill", label: "Skills", value: "Lv 3")
                progressChip(icon: "medal.fill", label: "Badges", value: "12")
                progressChip(icon: "crown.fill", label: "Rank", value: "#1")
            }
            .padding(Theme.Spacing.md)
            .surfaceStyle(cornerRadius: Theme.Radius.lg, accent: page.accent, elevation: .raised)
        }
    }

    private var arrow: some View {
        Image(systemName: "arrow.right")
            .font(.caption2.weight(.bold))
            .foregroundColor(Theme.secondaryText)
    }

    private func miniWord(_ text: String, color: Color) -> some View {
        Text(text)
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.16), color.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
    }

    private func modeChip(_ label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(color)
            Text(label)
                .font(.caption2.weight(.medium))
                .foregroundColor(Theme.primaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .surfaceStyle(cornerRadius: Theme.Radius.sm, accent: color, elevation: .flat)
    }

    private func progressChip(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(page.accent)
            Text(value)
                .font(.headline.bold())
                .foregroundColor(Theme.primaryText)
            Text(label)
                .font(.caption2)
                .foregroundColor(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .insetSurface(cornerRadius: Theme.Radius.sm)
    }
}
