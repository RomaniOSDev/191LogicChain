import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel: LeaderboardViewModel

    init(viewModel: LeaderboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(title: "Leaderboard", subtitle: "Top scores", onBack: viewModel.goBack) {
            VStack(spacing: Theme.Spacing.md) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChipView(title: "All", isSelected: viewModel.selectedMode == nil) {
                            viewModel.selectMode(nil)
                        }
                        ForEach(GameMode.allCases, id: \.self) { mode in
                            FilterChipView(title: mode.displayName, isSelected: viewModel.selectedMode == mode) {
                                viewModel.selectMode(mode)
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                }

                if viewModel.entries.isEmpty {
                    EmptyStateView(
                        icon: "🏆",
                        title: "No Records Yet",
                        message: "Win a game to appear on the leaderboard!"
                    )
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 10) {
                            ForEach(Array(viewModel.entries.enumerated()), id: \.element.id) { index, entry in
                                LeaderboardRowCell(
                                    rank: index,
                                    name: entry.playerName,
                                    detail: "\(entry.mode.displayName) · \(entry.chainLength) words",
                                    score: entry.score
                                )
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                        .padding(.bottom, Theme.Spacing.lg)
                    }
                }
            }
        }
    }
}
