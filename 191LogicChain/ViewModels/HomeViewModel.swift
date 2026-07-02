import Combine
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var dailyChallenge: DailyChallenge?
    @Published var stats: Stats
    @Published var lastScore: Int = 0
    @Published var weeklyCampaign: WeeklyCampaign?
    @Published var unlockedAchievements: Int = 0

    let coordinator: AppCoordinator
    private let storageService: StorageServiceProtocol
    private let wordService: WordService
    private let chainEngine: ChainEngine
    private let skillTreeService: SkillTreeService

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.storageService = coordinator.storageService
        self.wordService = coordinator.wordService
        self.chainEngine = coordinator.chainEngine
        self.skillTreeService = coordinator.skillTreeService

        self.stats = storageService.loadObject(forKey: StorageKeys.stats) ?? Stats(
            totalGames: 0, totalWins: 0, bestChainLength: 0, totalWordsUsed: 0,
            favoriteCategory: nil, averageChainLength: 0, streaks: 0, maxStreaks: 0
        )

        loadDailyChallenge()
        loadLastScore()
        weeklyCampaign = coordinator.weeklyCampaignService.currentCampaign()
        unlockedAchievements = coordinator.achievementService.getRecords().filter(\.isUnlocked).count
    }

    func refresh() {
        stats = storageService.loadObject(forKey: StorageKeys.stats) ?? stats
        loadDailyChallenge()
        loadLastScore()
        weeklyCampaign = coordinator.weeklyCampaignService.currentCampaign()
        unlockedAchievements = coordinator.achievementService.getRecords().filter(\.isUnlocked).count
    }

    func isUnlocked(_ feature: FeatureUnlock) -> Bool {
        skillTreeService.isFeatureUnlocked(feature)
    }

    func loadDailyChallenge() {
        let challenges: [DailyChallenge] = storageService.load(forKey: StorageKeys.dailyChallenges)
        let today = DateFormatter.dateFormat("yyyy-MM-dd", from: Date())
        if let challenge = challenges.first(where: { $0.date == today }) {
            dailyChallenge = challenge
        } else {
            generateNewDailyChallenge()
        }
    }

    func generateNewDailyChallenge() {
        let pair = chainEngine.generateDailyChallenge()
        let today = DateFormatter.dateFormat("yyyy-MM-dd", from: Date())
        let challenge = DailyChallenge(
            id: UUID(), date: today, startWord: pair.startWord, endWord: pair.endWord,
            category: pair.category, difficulty: pair.difficulty,
            completed: false, chain: nil, score: nil
        )
        var challenges: [DailyChallenge] = storageService.load(forKey: StorageKeys.dailyChallenges)
        challenges.append(challenge)
        storageService.save(challenges, forKey: StorageKeys.dailyChallenges)
        dailyChallenge = challenge
    }

    func loadLastScore() {
        let sessions: [ChainSession] = storageService.load(forKey: StorageKeys.sessions)
        lastScore = sessions.last?.score ?? 0
    }

    func startGame(mode: GameMode, category: Category? = nil, config: GamePlayConfig = .standard) {
        let pair = wordService.getWordPairs().randomElement()
        let startWord = pair?.startWord ?? "Cat"
        let endWord = pair?.endWord ?? "Tiger"
        let difficulty = pair?.difficulty ?? .medium
        var gameConfig = config
        if gameConfig.optimalSolution == nil {
            gameConfig.optimalSolution = chainEngine.findShortestChain(
                from: startWord, to: endWord, category: category ?? pair?.category, maxDepth: 8
            )
        }
        coordinator.navigateToGame(
            mode: mode, startWord: startWord, endWord: endWord,
            category: category ?? pair?.category, difficulty: difficulty, config: gameConfig
        )
    }

    func startMinimalChain() {
        var config = GamePlayConfig()
        config.isMinimalChain = true
        startGame(mode: .minimalChain, config: config)
    }

    func startDailyChallenge() {
        guard let challenge = dailyChallenge else { return }
        coordinator.navigateToGame(
            mode: .daily, startWord: challenge.startWord, endWord: challenge.endWord,
            category: challenge.category, difficulty: challenge.difficulty
        )
    }

    func goToBattle() { coordinator.navigateToBattle() }
    func goToLeaderboard() { coordinator.navigateToLeaderboard() }
    func goToStatistics() { coordinator.navigateToStatistics() }
    func goToSettings() { coordinator.navigateToSettings() }
    func goToChainBuilder() { coordinator.navigateToChainBuilder() }
    func goToLogicPuzzles() { coordinator.navigateToLogicPuzzles() }
    func goToSkillTree() { coordinator.navigateToSkillTree() }
    func goToFriendChallenge() { coordinator.navigateToFriendChallenge() }
    func goToWeeklyCampaign() { coordinator.navigateToWeeklyCampaign() }
    func goToAchievements() { coordinator.navigateToAchievements() }
    func goToDictionary() { coordinator.navigateToDictionary() }
}
