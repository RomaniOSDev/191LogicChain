import Foundation

struct WordPair: Identifiable, Codable, Hashable {
    let id: UUID
    let startWord: String
    let endWord: String
    let category: Category
    let difficulty: Difficulty
    var solution: [String]?
    var isUsed: Bool
    var createdAt: Date
}
