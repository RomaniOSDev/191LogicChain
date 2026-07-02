import Foundation

class ChainEngine {
    private let wordService: WordService

    init(wordService: WordService = WordService()) {
        self.wordService = wordService
    }

    func isValidTransition(from: String, to: String) -> Bool {
        guard let lastChar = from.last?.lowercased(),
              let firstChar = to.first?.lowercased() else {
            return false
        }
        return lastChar == firstChar
    }

    func hasRepeatedLetters(_ word: String) -> Bool {
        let letters = word.lowercased().filter { $0.isLetter }
        return Set(letters).count != letters.count
    }

    func getPossibleNextWords(currentWord: String, usedWords: [String], category: Category? = nil) -> [Word] {
        guard let lastChar = currentWord.last?.lowercased() else {
            return []
        }

        let allWords = wordService.getWords(for: category)
        let usedTexts = Set(usedWords.map { $0.lowercased() })

        return allWords.filter { word in
            guard let firstChar = word.text.first?.lowercased() else { return false }
            return firstChar == lastChar &&
                !usedTexts.contains(word.text.lowercased()) &&
                word.text.lowercased() != currentWord.lowercased()
        }
    }

    func isWinConditionMet(chain: [String], endWord: String, minWords: Int) -> Bool {
        guard chain.count >= minWords,
              let lastWord = chain.last else {
            return false
        }
        return lastWord.lowercased() == endWord.lowercased()
    }

    func validateWordSubmission(
        wordText: String,
        currentWord: String,
        chain: [String],
        endWord: String,
        category: Category?,
        config: GamePlayConfig
    ) -> String? {
        guard getWord(from: wordText) != nil else { return "Word not found in dictionary" }
        guard !chain.contains(where: { $0.lowercased() == wordText.lowercased() }) else {
            return "This word was already used"
        }
        guard isValidTransition(from: currentWord, to: wordText) else {
            let lastChar = currentWord.last.map { String($0).lowercased() } ?? ""
            return "Word must start with '\(lastChar)'"
        }
        if let cat = config.constraints?.categoryOnly ?? category,
           getWord(from: wordText)?.category != cat {
            return "Word must be from \(cat.displayName) category"
        }
        if config.forbidRepeatedLetters || config.constraints?.forbidRepeatedLetters == true,
           hasRepeatedLetters(wordText) {
            return "Word cannot contain repeated letters"
        }
        if let maxSteps = config.maxSteps ?? config.constraints?.maxSteps {
            if chain.count + 1 > maxSteps {
                return "Maximum \(maxSteps) words allowed"
            }
        }
        return nil
    }

    func isConstraintWin(chain: [String], endWord: String, minWords: Int, config: GamePlayConfig) -> Bool {
        guard isWinConditionMet(chain: chain, endWord: endWord, minWords: minWords) else { return false }
        if let required = config.requiredWord ?? config.constraints?.requiredWord {
            guard chain.contains(where: { $0.lowercased() == required.lowercased() }) else { return false }
        }
        return true
    }

    func calculateScore(chain: [String], timeUsed: Int, timeLimit: Int, isMinimal: Bool = false, optimalLength: Int? = nil) -> Int {
        var score = chain.count * 10

        if let lastWord = chain.last {
            let rareLetters = ["q", "x", "z", "j", "k", "v", "w"]
            for char in lastWord.lowercased() where rareLetters.contains(String(char)) {
                score += 2
            }
        }

        score += max(0, (timeLimit - timeUsed) / 2)

        if isMinimal, let optimalLength, chain.count == optimalLength {
            score += 50
        } else if isMinimal, let optimalLength {
            score += max(0, 30 - (chain.count - optimalLength) * 10)
        }

        return score
    }

    func findShortestChain(from start: String, to end: String, category: Category?, maxDepth: Int = 8) -> [String]? {
        bfs(start: start, end: end, category: category, maxDepth: maxDepth).first
    }

    func findAlternativePaths(from start: String, to end: String, category: Category?, limit: Int, maxDepth: Int) -> [[String]] {
        Array(bfs(start: start, end: end, category: category, maxDepth: maxDepth).prefix(limit))
    }

    private func bfs(start: String, end: String, category: Category?, maxDepth: Int) -> [[String]] {
        guard start.lowercased() != end.lowercased() else { return [[start]] }
        var queue: [[String]] = [[start]]
        var results: [[String]] = []
        var visitedPaths = Set<String>()

        while !queue.isEmpty {
            let path = queue.removeFirst()
            guard path.count <= maxDepth else { continue }
            guard let last = path.last else { continue }

            if last.lowercased() == end.lowercased(), path.count >= Difficulty.easy.minWords {
                results.append(path)
                if results.count >= 5 { break }
                continue
            }

            let nextWords = getPossibleNextWords(currentWord: last, usedWords: path, category: category)
            for word in nextWords {
                var newPath = path
                newPath.append(word.text)
                let key = newPath.map { $0.lowercased() }.joined(separator: "|")
                guard !visitedPaths.contains(key) else { continue }
                visitedPaths.insert(key)
                queue.append(newPath)
            }
        }

        return results.sorted { $0.count < $1.count }
    }

    func generateDailyChallenge() -> WordPair {
        let words = wordService.getWords()
        let pairs = wordService.getWordPairs()

        if let randomPair = pairs.filter({ !$0.isUsed }).randomElement() {
            return randomPair
        }

        let startWord = words.randomElement()!
        let endWord = words.filter { $0.text.lowercased() != startWord.text.lowercased() }.randomElement()!

        return WordPair(
            id: UUID(),
            startWord: startWord.text,
            endWord: endWord.text,
            category: startWord.category,
            difficulty: .medium,
            solution: nil,
            isUsed: false,
            createdAt: Date()
        )
    }

    func getWord(from text: String) -> Word? {
        wordService.getWords().first { $0.text.lowercased() == text.lowercased() }
    }

    func pickAIWord(currentWord: String, usedWords: [String], endWord: String, category: Category?) -> String? {
        let possible = getPossibleNextWords(currentWord: currentWord, usedWords: usedWords, category: category)
        guard !possible.isEmpty else { return nil }

        let endMatch = possible.first { $0.text.lowercased() == endWord.lowercased() }
        if let endMatch, usedWords.count >= 2 {
            return endMatch.text
        }

        return possible.randomElement()?.text
    }

    func enrichedHint(for word: Word) -> String {
        var parts: [String] = []
        if let first = word.text.first { parts.append("starts with '\(first)'") }
        if let last = word.text.last { parts.append("ends with '\(last)'") }
        if !word.synonyms.isEmpty { parts.append("like \(word.synonyms.prefix(2).joined(separator: ", "))") }
        if !word.exampleUsage.isEmpty { parts.append(word.exampleUsage) }
        return parts.joined(separator: " · ")
    }
}
