import SwiftUI

struct ResultView: View {
    @StateObject private var viewModel: ResultViewModel
    @State private var animationScale: CGFloat = 0.5

    init(viewModel: ResultViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.lg) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        (viewModel.session.isWin ? Theme.accent : Theme.danger).opacity(0.22),
                                        (viewModel.session.isWin ? Theme.accent : Theme.danger).opacity(0.04)
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 140, height: 140)
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                (viewModel.session.isWin ? Theme.accent : Theme.danger).opacity(0.5),
                                                (viewModel.session.isWin ? Theme.accent : Theme.danger).opacity(0.15)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                        Text(viewModel.scoreEmoji)
                            .font(.system(size: 72))
                            .scaleEffect(animationScale)
                    }
                    .onAppear {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                            animationScale = 1.0
                        }
                    }

                    VStack(spacing: 4) {
                        Text(viewModel.session.isWin ? "VICTORY!" : "DEFEAT")
                            .font(.title.bold())
                            .foregroundColor(viewModel.session.isWin ? Theme.accent : Theme.danger)
                        Text(viewModel.scoreMessage)
                            .font(.subheadline)
                            .foregroundColor(Theme.secondaryText)
                            .multilineTextAlignment(.center)
                    }

                    AppCard(accent: Theme.accent) {
                        VStack(spacing: 4) {
                            Text("\(viewModel.session.score)")
                                .font(.system(size: 52, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.accent)
                            Text("points")
                                .font(.subheadline)
                                .foregroundColor(Theme.secondaryText)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, Theme.Spacing.md)

                    HStack(spacing: 10) {
                        StatPillCell(icon: "📝", value: "\(viewModel.session.chain.count)", label: "Words")
                        StatPillCell(icon: "⏱️", value: "\(viewModel.session.timeUsed)s", label: "Time")
                        StatPillCell(icon: "🏆", value: "\(viewModel.stats.bestChainLength)", label: "Record", accent: Color(hex: "ffa500"))
                    }
                    .padding(.horizontal, Theme.Spacing.md)

                    if viewModel.isNewRecord {
                        TagBadge(text: "🎉 NEW RECORD!", color: Color(hex: "ffa500"))
                    }

                    AppCard {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeaderView(title: "Your Chain")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(Array(viewModel.session.chain.enumerated()), id: \.offset) { index, word in
                                        if index > 0 {
                                            Image(systemName: "arrow.right")
                                                .font(.caption2)
                                                .foregroundColor(Theme.secondaryText)
                                        }
                                        Text(word)
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundColor(
                                                index == viewModel.session.chain.count - 1 && viewModel.session.isWin
                                                ? Theme.accent : Theme.primaryText
                                            )
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(
                                                Capsule()
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [
                                                                Theme.background.opacity(0.55),
                                                                Theme.background.opacity(0.32)
                                                            ],
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                                    .overlay(Capsule().stroke(Color.white.opacity(0.07), lineWidth: 1))
                                            )
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)

                    if !viewModel.newAchievements.isEmpty {
                        AppCard(accent: Color(hex: "ffa500")) {
                            VStack(spacing: 8) {
                                SectionHeaderView(title: "New Achievements!")
                                ForEach(viewModel.newAchievements, id: \.self) { achievement in
                                    HStack {
                                        Text(achievement.icon)
                                        Text(achievement.title)
                                            .foregroundColor(Theme.primaryText)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                    }

                    ChainAnalysisView(analysis: viewModel.analysis)
                        .padding(.horizontal, Theme.Spacing.md)

                    VStack(spacing: 10) {
                        AnimatedButton(title: "Play Again", icon: "arrow.clockwise", color: Theme.accent, action: viewModel.playAgain)
                        AnimatedButton(title: "Home", icon: "house.fill", color: Theme.secondaryText, style: .outline, action: viewModel.goHome)
                        AnimatedButton(title: "Records", icon: "crown.fill", color: Theme.accent, style: .outline, action: viewModel.goToLeaderboard)
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.bottom, Theme.Spacing.xl)
                }
                .padding(.top, Theme.Spacing.md)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
