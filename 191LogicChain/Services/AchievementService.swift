import Foundation

class AchievementService {
    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }

    func getRecords() -> [AchievementRecord] {
        var records: [AchievementRecord] = storageService.load(forKey: StorageKeys.achievements)
        if records.isEmpty {
            records = AchievementID.allCases.map {
                AchievementRecord(id: $0, unlockedAt: nil, progress: 0, target: 1)
            }
            storageService.save(records, forKey: StorageKeys.achievements)
        }
        return records
    }

    func evaluate(session: ChainSession, stats: Stats, hintsUsed: Int) -> [AchievementID] {
        var records = getRecords()
        var newlyUnlocked: [AchievementID] = []

        func unlock(_ id: AchievementID) {
            guard let i = records.firstIndex(where: { $0.id == id }), records[i].unlockedAt == nil else { return }
            records[i].unlockedAt = Date()
            records[i].progress = records[i].target
            newlyUnlocked.append(id)
        }

        if session.isWin {
            unlock(.firstWin)
            if session.chain.count >= 8 { unlock(.chainMaster) }
            if session.timeUsed <= 25 { unlock(.speedDemon) }
            if session.chain.dropFirst().allSatisfy({ $0.count == 3 }) { unlock(.threeLetterHero) }
            if session.chain.last?.lowercased().hasSuffix("z") == true { unlock(.endsWithZ) }
            if let last = session.chain.last?.lowercased().last,
               ["q", "x", "z"].contains(String(last)) { unlock(.rareLetterChain) }
            if session.mode == .battle && hintsUsed == 0 { unlock(.beatAIWithoutHints) }
            if session.mode == .logicPuzzle { unlock(.puzzleSolver) }
            if session.mode == .weeklyCampaign, session.playConfig?.weeklyDayId?.contains("boss") == true {
                unlock(.weeklyBoss)
            }
            if session.mode == .customChain { unlock(.customCreator) }
            if session.mode == .minimalChain,
               let optimal = session.optimalChainLength,
               session.chain.count == optimal { unlock(.minimalPath) }
        }

        if stats.streaks >= 5 { unlock(.streakFive) }

        if let i = records.firstIndex(where: { $0.id == .customCreator }),
           records[i].unlockedAt == nil {
            let customs: [CustomChain] = storageService.load(forKey: StorageKeys.customChains)
            if !customs.isEmpty {
                records[i].progress = 1
                if customs.contains(where: { $0.timesPlayed > 0 }) { unlock(.customCreator) }
            }
        }

        storageService.save(records, forKey: StorageKeys.achievements)
        return newlyUnlocked
    }
}
