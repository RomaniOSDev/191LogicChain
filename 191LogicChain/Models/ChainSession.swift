import Foundation

struct ChainSession: Identifiable, Codable, Hashable {
    let id: UUID
    var startWord: String
    var endWord: String
    var chain: [String]
    var isComplete: Bool
    var isWin: Bool
    var score: Int
    var timeUsed: Int
    var date: Date
    var mode: GameMode
    var hintsUsed: Int
    var playConfig: GamePlayConfig?
    var optimalChainLength: Int?

    init(id: UUID, startWord: String, endWord: String, chain: [String], isComplete: Bool,
         isWin: Bool, score: Int, timeUsed: Int, date: Date, mode: GameMode,
         hintsUsed: Int = 0, playConfig: GamePlayConfig? = nil, optimalChainLength: Int? = nil) {
        self.id = id
        self.startWord = startWord
        self.endWord = endWord
        self.chain = chain
        self.isComplete = isComplete
        self.isWin = isWin
        self.score = score
        self.timeUsed = timeUsed
        self.date = date
        self.mode = mode
        self.hintsUsed = hintsUsed
        self.playConfig = playConfig
        self.optimalChainLength = optimalChainLength
    }

    enum CodingKeys: String, CodingKey {
        case id, startWord, endWord, chain, isComplete, isWin, score, timeUsed, date, mode
        case hintsUsed, playConfig, optimalChainLength
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        startWord = try c.decode(String.self, forKey: .startWord)
        endWord = try c.decode(String.self, forKey: .endWord)
        chain = try c.decode([String].self, forKey: .chain)
        isComplete = try c.decode(Bool.self, forKey: .isComplete)
        isWin = try c.decode(Bool.self, forKey: .isWin)
        score = try c.decode(Int.self, forKey: .score)
        timeUsed = try c.decode(Int.self, forKey: .timeUsed)
        date = try c.decode(Date.self, forKey: .date)
        mode = try c.decode(GameMode.self, forKey: .mode)
        hintsUsed = try c.decodeIfPresent(Int.self, forKey: .hintsUsed) ?? 0
        playConfig = try c.decodeIfPresent(GamePlayConfig.self, forKey: .playConfig)
        optimalChainLength = try c.decodeIfPresent(Int.self, forKey: .optimalChainLength)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(startWord, forKey: .startWord)
        try c.encode(endWord, forKey: .endWord)
        try c.encode(chain, forKey: .chain)
        try c.encode(isComplete, forKey: .isComplete)
        try c.encode(isWin, forKey: .isWin)
        try c.encode(score, forKey: .score)
        try c.encode(timeUsed, forKey: .timeUsed)
        try c.encode(date, forKey: .date)
        try c.encode(mode, forKey: .mode)
        try c.encode(hintsUsed, forKey: .hintsUsed)
        try c.encodeIfPresent(playConfig, forKey: .playConfig)
        try c.encodeIfPresent(optimalChainLength, forKey: .optimalChainLength)
    }
}

enum GameMode: String, Codable, Hashable, CaseIterable {
    case solo
    case battle
    case daily
    case time
    case logicPuzzle
    case minimalChain
    case customChain
    case friendChallenge
    case weeklyCampaign

    var displayName: String {
        switch self {
        case .solo: return "Solo"
        case .battle: return "Battle"
        case .daily: return "Daily"
        case .time: return "Time Attack"
        case .logicPuzzle: return "Logic Puzzle"
        case .minimalChain: return "Minimal Chain"
        case .customChain: return "Custom Chain"
        case .friendChallenge: return "Friend Challenge"
        case .weeklyCampaign: return "Weekly Campaign"
        }
    }
}
