import Foundation

struct WeeklyDayChallenge: Identifiable, Codable, Hashable {
    let id: String
    let dayIndex: Int
    let title: String
    let startWord: String
    let endWord: String
    let category: Category
    let difficulty: Difficulty
    var completed: Bool
    var score: Int?
    var isBoss: Bool
}

struct WeeklyCampaign: Codable, Hashable {
    let weekId: String
    let theme: Category
    let themeTitle: String
    var days: [WeeklyDayChallenge]

    var completedCount: Int {
        days.filter(\.completed).count
    }

    var bossDay: WeeklyDayChallenge? {
        days.first(where: \.isBoss)
    }
}
