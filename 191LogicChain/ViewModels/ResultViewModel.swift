import Combine
import SwiftUI

@MainActor
class ResultViewModel: ObservableObject {
    @Published var session: ChainSession
    @Published var stats: Stats
    @Published var isNewRecord = false
    @Published var analysis: ChainAnalysis = .empty
    @Published var newAchievements: [AchievementID] = []

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator

    init(session: ChainSession,
         storageService: StorageServiceProtocol,
         chainAnalysisService: ChainAnalysisService,
         chainEngine: ChainEngine,
         coordinator: AppCoordinator) {
        self.session = session
        self.storageService = storageService
        self.coordinator = coordinator

        let loadedStats: Stats = storageService.loadObject(forKey: StorageKeys.stats) ?? Stats(
            totalGames: 0, totalWins: 0, bestChainLength: 0, totalWordsUsed: 0,
            favoriteCategory: nil, averageChainLength: 0, streaks: 0, maxStreaks: 0
        )
        self.stats = loadedStats
        self.isNewRecord = session.isWin && session.chain.count >= loadedStats.bestChainLength

        self.analysis = chainAnalysisService.analyze(
            chain: session.chain,
            endWord: session.endWord,
            category: session.playConfig?.constraints?.categoryOnly,
            optimalSolution: session.playConfig?.optimalSolution
        )

        self.newAchievements = AchievementService(storageService: storageService)
            .evaluate(session: session, stats: loadedStats, hintsUsed: session.hintsUsed)
    }

    var scoreEmoji: String {
        if session.isWin {
            if session.score >= 100 { return "🏆" }
            if session.score >= 70 { return "🌟" }
            if session.score >= 50 { return "💪" }
            return "✅"
        }
        return "📚"
    }

    var scoreMessage: String {
        if session.isWin {
            if session.score >= 100 { return "Brilliant! You're a chain master!" }
            if session.score >= 70 { return "Great job! Sharp thinking!" }
            if session.score >= 50 { return "Nice work! Try again for a higher score!" }
            return "Good effort! Keep practicing!"
        }
        return "Practice makes perfect! Try again!"
    }

    func playAgain() {
        coordinator.popToRoot()
        NotificationCenter.default.post(name: .playAgain, object: nil)
    }

    func goHome() { coordinator.popToRoot() }

    func goToLeaderboard() {
        coordinator.popToRoot()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.coordinator.navigateToLeaderboard()
        }
    }
}
