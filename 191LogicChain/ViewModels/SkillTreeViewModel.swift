import Combine
import SwiftUI

@MainActor
class SkillTreeViewModel: ObservableObject {
    @Published var progress: SkillProgress

    private let coordinator: AppCoordinator
    private let skillService: SkillTreeService

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.skillService = coordinator.skillTreeService
        self.progress = skillService.getProgress()
    }

    func refresh() { progress = skillService.getProgress() }

    func isUnlocked(_ feature: FeatureUnlock) -> Bool {
        skillService.isFeatureUnlocked(feature)
    }

    func goBack() { coordinator.pop() }
}
