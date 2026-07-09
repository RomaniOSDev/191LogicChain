import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.xl) {
                    HomeHeroWidget(
                        wins: viewModel.stats.totalWins,
                        bestChain: viewModel.stats.bestChainLength,
                        streak: viewModel.stats.maxStreaks,
                        badges: viewModel.unlockedAchievements
                    )

                    if viewModel.weeklyCampaign != nil || viewModel.dailyChallenge != nil {
                        VStack(spacing: Theme.Spacing.md) {
                            SectionHeaderView(title: "Featured Challenges")

                            VStack(spacing: Theme.Spacing.sm) {
                                if let campaign = viewModel.weeklyCampaign {
                                    HomeChallengeWidget(
                                        imageName: "WidgetWeekly",
                                        badge: "WEEKLY",
                                        title: campaign.themeTitle,
                                        chainStart: campaign.days.first?.startWord ?? "—",
                                        chainEnd: campaign.bossDay?.endWord ?? "—",
                                        meta: "\(campaign.completedCount)/7 days completed",
                                        footer: campaign.bossDay?.completed == true
                                            ? "Boss defeated!"
                                            : "Boss awaits on Day 7",
                                        accent: Color(hex: "ffa500"),
                                        isCompleted: campaign.completedCount == 7,
                                        action: viewModel.goToWeeklyCampaign
                                    )
                                }

                                if let challenge = viewModel.dailyChallenge {
                                    HomeChallengeWidget(
                                        imageName: "WidgetDaily",
                                        badge: "DAILY",
                                        title: "Today's Challenge",
                                        chainStart: challenge.startWord,
                                        chainEnd: challenge.endWord,
                                        meta: challenge.category.labeledName,
                                        footer: challenge.completed
                                            ? "Completed · \(challenge.score ?? 0) pts"
                                            : nil,
                                        isCompleted: challenge.completed,
                                        action: viewModel.startDailyChallenge
                                    )
                                }
                            }
                        }
                    }

                    VStack(spacing: Theme.Spacing.md) {
                        SectionHeaderView(title: "Play Modes")
                        HomeModeGridWidget(
                            onSolo: { viewModel.startGame(mode: .solo) },
                            onBattle: viewModel.goToBattle,
                            onTimeAttack: { viewModel.startGame(mode: .time) },
                            onMinimal: viewModel.startMinimalChain,
                            onPuzzles: viewModel.goToLogicPuzzles
                        )
                    }

                    VStack(spacing: Theme.Spacing.md) {
                        SectionHeaderView(title: "Create & Share")
                        HomeCreateShareWidget(
                            onChainBuilder: viewModel.goToChainBuilder,
                            onFriendChallenge: viewModel.goToFriendChallenge
                        )
                    }

                    VStack(spacing: Theme.Spacing.md) {
                        SectionHeaderView(title: "Progress")
                        HomeQuickAccessWidget(
                            onStatistics: viewModel.goToStatistics,
                            onLeaderboard: viewModel.goToLeaderboard,
                            onSkillTree: viewModel.goToSkillTree,
                            onAchievements: viewModel.goToAchievements,
                            onDictionary: viewModel.goToDictionary,
                            onSettings: viewModel.goToSettings
                        )
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.top, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.xxl)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .playAgain)) { _ in
            viewModel.refresh()
            viewModel.startGame(mode: .solo)
        }
        .onAppear { viewModel.refresh() }
    }
}
