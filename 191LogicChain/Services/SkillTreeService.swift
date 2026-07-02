import Foundation

class SkillTreeService {
    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }

    func getProgress() -> SkillProgress {
        storageService.loadObject(forKey: StorageKeys.skillProgress) ?? .empty
    }

    func save(_ progress: SkillProgress) {
        storageService.saveObject(progress, forKey: StorageKeys.skillProgress)
    }

    func awardXP(for session: ChainSession, hintsUsed: Int) {
        guard session.isWin else { return }
        var progress = getProgress()

        let timeBonus = max(0, Difficulty.medium.timeLimit - session.timeUsed)
        progress.addXP(10 + timeBonus / 5, for: .speed)

        let uniqueWords = Set(session.chain.map { $0.lowercased() }).count
        progress.addXP(uniqueWords * 5, for: .vocabulary)

        if session.mode == .logicPuzzle || session.mode == .minimalChain {
            progress.addXP(25, for: .patternRecognition)
        } else {
            progress.addXP(session.chain.count * 2, for: .patternRecognition)
        }

        let rareLetters = ["q", "x", "z", "j", "k"]
        var rareCount = 0
        for word in session.chain {
            for char in word.lowercased() where rareLetters.contains(String(char)) {
                rareCount += 1
            }
        }
        progress.addXP(rareCount * 8, for: .rareLetters)

        if hintsUsed == 0 { progress.addXP(5, for: .patternRecognition) }

        save(progress)
    }

    func isFeatureUnlocked(_ feature: FeatureUnlock) -> Bool {
        feature.isUnlocked(skills: getProgress())
    }

    func maxSkillLevel() -> Int {
        let progress = getProgress()
        return SkillType.allCases.map { progress.level(for: $0) }.max() ?? 1
    }
}
