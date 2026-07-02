import SwiftUI

struct AchievementsView: View {
    @StateObject private var viewModel: AchievementsViewModel

    init(viewModel: AchievementsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(
            title: "Achievements",
            subtitle: "\(viewModel.unlockedCount) of \(viewModel.records.count) unlocked",
            onBack: viewModel.goBack
        ) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.records, id: \.id) { record in
                        AchievementRowCell(record: record)
                    }
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.sm)
            }
        }
        .onAppear { viewModel.load() }
    }
}
