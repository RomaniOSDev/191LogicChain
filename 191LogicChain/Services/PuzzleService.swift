import Foundation

class PuzzleService {
    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }

    func getLevels() -> [LogicPuzzleLevel] {
        var levels: [LogicPuzzleLevel] = storageService.load(forKey: StorageKeys.logicPuzzles)
        if levels.isEmpty {
            levels = defaultLevels()
            storageService.save(levels, forKey: StorageKeys.logicPuzzles)
        }
        return levels
    }

    func markCompleted(id: UUID, score: Int) {
        var levels = getLevels()
        if let index = levels.firstIndex(where: { $0.id == id }) {
            levels[index].isCompleted = true
            levels[index].bestScore = max(levels[index].bestScore ?? 0, score)
            storageService.save(levels, forKey: StorageKeys.logicPuzzles)
        }
    }

    func level(by id: UUID) -> LogicPuzzleLevel? {
        getLevels().first { $0.id == id }
    }

    private func defaultLevels() -> [LogicPuzzleLevel] {
        [
            LogicPuzzleLevel(
                id: UUID(), title: "Science Lab", description: "Science words only",
                startWord: "Atom", endWord: "Cell", category: .science, difficulty: .hard,
                constraints: PuzzleConstraints(categoryOnly: .science), optimalSolution: nil,
                isCompleted: false, bestScore: nil
            ),
            LogicPuzzleLevel(
                id: UUID(), title: "No Repeats", description: "No letter may repeat in a word",
                startWord: "Cat", endWord: "Egg", category: nil, difficulty: .medium,
                constraints: PuzzleConstraints(forbidRepeatedLetters: true), optimalSolution: nil,
                isCompleted: false, bestScore: nil
            ),
            LogicPuzzleLevel(
                id: UUID(), title: "Must Include Tea", description: "Chain must use the word Tea",
                startWord: "Cat", endWord: "Egg", category: nil, difficulty: .medium,
                constraints: PuzzleConstraints(requiredWord: "Tea"), optimalSolution: nil,
                isCompleted: false, bestScore: nil
            ),
            LogicPuzzleLevel(
                id: UUID(), title: "Five Steps Max", description: "Reach the goal in at most 5 words",
                startWord: "Dog", endWord: "Garden", category: nil, difficulty: .hard,
                constraints: PuzzleConstraints(maxSteps: 5), optimalSolution: nil,
                isCompleted: false, bestScore: nil
            ),
            LogicPuzzleLevel(
                id: UUID(), title: "Nature Trail", description: "Nature category only",
                startWord: "Forest", endWord: "River", category: .nature, difficulty: .easy,
                constraints: PuzzleConstraints(categoryOnly: .nature), optimalSolution: nil,
                isCompleted: false, bestScore: nil
            ),
            LogicPuzzleLevel(
                id: UUID(), title: "Tech Sprint", description: "Technology + max 6 words",
                startWord: "Phone", endWord: "Engine", category: .technology, difficulty: .hard,
                constraints: PuzzleConstraints(categoryOnly: .technology, maxSteps: 6),
                optimalSolution: nil, isCompleted: false, bestScore: nil
            )
        ]
    }
}
