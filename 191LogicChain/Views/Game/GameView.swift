import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @FocusState private var isInputFocused: Bool

    init(viewModel: GameViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(title: viewModel.mode.displayName, subtitle: "Build your chain", onBack: viewModel.goBack) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.md) {
                    HStack {
                        TagBadge(text: "\(viewModel.chainLength) words")
                        if let optimal = viewModel.optimalChainLength {
                            TagBadge(text: "Optimal: \(optimal)", color: Color(hex: "ffa500"))
                        } else {
                            TagBadge(text: "Min: \(viewModel.minWords)", color: Theme.secondaryText)
                        }
                        Spacer()
                        if !viewModel.isGameOver {
                            TimerCountdownView(timeLeft: viewModel.timeLeft, totalTime: viewModel.timeLimit)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)

                    if !viewModel.constraintHint.isEmpty {
                        AppCard(accent: Theme.danger, padding: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(Theme.danger)
                                Text(viewModel.constraintHint)
                                    .font(.caption)
                                    .foregroundColor(Theme.primaryText)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                    }

                    ChainDisplayView(
                        startWord: viewModel.startWord,
                        endWord: viewModel.endWord,
                        chain: viewModel.chain,
                        isWin: viewModel.isWin,
                        isGameOver: viewModel.isGameOver
                    )

                    AppCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Current: \(viewModel.currentWord)")
                                .font(.headline)
                                .foregroundColor(Theme.accent)

                            HStack(spacing: 10) {
                                AppTextField(placeholder: "Enter next word", text: $viewModel.currentInput, icon: "textformat")
                                    .focused($isInputFocused)
                                    .disabled(viewModel.isGameOver)

                                Button(action: viewModel.submitWord) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(
                                            viewModel.canSubmit
                                            ? LinearGradient(colors: [Theme.accent, Theme.accent.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                                            : LinearGradient(colors: [.gray, .gray], startPoint: .top, endPoint: .bottom)
                                        )
                                }
                                .disabled(!viewModel.canSubmit)
                            }

                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(Theme.danger)
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)

                    if !viewModel.isGameOver && !viewModel.possibleWords.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            SectionHeaderView(title: "Suggestions", trailing: "\(viewModel.possibleWords.count)")
                                .padding(.horizontal, Theme.Spacing.md)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(viewModel.possibleWords.prefix(8)) { word in
                                        Button {
                                            viewModel.currentInput = word.text
                                        } label: {
                                            Text(word.text)
                                                .font(.caption.weight(.medium))
                                                .foregroundColor(Theme.primaryText)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(
                                                    Capsule()
                                                        .fill(
                                                            LinearGradient(
                                                                colors: [Theme.card, Theme.background.opacity(0.45)],
                                                                startPoint: .topLeading,
                                                                endPoint: .bottomTrailing
                                                            )
                                                        )
                                                        .overlay(Capsule().stroke(Theme.accent.opacity(0.22), lineWidth: 1))
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal, Theme.Spacing.md)
                            }
                        }
                    }

                    if !viewModel.isGameOver && viewModel.hintCounter < 3 {
                        Button(action: viewModel.useHint) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                Text("Hint (\(viewModel.hintCounter)/3)")
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundColor(Theme.accent)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [Theme.accent.opacity(0.16), Theme.accent.opacity(0.08)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(Capsule().stroke(Theme.accent.opacity(0.28), lineWidth: 1))
                            )
                        }
                    }
                }
                .padding(.vertical, Theme.Spacing.sm)
            }
        }
        .onAppear { isInputFocused = true }
    }
}
