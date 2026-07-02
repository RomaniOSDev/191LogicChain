import Foundation

struct Stats: Codable, Hashable {
    var totalGames: Int
    var totalWins: Int
    var bestChainLength: Int
    var totalWordsUsed: Int
    var favoriteCategory: Category?
    var averageChainLength: Double
    var streaks: Int
    var maxStreaks: Int
}
