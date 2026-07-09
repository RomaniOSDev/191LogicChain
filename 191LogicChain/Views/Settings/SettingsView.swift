import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(title: "Settings", subtitle: "Preferences & data", onBack: viewModel.goBack) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.md) {
                    AppCard {
                        VStack(spacing: 12) {
                            SectionHeaderView(title: "Profile")
                            AppTextField(placeholder: "Player Name", text: $viewModel.playerName, icon: "person.fill")
                                .onChange(of: viewModel.playerName) { _, _ in viewModel.savePlayerName() }
                        }
                    }

                    AppCard {
                        VStack(spacing: 12) {
                            SectionHeaderView(title: "Gameplay")
                            Picker("Default Difficulty", selection: $viewModel.defaultDifficulty) {
                                ForEach(Difficulty.allCases, id: \.self) { Text($0.displayName).tag($0) }
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: viewModel.defaultDifficulty) { _, _ in viewModel.saveDifficulty() }

                            VStack(spacing: 8) {
                                difficultyRow("Easy", time: Difficulty.easy.timeLimit)
                                difficultyRow("Medium", time: Difficulty.medium.timeLimit)
                                difficultyRow("Hard", time: Difficulty.hard.timeLimit)
                            }
                        }
                    }

                    AppCard(accent: Theme.danger) {
                        VStack(spacing: 12) {
                            SectionHeaderView(title: "Data")
                            AnimatedButton(title: "Reset All Data", icon: "trash.fill", color: Theme.danger, style: .outline) {
                                viewModel.showResetAlert = true
                            }
                        }
                    }

                    AppCard(accent: Color(hex: "ffa500")) {
                        VStack(spacing: 0) {
                            SectionHeaderView(title: "Legal")
                                .padding(.bottom, 12)
                            legalRow("Rate Us", icon: "star.fill", color: Color(hex: "ffa500"), action: viewModel.rateApp)
                            settingsDivider
                            legalRow("Privacy", icon: "hand.raised.fill", color: Theme.accent) {
                                viewModel.openLink(.privacyPolicy)
                            }
                            settingsDivider
                            legalRow("Terms", icon: "doc.text.fill", color: Theme.accent) {
                                viewModel.openLink(.termsOfUse)
                            }
                        }
                    }

                    AppCard {
                        HStack {
                            Text("Version")
                                .foregroundColor(Theme.primaryText)
                            Spacer()
                            Text("2.0.0")
                                .foregroundColor(Theme.secondaryText)
                        }
                    }
                }
                .adaptiveContentWidth()
                .adaptiveHorizontalPadding()
                .padding(.vertical, Theme.Spacing.sm)
            }
        }
        .alert("Reset All Data?", isPresented: $viewModel.showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) { viewModel.resetAllData() }
        } message: {
            Text("This will delete all games, stats, and progress. This action cannot be undone.")
        }
    }

    private var settingsDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.06))
            .frame(height: 1)
            .padding(.vertical, 4)
    }

    private func legalRow(_ title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(color)
                    .frame(width: 24)
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(Theme.primaryText)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(Theme.secondaryText)
            }
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
    }

    private func difficultyRow(_ label: String, time: Int) -> some View {
        HStack {
            Text(label).foregroundColor(Theme.secondaryText)
            Spacer()
            TagBadge(text: "\(time)s", color: Theme.secondaryText)
        }
        .font(.caption)
    }
}
