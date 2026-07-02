import Foundation

struct DailyChallenge: Identifiable, Codable, Hashable {
    let id: UUID
    let date: String
    let startWord: String
    let endWord: String
    let category: Category
    let difficulty: Difficulty
    var completed: Bool
    var chain: [String]?
    var score: Int?
}
