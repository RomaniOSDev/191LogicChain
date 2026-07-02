import Combine
import SwiftUI

@MainActor
class BattleViewModel: ObservableObject {
    @Published var chain: [String] = []
    @Published var currentInput = ""
    @Published var isPlayerTurn = true
    @Published var isGameOver = false
    @Published var isWin = false
    @Published var errorMessage: String?
    @Published var statusMessage = "Your turn — build the chain!"
    @Published var timeUsed = 0
    @Published var playerScore = 0
    @Published var aiScore = 0

    let startWord: String
    let endWord: String
    let category: Category?
    let timeLimit: Int
    let minWords: Int

    private let wordService: WordService
    private let chainEngine: ChainEngine
    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator
    private var timer: Timer?

    var currentWord: String {
        chain.last ?? startWord
    }

    init(wordService: WordService,
         chainEngine: ChainEngine,
         storageService: StorageServiceProtocol,
         coordinator: AppCoordinator) {
        self.wordService = wordService
        self.chainEngine = chainEngine
        self.storageService = storageService
        self.coordinator = coordinator

        let pair = wordService.getWordPairs().randomElement()
        self.startWord = pair?.startWord ?? "Cat"
        self.endWord = pair?.endWord ?? "Tiger"
        self.category = pair?.category
        let difficulty = pair?.difficulty ?? .medium
        self.timeLimit = difficulty.timeLimit
        self.minWords = difficulty.minWords

        self.chain = [startWord]
        startTimer()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self, !self.isGameOver else { return }
                self.timeUsed += 1
                if self.timeUsed >= self.timeLimit {
                    self.finishBattle(playerWon: false, reason: "Time is up!")
                }
            }
        }
    }

    func submitPlayerWord() {
        guard isPlayerTurn, !isGameOver else { return }
        let wordText = currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !wordText.isEmpty else { return }

        guard validateWord(wordText) else { return }

        chain.append(wordText)
        currentInput = ""
        playerScore += 10
        statusMessage = "AI is thinking..."

        if chainEngine.isWinConditionMet(chain: chain, endWord: endWord, minWords: minWords) {
            finishBattle(playerWon: true, reason: "You reached the target word!")
            return
        }

        isPlayerTurn = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.aiTurn()
        }
    }

    private func aiTurn() {
        guard !isGameOver else { return }

        if let aiWord = chainEngine.pickAIWord(
            currentWord: currentWord,
            usedWords: chain,
            endWord: endWord,
            category: category
        ) {
            chain.append(aiWord)
            aiScore += 10
            statusMessage = "AI played: \(aiWord). Your turn!"

            if chainEngine.isWinConditionMet(chain: chain, endWord: endWord, minWords: minWords) {
                finishBattle(playerWon: false, reason: "AI reached the target word!")
                return
            }
        } else {
            finishBattle(playerWon: true, reason: "AI has no valid moves!")
            return
        }

        isPlayerTurn = true
    }

    private func validateWord(_ wordText: String) -> Bool {
        guard chainEngine.getWord(from: wordText) != nil else {
            errorMessage = "Word not found in dictionary"
            return false
        }
        guard !chain.contains(where: { $0.lowercased() == wordText.lowercased() }) else {
            errorMessage = "This word was already used"
            return false
        }
        guard chainEngine.isValidTransition(from: currentWord, to: wordText) else {
            let lastChar = currentWord.last.map { String($0).lowercased() } ?? ""
            errorMessage = "Word must start with '\(lastChar)'"
            return false
        }
        errorMessage = nil
        return true
    }

    private func finishBattle(playerWon: Bool, reason: String) {
        guard !isGameOver else { return }
        timer?.invalidate()
        timer = nil
        isGameOver = true
        isWin = playerWon
        statusMessage = reason

        let score = playerWon
            ? chainEngine.calculateScore(chain: chain, timeUsed: timeUsed, timeLimit: timeLimit) + playerScore
            : aiScore

        let session = ChainSession(
            id: UUID(),
            startWord: startWord,
            endWord: endWord,
            chain: chain,
            isComplete: true,
            isWin: playerWon,
            score: playerWon ? score : 0,
            timeUsed: timeUsed,
            date: Date(),
            mode: .battle
        )

        storageService.append(session, forKey: StorageKeys.sessions)
        updateStats(win: playerWon, chainCount: chain.count)

        if playerWon {
            let playerName = UserDefaults.standard.string(forKey: StorageKeys.playerName) ?? "Player"
            let entry = LeaderboardEntry(
                id: UUID(),
                playerName: playerName,
                score: score,
                chainLength: chain.count,
                mode: .battle,
                date: Date()
            )
            storageService.append(entry, forKey: StorageKeys.leaderboard)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.coordinator.navigateToResult(session: session)
        }
    }

    private func updateStats(win: Bool, chainCount: Int) {
        var stats: Stats = storageService.loadObject(forKey: StorageKeys.stats) ?? Stats(
            totalGames: 0, totalWins: 0, bestChainLength: 0, totalWordsUsed: 0,
            favoriteCategory: nil, averageChainLength: 0, streaks: 0, maxStreaks: 0
        )
        stats.totalGames += 1
        if win {
            stats.totalWins += 1
            stats.streaks += 1
            stats.maxStreaks = max(stats.streaks, stats.maxStreaks)
        } else {
            stats.streaks = 0
        }
        stats.bestChainLength = max(stats.bestChainLength, chainCount)
        storageService.saveObject(stats, forKey: StorageKeys.stats)
    }

    func goBack() {
        timer?.invalidate()
        coordinator.pop()
    }

    deinit {
        timer?.invalidate()
    }
}
