import SwiftUI

struct DailyChallengeView: View {
    @StateObject private var viewModel: DailyChallengeViewModel

    init(viewModel: DailyChallengeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(title: "Daily Challenge", subtitle: "One puzzle every day", onBack: viewModel.goBack) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.lg) {
                    if let challenge = viewModel.challenge {
                        AppCard(accent: Theme.accent) {
                            VStack(spacing: Theme.Spacing.md) {
                                Text("📅").font(.system(size: 48))
                                Text("Today's Challenge")
                                    .font(.headline)
                                    .foregroundColor(Theme.primaryText)
                                WordChainBadge(start: challenge.startWord, end: challenge.endWord)
                                HStack(spacing: 8) {
                                    TagBadge(text: challenge.category.labeledName)
                                    TagBadge(text: challenge.difficulty.displayName, color: Color(hex: "ffa500"))
                                }
                                if challenge.completed {
                                    VStack(spacing: 4) {
                                        TagBadge(text: "Completed", color: Theme.accent)
                                        if let score = challenge.score {
                                            Text("\(score) points")
                                                .font(.title3.bold())
                                                .foregroundColor(Theme.accent)
                                        }
                                        if let chain = challenge.chain {
                                            Text(chain.joined(separator: " → "))
                                                .font(.caption)
                                                .foregroundColor(Theme.secondaryText)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                } else {
                                    AnimatedButton(title: "Start Challenge", icon: "play.fill", color: Theme.accent) {
                                        viewModel.startChallenge()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                    }

                    if !viewModel.history.isEmpty {
                        SectionHeaderView(title: "Past Challenges")
                            .padding(.horizontal, Theme.Spacing.md)
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.history.prefix(5)) { item in
                                AppCard {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.date)
                                                .font(.caption)
                                                .foregroundColor(Theme.secondaryText)
                                            WordChainBadge(start: item.startWord, end: item.endWord, size: .subheadline)
                                        }
                                        Spacer()
                                        if let score = item.score {
                                            Text("\(score)")
                                                .font(.title3.bold())
                                                .foregroundColor(Theme.accent)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                    }
                }
                .padding(.vertical, Theme.Spacing.sm)
            }
        }
    }
}
