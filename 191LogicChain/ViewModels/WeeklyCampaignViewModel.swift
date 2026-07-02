import Combine
import SwiftUI

@MainActor
class WeeklyCampaignViewModel: ObservableObject {
    @Published var campaign: WeeklyCampaign

    private let coordinator: AppCoordinator
    private let weeklyService: WeeklyCampaignService

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.weeklyService = coordinator.weeklyCampaignService
        self.campaign = weeklyService.currentCampaign()
    }

    func refresh() { campaign = weeklyService.currentCampaign() }

    func playDay(_ day: WeeklyDayChallenge) {
        var config = GamePlayConfig()
        config.weeklyDayId = day.id
        coordinator.navigateToGame(
            mode: .weeklyCampaign,
            startWord: day.startWord,
            endWord: day.endWord,
            category: day.category,
            difficulty: day.difficulty,
            config: config
        )
    }

    func goBack() { coordinator.pop() }
}
