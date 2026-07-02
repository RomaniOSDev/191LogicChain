import Foundation

class WeeklyCampaignService {
    private let storageService: StorageServiceProtocol
    private let wordService: WordService

    init(storageService: StorageServiceProtocol, wordService: WordService) {
        self.storageService = storageService
        self.wordService = wordService
    }

    func currentCampaign() -> WeeklyCampaign {
        let weekId = currentWeekId()
        if let saved: WeeklyCampaign = storageService.loadObject(forKey: StorageKeys.weeklyCampaign),
           saved.weekId == weekId {
            return saved
        }
        let campaign = generateCampaign(weekId: weekId)
        storageService.saveObject(campaign, forKey: StorageKeys.weeklyCampaign)
        return campaign
    }

    func markDayCompleted(dayId: String, score: Int) {
        var campaign = currentCampaign()
        if let index = campaign.days.firstIndex(where: { $0.id == dayId }) {
            campaign.days[index].completed = true
            campaign.days[index].score = score
            storageService.saveObject(campaign, forKey: StorageKeys.weeklyCampaign)
        }
    }

    private func currentWeekId() -> String {
        let calendar = Calendar.current
        let week = calendar.component(.weekOfYear, from: Date())
        let year = calendar.component(.yearForWeekOfYear, from: Date())
        return "\(year)-W\(week)"
    }

    private func generateCampaign(weekId: String) -> WeeklyCampaign {
        let categories = Category.allCases
        let weekNumber = Calendar.current.component(.weekOfYear, from: Date())
        let theme = categories[weekNumber % categories.count]
        let pairs = wordService.getWordPairs().filter { $0.category == theme }
        let fallback = wordService.getWordPairs()

        var days: [WeeklyDayChallenge] = []
        for day in 1...6 {
            let pair = (pairs.isEmpty ? fallback : pairs)[(day - 1) % max(1, (pairs.isEmpty ? fallback : pairs).count)]
            days.append(WeeklyDayChallenge(
                id: "\(weekId)-day\(day)",
                dayIndex: day,
                title: "Day \(day): \(theme.displayName)",
                startWord: pair.startWord,
                endWord: pair.endWord,
                category: theme,
                difficulty: day <= 2 ? .easy : (day <= 4 ? .medium : .hard),
                completed: false,
                score: nil,
                isBoss: false
            ))
        }

        let bossPair = (pairs.isEmpty ? fallback : pairs).randomElement() ?? fallback[0]
        days.append(WeeklyDayChallenge(
            id: "\(weekId)-boss",
            dayIndex: 7,
            title: "Boss: \(theme.displayName) Finale",
            startWord: bossPair.startWord,
            endWord: bossPair.endWord,
            category: theme,
            difficulty: .hard,
            completed: false,
            score: nil,
            isBoss: true
        ))

        return WeeklyCampaign(
            weekId: weekId,
            theme: theme,
            themeTitle: "\(theme.icon) \(theme.displayName) Week",
            days: days
        )
    }
}
