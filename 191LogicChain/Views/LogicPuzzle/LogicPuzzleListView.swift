import SwiftUI

struct LogicPuzzleListView: View {
    @StateObject private var viewModel: LogicPuzzleViewModel

    init(viewModel: LogicPuzzleViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(title: "Logic Puzzles", subtitle: "Special rules & constraints", onBack: viewModel.goBack) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.levels) { level in
                        PuzzleLevelCell(level: level) { viewModel.play(level) }
                    }
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.sm)
            }
        }
        .onAppear { viewModel.load() }
    }
}
