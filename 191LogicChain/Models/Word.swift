import Foundation

struct Word: Identifiable, Codable, Hashable {
    let id: UUID
    let text: String
    let category: Category
    let difficulty: Difficulty
    let isCommon: Bool
    var synonyms: [String]
    var frequency: WordFrequency
    var letterDifficulty: Int
    var exampleUsage: String

    init(id: UUID, text: String, category: Category, difficulty: Difficulty, isCommon: Bool,
         synonyms: [String] = [], frequency: WordFrequency = .common,
         letterDifficulty: Int = 1, exampleUsage: String = "") {
        self.id = id
        self.text = text
        self.category = category
        self.difficulty = difficulty
        self.isCommon = isCommon
        self.synonyms = synonyms
        self.frequency = frequency
        self.letterDifficulty = letterDifficulty
        self.exampleUsage = exampleUsage
    }

    enum CodingKeys: String, CodingKey {
        case id, text, category, difficulty, isCommon, synonyms, frequency, letterDifficulty, exampleUsage
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        text = try c.decode(String.self, forKey: .text)
        category = try c.decode(Category.self, forKey: .category)
        difficulty = try c.decode(Difficulty.self, forKey: .difficulty)
        isCommon = try c.decode(Bool.self, forKey: .isCommon)
        synonyms = try c.decodeIfPresent([String].self, forKey: .synonyms) ?? []
        frequency = try c.decodeIfPresent(WordFrequency.self, forKey: .frequency) ?? .common
        letterDifficulty = try c.decodeIfPresent(Int.self, forKey: .letterDifficulty) ?? 1
        exampleUsage = try c.decodeIfPresent(String.self, forKey: .exampleUsage) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(text, forKey: .text)
        try c.encode(category, forKey: .category)
        try c.encode(difficulty, forKey: .difficulty)
        try c.encode(isCommon, forKey: .isCommon)
        try c.encode(synonyms, forKey: .synonyms)
        try c.encode(frequency, forKey: .frequency)
        try c.encode(letterDifficulty, forKey: .letterDifficulty)
        try c.encode(exampleUsage, forKey: .exampleUsage)
    }
}

enum Difficulty: String, CaseIterable, Codable, Hashable {
    case easy
    case medium
    case hard

    var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }

    var timeLimit: Int {
        switch self {
        case .easy: return 90
        case .medium: return 60
        case .hard: return 45
        }
    }

    var minWords: Int {
        switch self {
        case .easy: return 3
        case .medium: return 4
        case .hard: return 5
        }
    }
}
