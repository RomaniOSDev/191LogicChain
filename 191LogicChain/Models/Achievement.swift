import Foundation

enum AchievementID: String, Codable, CaseIterable, Hashable {
    case firstWin
    case chainMaster
    case speedDemon
    case threeLetterHero
    case endsWithZ
    case beatAIWithoutHints
    case minimalPath
    case puzzleSolver
    case weeklyBoss
    case customCreator
    case rareLetterChain
    case streakFive

    var title: String {
        switch self {
        case .firstWin: return "First Victory"
        case .chainMaster: return "Chain Master"
        case .speedDemon: return "Speed Demon"
        case .threeLetterHero: return "Three Letter Hero"
        case .endsWithZ: return "Z Finale"
        case .beatAIWithoutHints: return "Mind Over Machine"
        case .minimalPath: return "Shortest Path"
        case .puzzleSolver: return "Puzzle Solver"
        case .weeklyBoss: return "Boss Slayer"
        case .customCreator: return "Chain Creator"
        case .rareLetterChain: return "Rare Letter Pro"
        case .streakFive: return "On Fire"
        }
    }

    var description: String {
        switch self {
        case .firstWin: return "Win your first game"
        case .chainMaster: return "Build a chain of 8+ words"
        case .speedDemon: return "Win with 30+ seconds remaining"
        case .threeLetterHero: return "Win using only 3-letter words"
        case .endsWithZ: return "Complete a chain ending with Z"
        case .beatAIWithoutHints: return "Beat AI without using hints"
        case .minimalPath: return "Find the optimal minimal chain"
        case .puzzleSolver: return "Complete a Logic Puzzle level"
        case .weeklyBoss: return "Beat the weekly boss challenge"
        case .customCreator: return "Create and play a custom chain"
        case .rareLetterChain: return "End chain with Q, X, or Z"
        case .streakFive: return "Reach a 5-win streak"
        }
    }

    var icon: String {
        switch self {
        case .firstWin: return "🎉"
        case .chainMaster: return "🔗"
        case .speedDemon: return "⚡"
        case .threeLetterHero: return "3️⃣"
        case .endsWithZ: return "🦓"
        case .beatAIWithoutHints: return "🤖"
        case .minimalPath: return "📐"
        case .puzzleSolver: return "🧩"
        case .weeklyBoss: return "👹"
        case .customCreator: return "✏️"
        case .rareLetterChain: return "💎"
        case .streakFive: return "🔥"
        }
    }
}

struct AchievementRecord: Identifiable, Codable, Hashable {
    let id: AchievementID
    var unlockedAt: Date?
    var progress: Int
    var target: Int

    var isUnlocked: Bool { unlockedAt != nil }
    var progressFraction: Double {
        guard target > 0 else { return isUnlocked ? 1 : 0 }
        return min(1, Double(progress) / Double(target))
    }
}
