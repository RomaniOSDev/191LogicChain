import Combine
import SwiftUI

@MainActor
class DailyChallengeViewModel: ObservableObject {
    @Published var challenge: DailyChallenge?
    @Published var history: [DailyChallenge] = []

    private let coordinator: AppCoordinator
    private let storageService: StorageServiceProtocol
    private let chainEngine: ChainEngine

    init(wordService: WordService,
         chainEngine: ChainEngine,
         storageService: StorageServiceProtocol,
         coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.storageService = storageService
        self.chainEngine = chainEngine
        loadChallenge()
    }

    func loadChallenge() {
        let challenges: [DailyChallenge] = storageService.load(forKey: StorageKeys.dailyChallenges)
        let today = DateFormatter.dateFormat("yyyy-MM-dd", from: Date())

        if let todayChallenge = challenges.first(where: { $0.date == today }) {
            challenge = todayChallenge
        } else {
            let pair = chainEngine.generateDailyChallenge()
            let newChallenge = DailyChallenge(
                id: UUID(),
                date: today,
                startWord: pair.startWord,
                endWord: pair.endWord,
                category: pair.category,
                difficulty: pair.difficulty,
                completed: false,
                chain: nil,
                score: nil
            )
            var all = challenges
            all.append(newChallenge)
            storageService.save(all, forKey: StorageKeys.dailyChallenges)
            challenge = newChallenge
        }

        history = challenges
            .filter { $0.completed }
            .sorted { $0.date > $1.date }
    }

    func startChallenge() {
        guard let challenge else { return }
        coordinator.navigateToGame(
            mode: .daily,
            startWord: challenge.startWord,
            endWord: challenge.endWord,
            category: challenge.category,
            difficulty: challenge.difficulty
        )
    }

    func goBack() {
        coordinator.pop()
    }
}
