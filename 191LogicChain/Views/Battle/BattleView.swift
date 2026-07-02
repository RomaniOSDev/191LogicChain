import SwiftUI

struct BattleView: View {
    @StateObject private var viewModel: BattleViewModel
    @FocusState private var isInputFocused: Bool

    init(viewModel: BattleViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(title: "AI Battle", subtitle: viewModel.statusMessage, onBack: viewModel.goBack) {
            VStack(spacing: Theme.Spacing.md) {
                HStack(spacing: 12) {
                    scoreCard(title: "You", score: viewModel.playerScore, color: Theme.accent, active: viewModel.isPlayerTurn)
                    Text("VS")
                        .font(.caption.bold())
                        .foregroundColor(Theme.danger)
                        .padding(.horizontal, 4)
                    scoreCard(title: "AI", score: viewModel.aiScore, color: Theme.danger, active: !viewModel.isPlayerTurn && !viewModel.isGameOver)
                }
                .padding(.horizontal, Theme.Spacing.md)

                ChainDisplayView(
                    startWord: viewModel.startWord,
                    endWord: viewModel.endWord,
                    chain: viewModel.chain,
                    isWin: viewModel.isWin,
                    isGameOver: viewModel.isGameOver
                )

                if viewModel.isPlayerTurn && !viewModel.isGameOver {
                    AppCard {
                        HStack(spacing: 10) {
                            AppTextField(placeholder: "Your word", text: $viewModel.currentInput, icon: "textformat")
                                .focused($isInputFocused)
                            Button(action: viewModel.submitPlayerWord) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Theme.accent)
                            }
                        }
                        if let error = viewModel.errorMessage {
                            Text(error).font(.caption).foregroundColor(Theme.danger)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                } else if !viewModel.isGameOver {
                    HStack(spacing: 8) {
                        ProgressView().tint(Theme.accent)
                        Text("AI is thinking...")
                            .font(.caption)
                            .foregroundColor(Theme.secondaryText)
                    }
                    .padding()
                }

                Spacer()
            }
            .padding(.vertical, Theme.Spacing.sm)
        }
        .onAppear { isInputFocused = true }
    }

    private func scoreCard(title: String, score: Int, color: Color, active: Bool) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(active ? color : Theme.secondaryText)
            Text("\(score)")
                .font(.title.bold())
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .surfaceStyle(cornerRadius: Theme.Radius.md, accent: color, elevation: .flat)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                .stroke(active ? color.opacity(0.55) : Color.clear, lineWidth: 1.5)
        )
    }
}
