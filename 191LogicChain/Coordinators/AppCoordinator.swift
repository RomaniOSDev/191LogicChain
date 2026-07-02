import Combine
import SwiftUI

enum AppRoute: Hashable {
    case game(mode: GameMode, startWord: String, endWord: String, category: Category?, difficulty: Difficulty, config: GamePlayConfig)
    case battle
    case dailyChallenge
    case result(ChainSession)
    case leaderboard
    case statistics
    case settings
    case chainBuilder
    case logicPuzzles
    case skillTree
    case friendChallenge
    case weeklyCampaign
    case achievements
    case dictionary
    case friendPassPlay(startWord: String, endWord: String, category: Category?, difficulty: Difficulty)
}

@MainActor
class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    let storageService: StorageServiceProtocol
    let wordService: WordService
    let chainEngine: ChainEngine
    let chainAnalysisService: ChainAnalysisService
    let achievementService: AchievementService
    let skillTreeService: SkillTreeService
    let chainBuilderService: ChainBuilderService
    let puzzleService: PuzzleService
    let weeklyCampaignService: WeeklyCampaignService
    let accessibilityStore: AccessibilitySettingsStore

    init() {
        self.storageService = UserDefaultsStorageService()
        self.wordService = WordService(storageService: storageService)
        self.chainEngine = ChainEngine(wordService: wordService)
        self.chainAnalysisService = ChainAnalysisService(chainEngine: chainEngine)
        self.achievementService = AchievementService(storageService: storageService)
        self.skillTreeService = SkillTreeService(storageService: storageService)
        self.chainBuilderService = ChainBuilderService(storageService: storageService, chainEngine: chainEngine)
        self.puzzleService = PuzzleService(storageService: storageService)
        self.weeklyCampaignService = WeeklyCampaignService(storageService: storageService, wordService: wordService)
        self.accessibilityStore = AccessibilitySettingsStore(storageService: storageService)
    }

    func start() -> some View {
        HomeView(viewModel: HomeViewModel(coordinator: self))
    }

    func navigateToGame(
        mode: GameMode,
        startWord: String,
        endWord: String,
        category: Category? = nil,
        difficulty: Difficulty = .medium,
        config: GamePlayConfig = .standard
    ) {
        path.append(AppRoute.game(
            mode: mode, startWord: startWord, endWord: endWord,
            category: category, difficulty: difficulty, config: config
        ))
    }

    func navigateToBattle() { path.append(AppRoute.battle) }
    func navigateToDailyChallenge() { path.append(AppRoute.dailyChallenge) }
    func navigateToResult(session: ChainSession) { path.append(AppRoute.result(session)) }
    func navigateToLeaderboard() { path.append(AppRoute.leaderboard) }
    func navigateToStatistics() { path.append(AppRoute.statistics) }
    func navigateToSettings() { path.append(AppRoute.settings) }
    func navigateToChainBuilder() { path.append(AppRoute.chainBuilder) }
    func navigateToLogicPuzzles() { path.append(AppRoute.logicPuzzles) }
    func navigateToSkillTree() { path.append(AppRoute.skillTree) }
    func navigateToFriendChallenge() { path.append(AppRoute.friendChallenge) }
    func navigateToWeeklyCampaign() { path.append(AppRoute.weeklyCampaign) }
    func navigateToAchievements() { path.append(AppRoute.achievements) }
    func navigateToDictionary() { path.append(AppRoute.dictionary) }

    func navigateToFriendPassPlay(start: String, end: String, category: Category?, difficulty: Difficulty) {
        path.append(AppRoute.friendPassPlay(startWord: start, endWord: end, category: category, difficulty: difficulty))
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() { path = NavigationPath() }

    @ViewBuilder
    func destination(for route: AppRoute) -> some View {
        switch route {
        case let .game(mode, startWord, endWord, category, difficulty, config):
            GameView(viewModel: GameViewModel(
                mode: mode, startWord: startWord, endWord: endWord,
                category: category, difficulty: difficulty, config: config,
                wordService: wordService, chainEngine: chainEngine,
                storageService: storageService, coordinator: self
            ))
        case .battle:
            BattleView(viewModel: BattleViewModel(
                wordService: wordService, chainEngine: chainEngine,
                storageService: storageService, coordinator: self
            ))
        case .dailyChallenge:
            DailyChallengeView(viewModel: DailyChallengeViewModel(
                wordService: wordService, chainEngine: chainEngine,
                storageService: storageService, coordinator: self
            ))
        case let .result(session):
            ResultView(viewModel: ResultViewModel(
                session: session, storageService: storageService,
                chainAnalysisService: chainAnalysisService,
                chainEngine: chainEngine, coordinator: self
            ))
        case .leaderboard:
            LeaderboardView(viewModel: LeaderboardViewModel(storageService: storageService, coordinator: self))
        case .statistics:
            StatisticsView(viewModel: StatisticsViewModel(storageService: storageService, coordinator: self))
        case .settings:
            SettingsView(viewModel: SettingsViewModel(storageService: storageService, coordinator: self, accessibilityStore: accessibilityStore))
        case .chainBuilder:
            ChainBuilderView(viewModel: ChainBuilderViewModel(coordinator: self))
        case .logicPuzzles:
            LogicPuzzleListView(viewModel: LogicPuzzleViewModel(coordinator: self))
        case .skillTree:
            SkillTreeView(viewModel: SkillTreeViewModel(coordinator: self))
        case .friendChallenge:
            FriendChallengeView(viewModel: FriendChallengeViewModel(coordinator: self))
        case .weeklyCampaign:
            WeeklyCampaignView(viewModel: WeeklyCampaignViewModel(coordinator: self))
        case .achievements:
            AchievementsView(viewModel: AchievementsViewModel(coordinator: self))
        case .dictionary:
            DictionaryView(viewModel: DictionaryViewModel(coordinator: self))
        case let .friendPassPlay(start, end, category, difficulty):
            FriendPassPlayView(viewModel: FriendPassPlayViewModel(
                startWord: start, endWord: end, category: category, difficulty: difficulty,
                chainEngine: chainEngine, storageService: storageService, coordinator: self
            ))
        }
    }
}
