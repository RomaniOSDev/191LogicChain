import SwiftUI

struct SkillTreeView: View {
    @StateObject private var viewModel: SkillTreeViewModel

    init(viewModel: SkillTreeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(title: "Skill Tree", subtitle: "Level up your abilities", onBack: viewModel.goBack) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.md) {
                    AppCard(accent: Theme.accent) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Max Skill Level")
                                    .font(.caption)
                                    .foregroundColor(Theme.secondaryText)
                                Text("\(SkillType.allCases.map { viewModel.progress.level(for: $0) }.max() ?? 1)")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(Theme.accent)
                            }
                            Spacer()
                            Text("🌳").font(.system(size: 48))
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)

                    SectionHeaderView(title: "Skills")
                        .padding(.horizontal, Theme.Spacing.md)

                    ForEach(SkillType.allCases, id: \.self) { skill in
                        SkillRowCell(
                            skill: skill,
                            level: viewModel.progress.level(for: skill),
                            progress: viewModel.progress.progressToNextLevel(for: skill)
                        )
                    }
                    .padding(.horizontal, Theme.Spacing.md)

                    SectionHeaderView(title: "Unlocks")
                        .padding(.horizontal, Theme.Spacing.md)

                    AppCard {
                        VStack(spacing: 8) {
                            ForEach(FeatureUnlock.allCases, id: \.self) { feature in
                                FeatureUnlockCell(feature: feature, isUnlocked: viewModel.isUnlocked(feature))
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                }
                .padding(.vertical, Theme.Spacing.sm)
            }
        }
        .onAppear { viewModel.refresh() }
    }
}
