import SwiftUI

struct ChainBuilderView: View {
    @StateObject private var viewModel: ChainBuilderViewModel

    init(viewModel: ChainBuilderViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(title: "Chain Builder", subtitle: "Create custom challenges", onBack: viewModel.goBack) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.lg) {
                    AppCard {
                        VStack(spacing: 12) {
                            SectionHeaderView(title: "New Chain")
                            AppTextField(placeholder: "Title", text: $viewModel.title, icon: "textformat")
                            AppTextField(placeholder: "Start word", text: $viewModel.startWord, icon: "play.fill")
                            AppTextField(placeholder: "End word", text: $viewModel.endWord, icon: "flag.fill")
                            Picker("Difficulty", selection: $viewModel.difficulty) {
                                ForEach(Difficulty.allCases, id: \.self) { Text($0.displayName).tag($0) }
                            }
                            .pickerStyle(.segmented)
                            if let error = viewModel.errorMessage {
                                Text(error).font(.caption).foregroundColor(Theme.danger)
                            }
                            AnimatedButton(title: "Save Chain", icon: "square.and.arrow.down.fill", color: Theme.accent, action: viewModel.saveChain)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)

                    if viewModel.chains.isEmpty {
                        EmptyStateView(icon: "✏️", title: "No Custom Chains", message: "Create your first chain above and share it with friends.")
                    } else {
                        SectionHeaderView(title: "Your Chains", trailing: "\(viewModel.chains.count)")
                            .padding(.horizontal, Theme.Spacing.md)
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.chains) { chain in
                                CustomChainCell(
                                    chain: chain,
                                    onPlay: { viewModel.play(chain) },
                                    onShare: { viewModel.share(chain) },
                                    onDelete: { viewModel.delete(chain) }
                                )
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                    }
                }
                .padding(.vertical, Theme.Spacing.sm)
            }
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            ShareSheet(items: viewModel.shareItems)
        }
    }
}
