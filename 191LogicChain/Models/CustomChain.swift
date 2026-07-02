import Foundation

struct CustomChain: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var startWord: String
    var endWord: String
    var category: Category?
    var difficulty: Difficulty
    var solution: [String]?
    var authorName: String
    var createdAt: Date
    var timesPlayed: Int
}

struct SharedChallengePayload: Codable {
    let version: Int
    let title: String
    let startWord: String
    let endWord: String
    let category: Category?
    let difficulty: Difficulty
    let timeLimit: Int
    let author: String
    let constraints: PuzzleConstraints?

    init(title: String, startWord: String, endWord: String, category: Category?,
         difficulty: Difficulty, timeLimit: Int, author: String, constraints: PuzzleConstraints? = nil) {
        self.version = 1
        self.title = title
        self.startWord = startWord
        self.endWord = endWord
        self.category = category
        self.difficulty = difficulty
        self.timeLimit = timeLimit
        self.author = author
        self.constraints = constraints
    }

    func encoded() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return data.base64EncodedString()
    }

    static func decode(from string: String) -> SharedChallengePayload? {
        guard let data = Data(base64Encoded: string),
              let payload = try? JSONDecoder().decode(SharedChallengePayload.self, from: data) else {
            return nil
        }
        return payload
    }

    var shareText: String {
        "Challenge: \(startWord) → \(endWord) in \(timeLimit)s\nBy \(author)\nCode: \(encoded() ?? "")"
    }
}
