import Foundation

struct GamePlayConfig: Hashable, Codable {
    var constraints: PuzzleConstraints?
    var optimalSolution: [String]?
    var maxSteps: Int?
    var requiredWord: String?
    var forbidRepeatedLetters: Bool = false
    var isMinimalChain: Bool = false
    var customChainId: UUID?
    var puzzleLevelId: UUID?
    var weeklyDayId: String?
    var friendChallengeTitle: String?

    static let standard = GamePlayConfig()
}

struct PuzzleConstraints: Hashable, Codable {
    var categoryOnly: Category?
    var forbidRepeatedLetters: Bool = false
    var requiredWord: String?
    var maxSteps: Int?

    var summary: String {
        var parts: [String] = []
        if let categoryOnly { parts.append("Category: \(categoryOnly.displayName)") }
        if forbidRepeatedLetters { parts.append("No repeated letters") }
        if let requiredWord { parts.append("Must use: \(requiredWord)") }
        if let maxSteps { parts.append("Max \(maxSteps) words") }
        return parts.isEmpty ? "No special rules" : parts.joined(separator: " · ")
    }
}
