import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var viewModel: StatisticsViewModel

    init(viewModel: StatisticsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(title: "Statistics", subtitle: "Your performance overview", onBack: viewModel.goBack) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.md) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        StatPillCell(icon: "🎮", value: "\(viewModel.stats.totalGames)", label: "Games")
                        StatPillCell(icon: "🏆", value: "\(viewModel.stats.totalWins)", label: "Wins")
                        StatPillCell(icon: "📊", value: String(format: "%.0f%%", viewModel.winRate), label: "Win Rate")
                        StatPillCell(icon: "📝", value: "\(viewModel.stats.bestChainLength)", label: "Best Chain")
                        StatPillCell(icon: "📈", value: String(format: "%.1f", viewModel.stats.averageChainLength), label: "Avg Chain")
                        StatPillCell(icon: "🔥", value: "\(viewModel.stats.streaks)", label: "Streak", accent: Theme.danger)
                    }

                    if !viewModel.winsByMode.isEmpty {
                        AppCard {
                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeaderView(title: "Wins by Mode")
                                Chart(viewModel.winsByMode) { point in
                                    BarMark(
                                        x: .value("Mode", point.label),
                                        y: .value("Wins", point.value)
                                    )
                                    .foregroundStyle(Theme.accent.gradient)
                                    .cornerRadius(4)
                                }
                                .frame(height: 180)
                                .chartYAxis {
                                    AxisMarks { _ in
                                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                                            .foregroundStyle(Theme.secondaryText.opacity(0.3))
                                        AxisValueLabel().foregroundStyle(Theme.secondaryText)
                                    }
                                }
                                .chartXAxis {
                                    AxisMarks { _ in
                                        AxisValueLabel().foregroundStyle(Theme.secondaryText)
                                    }
                                }
                            }
                        }
                    }

                    if !viewModel.chainLengthTrend.isEmpty {
                        AppCard {
                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeaderView(title: "Recent Chain Length")
                                Chart(viewModel.chainLengthTrend) { point in
                                    LineMark(
                                        x: .value("Game", point.label),
                                        y: .value("Words", point.value)
                                    )
                                    .foregroundStyle(Theme.accent)
                                    .interpolationMethod(.catmullRom)
                                    PointMark(
                                        x: .value("Game", point.label),
                                        y: .value("Words", point.value)
                                    )
                                    .foregroundStyle(Theme.accent)
                                }
                                .frame(height: 160)
                            }
                        }
                    }

                    if viewModel.recentSessions.isEmpty {
                        EmptyStateView(
                            icon: "📊",
                            title: "No Games Yet",
                            message: "Play your first game to see statistics here."
                        )
                    }
                }
                .adaptiveContentWidth()
                .adaptiveHorizontalPadding()
                .padding(.vertical, Theme.Spacing.sm)
            }
        }
        .onAppear { viewModel.loadData() }
    }
}
