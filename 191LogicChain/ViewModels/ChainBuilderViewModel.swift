import Combine
import SwiftUI

@MainActor
class ChainBuilderViewModel: ObservableObject {
    @Published var chains: [CustomChain] = []
    @Published var title = ""
    @Published var startWord = ""
    @Published var endWord = ""
    @Published var selectedCategory: Category?
    @Published var difficulty: Difficulty = .medium
    @Published var errorMessage: String?
    @Published var showShareSheet = false
    @Published var shareItems: [Any] = []

    private let coordinator: AppCoordinator
    private let builderService: ChainBuilderService

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.builderService = coordinator.chainBuilderService
        load()
    }

    func load() { chains = builderService.getChains() }

    func saveChain() {
        errorMessage = builderService.validatePair(start: startWord, end: endWord)
        guard errorMessage == nil else { return }

        let author = UserDefaults.standard.string(forKey: StorageKeys.playerName) ?? "Player"
        let chain = CustomChain(
            id: UUID(),
            title: title.isEmpty ? "\(startWord) → \(endWord)" : title,
            startWord: startWord,
            endWord: endWord,
            category: selectedCategory,
            difficulty: difficulty,
            solution: coordinator.chainEngine.findShortestChain(
                from: startWord, to: endWord, category: selectedCategory, maxDepth: 8
            ),
            authorName: author,
            createdAt: Date(),
            timesPlayed: 0
        )
        builderService.saveChain(chain)
        title = ""; startWord = ""; endWord = ""
        load()
    }

    func play(_ chain: CustomChain) {
        var config = GamePlayConfig()
        config.customChainId = chain.id
        config.optimalSolution = chain.solution
        coordinator.navigateToGame(
            mode: .customChain,
            startWord: chain.startWord,
            endWord: chain.endWord,
            category: chain.category,
            difficulty: chain.difficulty,
            config: config
        )
    }

    func share(_ chain: CustomChain) {
        let payload = SharedChallengePayload(
            title: chain.title, startWord: chain.startWord, endWord: chain.endWord,
            category: chain.category, difficulty: chain.difficulty,
            timeLimit: chain.difficulty.timeLimit, author: chain.authorName
        )
        var items: [Any] = [payload.shareText]
        if let image = ShareService.chainCardImage(title: chain.title, start: chain.startWord, end: chain.endWord, author: chain.authorName) {
            items.append(image)
        }
        if let code = payload.encoded(), let qr = ShareService.qrImage(from: code) {
            items.append(qr)
        }
        shareItems = items
        showShareSheet = true
    }

    func delete(_ chain: CustomChain) {
        builderService.deleteChain(id: chain.id)
        load()
    }

    func goBack() { coordinator.pop() }
}
