import Combine
import SwiftUI

@MainActor
class LeaderboardViewModel: ObservableObject {
    @Published var entries: [LeaderboardEntry] = []
    @Published var selectedMode: GameMode?

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator

    init(storageService: StorageServiceProtocol, coordinator: AppCoordinator) {
        self.storageService = storageService
        self.coordinator = coordinator
        loadEntries()
    }

    func loadEntries() {
        let all: [LeaderboardEntry] = storageService.load(forKey: StorageKeys.leaderboard)
        if let selectedMode {
            entries = all
                .filter { $0.mode == selectedMode }
                .sorted { $0.score > $1.score }
        } else {
            entries = all.sorted { $0.score > $1.score }
        }
    }

    func selectMode(_ mode: GameMode?) {
        selectedMode = mode
        loadEntries()
    }

    func goBack() {
        coordinator.pop()
    }
}
