import Foundation

enum SkillType: String, Codable, CaseIterable, Hashable {
    case speed
    case vocabulary
    case patternRecognition
    case rareLetters

    var displayName: String {
        switch self {
        case .speed: return "Speed"
        case .vocabulary: return "Vocabulary"
        case .patternRecognition: return "Pattern Recognition"
        case .rareLetters: return "Rare Letters"
        }
    }

    var icon: String {
        switch self {
        case .speed: return "⚡"
        case .vocabulary: return "📖"
        case .patternRecognition: return "🧠"
        case .rareLetters: return "🔤"
        }
    }

    var unlockDescription: String {
        switch self {
        case .speed: return "Faster completions boost XP"
        case .vocabulary: return "Use diverse words to level up"
        case .patternRecognition: return "Solve puzzles and find short paths"
        case .rareLetters: return "Chains ending in rare letters"
        }
    }
}

struct SkillProgress: Codable, Hashable {
    var speedXP: Int
    var vocabularyXP: Int
    var patternXP: Int
    var rareLettersXP: Int

    func xp(for skill: SkillType) -> Int {
        switch skill {
        case .speed: return speedXP
        case .vocabulary: return vocabularyXP
        case .patternRecognition: return patternXP
        case .rareLetters: return rareLettersXP
        }
    }

    mutating func addXP(_ amount: Int, for skill: SkillType) {
        switch skill {
        case .speed: speedXP += amount
        case .vocabulary: vocabularyXP += amount
        case .patternRecognition: patternXP += amount
        case .rareLetters: rareLettersXP += amount
        }
    }

    func level(for skill: SkillType) -> Int {
        min(10, xp(for: skill) / 100 + 1)
    }

    func progressToNextLevel(for skill: SkillType) -> Double {
        let currentXP = xp(for: skill) % 100
        return Double(currentXP) / 100.0
    }

    static let empty = SkillProgress(speedXP: 0, vocabularyXP: 0, patternXP: 0, rareLettersXP: 0)
}

enum FeatureUnlock: String, CaseIterable, Hashable {
    case chainBuilder
    case logicPuzzles
    case minimalChain
    case friendChallenge
    case weeklyCampaign
    case achievements
    case dictionary

    var requiredLevel: Int {
        switch self {
        case .chainBuilder: return 1
        case .logicPuzzles: return 2
        case .minimalChain: return 3
        case .friendChallenge: return 3
        case .weeklyCampaign: return 2
        case .achievements: return 1
        case .dictionary: return 2
        }
    }

    var displayName: String {
        switch self {
        case .chainBuilder: return "Chain Builder"
        case .logicPuzzles: return "Logic Puzzles"
        case .minimalChain: return "Minimal Chain"
        case .friendChallenge: return "Friend Challenge"
        case .weeklyCampaign: return "Weekly Campaign"
        case .achievements: return "Achievements"
        case .dictionary: return "Word Dictionary"
        }
    }

    func isUnlocked(skills: SkillProgress) -> Bool {
        let maxLevel = SkillType.allCases.map { skills.level(for: $0) }.max() ?? 1
        return maxLevel >= requiredLevel
    }
}
