import Combine
import SwiftUI

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}

@MainActor
class StatisticsViewModel: ObservableObject {
    @Published var stats: Stats
    @Published var recentSessions: [ChainSession] = []
    @Published var winsByMode: [ChartDataPoint] = []
    @Published var chainLengthTrend: [ChartDataPoint] = []

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator

    init(storageService: StorageServiceProtocol, coordinator: AppCoordinator) {
        self.storageService = storageService
        self.coordinator = coordinator
        self.stats = storageService.loadObject(forKey: StorageKeys.stats) ?? Stats(
            totalGames: 0, totalWins: 0, bestChainLength: 0, totalWordsUsed: 0,
            favoriteCategory: nil, averageChainLength: 0, streaks: 0, maxStreaks: 0
        )
        loadData()
    }

    func loadData() {
        stats = storageService.loadObject(forKey: StorageKeys.stats) ?? stats
        let sessions: [ChainSession] = storageService.load(forKey: StorageKeys.sessions)
        recentSessions = Array(sessions.suffix(10).reversed())

        winsByMode = GameMode.allCases.map { mode in
            let count = Double(sessions.filter { $0.mode == mode && $0.isWin }.count)
            return ChartDataPoint(label: mode.displayName, value: count)
        }

        chainLengthTrend = recentSessions.prefix(7).reversed().enumerated().map { index, session in
            ChartDataPoint(label: "G\(index + 1)", value: Double(session.chain.count))
        }

    }

    var winRate: Double {
        guard stats.totalGames > 0 else { return 0 }
        return Double(stats.totalWins) / Double(stats.totalGames) * 100
    }

    func goBack() {
        coordinator.pop()
    }
}
