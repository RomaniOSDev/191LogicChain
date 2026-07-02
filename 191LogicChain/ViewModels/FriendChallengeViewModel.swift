import Combine
import SwiftUI

@MainActor
class FriendChallengeViewModel: ObservableObject {
    @Published var title = "Friend Challenge"
    @Published var startWord = "Cat"
    @Published var endWord = "Tiger"
    @Published var difficulty: Difficulty = .medium
    @Published var importCode = ""
    @Published var errorMessage: String?
    @Published var showShareSheet = false
    @Published var shareItems: [Any] = []

    private let coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func startPassAndPlay() {
        coordinator.navigateToFriendPassPlay(
            start: startWord, end: endWord, category: nil, difficulty: difficulty
        )
    }

    func createShareChallenge() {
        let author = UserDefaults.standard.string(forKey: StorageKeys.playerName) ?? "Player"
        let payload = SharedChallengePayload(
            title: title, startWord: startWord, endWord: endWord,
            category: nil, difficulty: difficulty,
            timeLimit: difficulty.timeLimit, author: author
        )
        var items: [Any] = [payload.shareText]
        if let img = ShareService.chainCardImage(title: title, start: startWord, end: endWord, author: author) {
            items.append(img)
        }
        if let code = payload.encoded(), let qr = ShareService.qrImage(from: code) {
            items.append(qr)
        }
        shareItems = items
        showShareSheet = true
    }

    func importChallenge() {
        guard let payload = SharedChallengePayload.decode(from: importCode.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            errorMessage = "Invalid challenge code"
            return
        }
        errorMessage = nil
        var config = GamePlayConfig()
        config.friendChallengeTitle = payload.title
        config.constraints = payload.constraints
        coordinator.navigateToGame(
            mode: .friendChallenge,
            startWord: payload.startWord,
            endWord: payload.endWord,
            category: payload.category,
            difficulty: payload.difficulty,
            config: config
        )
    }

    func goBack() { coordinator.pop() }
}

@MainActor
class FriendPassPlayViewModel: ObservableObject {
    @Published var chain: [String] = []
    @Published var currentInput = ""
    @Published var playerOneName = "Player 1"
    @Published var playerTwoName = "Player 2"
    @Published var isPlayerOneTurn = true
    @Published var isGameOver = false
    @Published var winnerName = ""
    @Published var errorMessage: String?

    let startWord: String
    let endWord: String
    let category: Category?
    let difficulty: Difficulty

    private let chainEngine: ChainEngine
    private let coordinator: AppCoordinator

    var currentPlayer: String { isPlayerOneTurn ? playerOneName : playerTwoName }
    var currentWord: String { chain.last ?? startWord }

    init(startWord: String, endWord: String, category: Category?, difficulty: Difficulty,
         chainEngine: ChainEngine, storageService: StorageServiceProtocol, coordinator: AppCoordinator) {
        self.startWord = startWord
        self.endWord = endWord
        self.category = category
        self.difficulty = difficulty
        self.chainEngine = chainEngine
        self.coordinator = coordinator
        self.chain = [startWord]
    }

    func submit() {
        guard !isGameOver else { return }
        let word = currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !word.isEmpty else { return }

        guard chainEngine.getWord(from: word) != nil else {
            errorMessage = "Word not in dictionary"; return
        }
        guard !chain.contains(where: { $0.lowercased() == word.lowercased() }) else {
            errorMessage = "Word already used"; return
        }
        guard chainEngine.isValidTransition(from: currentWord, to: word) else {
            errorMessage = "Invalid letter link"; return
        }

        chain.append(word)
        currentInput = ""
        errorMessage = nil

        if chainEngine.isWinConditionMet(chain: chain, endWord: endWord, minWords: difficulty.minWords) {
            isGameOver = true
            winnerName = currentPlayer
            return
        }

        isPlayerOneTurn.toggle()
    }

    func goBack() { coordinator.pop() }
}
