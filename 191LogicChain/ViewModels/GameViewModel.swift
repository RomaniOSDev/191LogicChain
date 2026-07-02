import Combine
import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    @Published var chain: [String] = []
    @Published var currentInput = ""
    @Published var timeLeft: Int
    @Published var isGameOver = false
    @Published var timeUsed: Int = 0
    @Published var possibleWords: [Word] = []
    @Published var hintCounter = 0
    @Published var errorMessage: String?
    @Published var isWin = false
    @Published var constraintHint: String = ""

    let mode: GameMode
    let startWord: String
    let endWord: String
    let category: Category?
    let timeLimit: Int
    let minWords: Int
    let playConfig: GamePlayConfig
    let optimalChainLength: Int?

    private let wordService: WordService
    private let chainEngine: ChainEngine
    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator
    private let achievementService: AchievementService
    private let skillTreeService: SkillTreeService
    private let puzzleService: PuzzleService
    private let weeklyService: WeeklyCampaignService
    private let chainBuilderService: ChainBuilderService
    private let speechService: AccessibilitySpeechService
    private var timer: Timer?

    var canSubmit: Bool {
        !currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isGameOver
    }

    var chainLength: Int { chain.count }
    var currentWord: String { chain.last ?? startWord }

    var activeCategory: Category? {
        playConfig.constraints?.categoryOnly ?? category
    }

    init(mode: GameMode,
         startWord: String,
         endWord: String,
         category: Category?,
         difficulty: Difficulty,
         config: GamePlayConfig = .standard,
         wordService: WordService,
         chainEngine: ChainEngine,
         storageService: StorageServiceProtocol,
         coordinator: AppCoordinator) {
        self.mode = mode
        self.startWord = startWord
        self.endWord = endWord
        self.category = category
        self.playConfig = config
        self.wordService = wordService
        self.chainEngine = chainEngine
        self.storageService = storageService
        self.coordinator = coordinator
        self.achievementService = AchievementService(storageService: storageService)
        self.skillTreeService = SkillTreeService(storageService: storageService)
        self.puzzleService = PuzzleService(storageService: storageService)
        self.weeklyService = WeeklyCampaignService(storageService: storageService, wordService: wordService)
        self.chainBuilderService = ChainBuilderService(storageService: storageService, chainEngine: chainEngine)
        self.speechService = AccessibilitySpeechService()

        self.timeLimit = difficulty.timeLimit
        self.minWords = config.isMinimalChain ? 3 : difficulty.minWords
        self.timeLeft = difficulty.timeLimit

        let resolvedCategory = config.constraints?.categoryOnly ?? category
        let optimal = config.optimalSolution ?? chainEngine.findShortestChain(
            from: startWord, to: endWord, category: resolvedCategory, maxDepth: 8
        )
        self.optimalChainLength = optimal?.count

        self.chain = [startWord]
        self.possibleWords = chainEngine.getPossibleNextWords(
            currentWord: startWord, usedWords: [startWord], category: resolvedCategory
        )
        self.constraintHint = config.constraints?.summary ?? ""

        startTimer()
        speakCurrentWord()
    }

    private func speakCurrentWord() {
        let settings = AccessibilitySettingsStore(storageService: storageService).load()
        speechService.speakCurrentLetter(currentWord, enabled: settings.speechEnabled)
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                if self.timeLeft > 0 {
                    self.timeLeft -= 1
                    self.timeUsed += 1
                } else {
                    self.endGame(win: false)
                }
            }
        }
    }

    func submitWord() {
        guard canSubmit else { return }
        let wordText = currentInput.trimmingCharacters(in: .whitespacesAndNewlines)

        if let error = chainEngine.validateWordSubmission(
            wordText: wordText, currentWord: currentWord, chain: chain,
            endWord: endWord, category: activeCategory, config: playConfig
        ) {
            errorMessage = error
            return
        }

        chain.append(wordText)
        currentInput = ""
        errorMessage = nil

        possibleWords = chainEngine.getPossibleNextWords(
            currentWord: wordText, usedWords: chain, category: activeCategory
        )
        speakCurrentWord()

        if chainEngine.isConstraintWin(chain: chain, endWord: endWord, minWords: minWords, config: playConfig) {
            endGame(win: true)
        } else if let maxSteps = playConfig.maxSteps ?? playConfig.constraints?.maxSteps,
                  chain.count >= maxSteps,
                  chain.last?.lowercased() != endWord.lowercased() {
            endGame(win: false)
        }
    }

    func useHint() {
        guard hintCounter < 3 else { return }
        hintCounter += 1

        if let firstPossible = possibleWords.first {
            errorMessage = "Hint: \(chainEngine.enrichedHint(for: firstPossible))"
        } else {
            errorMessage = "No hints available right now"
        }
    }

    func endGame(win: Bool) {
        guard !isGameOver else { return }
        timer?.invalidate()
        timer = nil
        isGameOver = true
        isWin = win

        let score = chainEngine.calculateScore(
            chain: chain, timeUsed: timeUsed, timeLimit: timeLimit,
            isMinimal: playConfig.isMinimalChain || mode == .minimalChain,
            optimalLength: optimalChainLength
        )

        let session = ChainSession(
            id: UUID(),
            startWord: startWord,
            endWord: endWord,
            chain: chain,
            isComplete: true,
            isWin: win,
            score: win ? score : 0,
            timeUsed: timeUsed,
            date: Date(),
            mode: mode,
            hintsUsed: hintCounter,
            playConfig: playConfig,
            optimalChainLength: optimalChainLength
        )

        storageService.append(session, forKey: StorageKeys.sessions)
        updateDailyChallengeIfNeeded(chain: chain, score: session.score)
        updateWeeklyIfNeeded(score: session.score, win: win)
        updatePuzzleIfNeeded(score: session.score, win: win)
        updateCustomChainIfNeeded()
        updateStats(win: win, chainCount: chain.count)
        saveLeaderboardEntry(session: session)
        skillTreeService.awardXP(for: session, hintsUsed: hintCounter)
        let stats: Stats = storageService.loadObject(forKey: StorageKeys.stats) ?? Stats(
            totalGames: 0, totalWins: 0, bestChainLength: 0, totalWordsUsed: 0,
            favoriteCategory: nil, averageChainLength: 0, streaks: 0, maxStreaks: 0
        )
        _ = achievementService.evaluate(session: session, stats: stats, hintsUsed: hintCounter)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.coordinator.navigateToResult(session: session)
        }
    }

    private func updateWeeklyIfNeeded(score: Int, win: Bool) {
        guard win, mode == .weeklyCampaign, let dayId = playConfig.weeklyDayId else { return }
        weeklyService.markDayCompleted(dayId: dayId, score: score)
    }

    private func updatePuzzleIfNeeded(score: Int, win: Bool) {
        guard win, mode == .logicPuzzle, let id = playConfig.puzzleLevelId else { return }
        puzzleService.markCompleted(id: id, score: score)
    }

    private func updateCustomChainIfNeeded() {
        guard let id = playConfig.customChainId else { return }
        chainBuilderService.incrementPlayCount(id: id)
    }

    private func updateDailyChallengeIfNeeded(chain: [String], score: Int) {
        guard mode == .daily else { return }
        var challenges: [DailyChallenge] = storageService.load(forKey: StorageKeys.dailyChallenges)
        let today = DateFormatter.dateFormat("yyyy-MM-dd", from: Date())
        if let index = challenges.firstIndex(where: { $0.date == today }) {
            var updated = challenges[index]
            updated.completed = true
            updated.chain = chain
            updated.score = score
            challenges[index] = updated
            storageService.save(challenges, forKey: StorageKeys.dailyChallenges)
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
        let previousTotal = stats.averageChainLength * Double(max(stats.totalGames - 1, 0))
        stats.averageChainLength = (previousTotal + Double(chainCount)) / Double(stats.totalGames)
        stats.totalWordsUsed += max(chainCount - 1, 0)
        storageService.saveObject(stats, forKey: StorageKeys.stats)
    }

    private func saveLeaderboardEntry(session: ChainSession) {
        guard session.isWin else { return }
        let playerName = UserDefaults.standard.string(forKey: StorageKeys.playerName) ?? "Player"
        let entry = LeaderboardEntry(
            id: UUID(), playerName: playerName, score: session.score,
            chainLength: session.chain.count, mode: session.mode, date: session.date
        )
        storageService.append(entry, forKey: StorageKeys.leaderboard)
    }

    func goBack() {
        timer?.invalidate()
        timer = nil
        coordinator.pop()
    }

    deinit { timer?.invalidate() }
}
