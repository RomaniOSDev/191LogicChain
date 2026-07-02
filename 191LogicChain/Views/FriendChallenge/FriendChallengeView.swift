import SwiftUI

struct FriendChallengeView: View {
    @StateObject private var viewModel: FriendChallengeViewModel

    init(viewModel: FriendChallengeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(title: "Friend Challenge", subtitle: "Play together or share codes", onBack: viewModel.goBack) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.lg) {
                    AppCard(accent: Theme.accent) {
                        VStack(spacing: 12) {
                            SectionHeaderView(title: "Create Challenge")
                            AppTextField(placeholder: "Title", text: $viewModel.title, icon: "textformat")
                            AppTextField(placeholder: "Start word", text: $viewModel.startWord, icon: "play.fill")
                            AppTextField(placeholder: "End word", text: $viewModel.endWord, icon: "flag.fill")
                            WordChainBadge(start: viewModel.startWord, end: viewModel.endWord, size: .headline)
                                .frame(maxWidth: .infinity)
                            AnimatedButton(title: "Pass & Play", icon: "person.2.fill", color: Theme.accent, action: viewModel.startPassAndPlay)
                            AnimatedButton(title: "Share Challenge", icon: "square.and.arrow.up", color: Color(hex: "4ecdc4"), style: .outline, action: viewModel.createShareChallenge)
                        }
                    }

                    AppCard(accent: Color(hex: "7b68ee")) {
                        VStack(spacing: 12) {
                            SectionHeaderView(title: "Import Code")
                            AppTextField(placeholder: "Paste base64 challenge code", text: $viewModel.importCode, icon: "qrcode")
                            if let error = viewModel.errorMessage {
                                Text(error).font(.caption).foregroundColor(Theme.danger)
                            }
                            AnimatedButton(title: "Play Imported Challenge", icon: "play.fill", color: Color(hex: "7b68ee"), action: viewModel.importChallenge)
                        }
                    }
                }
                .padding(Theme.Spacing.md)
            }
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            ShareSheet(items: viewModel.shareItems)
        }
    }
}

struct FriendPassPlayView: View {
    @StateObject private var viewModel: FriendPassPlayViewModel
    @FocusState private var focused: Bool

    init(viewModel: FriendPassPlayViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(title: "Pass & Play", subtitle: viewModel.isGameOver ? "Game Over" : "\(viewModel.currentPlayer)'s turn", onBack: viewModel.goBack) {
            VStack(spacing: Theme.Spacing.md) {
                HStack(spacing: 12) {
                    playerBadge(name: viewModel.playerOneName, active: viewModel.isPlayerOneTurn && !viewModel.isGameOver)
                    Text("VS").font(.caption.bold()).foregroundColor(Theme.danger)
                    playerBadge(name: viewModel.playerTwoName, active: !viewModel.isPlayerOneTurn && !viewModel.isGameOver)
                }
                .padding(.horizontal, Theme.Spacing.md)

                ChainDisplayView(
                    startWord: viewModel.startWord, endWord: viewModel.endWord,
                    chain: viewModel.chain, isWin: viewModel.isGameOver, isGameOver: viewModel.isGameOver
                )

                if viewModel.isGameOver {
                    AppCard(accent: Theme.accent) {
                        Text("🎉 \(viewModel.winnerName) wins!")
                            .font(.title2.bold())
                            .foregroundColor(Theme.accent)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                } else {
                    AppCard {
                        HStack(spacing: 10) {
                            AppTextField(placeholder: "Enter word", text: $viewModel.currentInput, icon: "textformat")
                                .focused($focused)
                            Button(action: viewModel.submit) {
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
                }
                Spacer()
            }
            .padding(.vertical, Theme.Spacing.sm)
        }
        .onAppear { focused = true }
    }

    private func playerBadge(name: String, active: Bool) -> some View {
        VStack(spacing: 4) {
            Text(name)
                .font(.caption.weight(.semibold))
                .foregroundColor(active ? Theme.accent : Theme.secondaryText)
            Circle()
                .fill(active ? Theme.accent : Theme.card)
                .frame(width: 10, height: 10)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .surfaceStyle(cornerRadius: Theme.Radius.sm, accent: Theme.accent, elevation: .flat)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous)
                .stroke(active ? Theme.accent.opacity(0.5) : Color.clear, lineWidth: 1)
        )
    }
}
