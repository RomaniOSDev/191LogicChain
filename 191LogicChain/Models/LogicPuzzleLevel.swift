import Foundation

struct LogicPuzzleLevel: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let startWord: String
    let endWord: String
    let category: Category?
    let difficulty: Difficulty
    let constraints: PuzzleConstraints
    let optimalSolution: [String]?
    var isCompleted: Bool
    var bestScore: Int?

    var isUnlocked: Bool { true }
}
