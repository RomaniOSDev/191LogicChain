import Combine
import SwiftUI

@MainActor
class AchievementsViewModel: ObservableObject {
    @Published var records: [AchievementRecord] = []

    private let coordinator: AppCoordinator
    private let achievementService: AchievementService

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.achievementService = coordinator.achievementService
        load()
    }

    func load() { records = achievementService.getRecords() }

    var unlockedCount: Int { records.filter(\.isUnlocked).count }

    func goBack() { coordinator.pop() }
}
