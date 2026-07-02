import Foundation

struct LeaderboardEntry: Identifiable, Codable, Hashable {
    let id: UUID
    var playerName: String
    var score: Int
    var chainLength: Int
    var mode: GameMode
    var date: Date
}
