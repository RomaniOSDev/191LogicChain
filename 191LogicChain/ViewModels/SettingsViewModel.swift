import Combine
import StoreKit
import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var playerName: String
    @Published var defaultDifficulty: Difficulty
    @Published var accessibility: AccessibilitySettings
    @Published var showResetAlert = false

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator
    private let accessibilityStore: AccessibilitySettingsStore

    init(storageService: StorageServiceProtocol, coordinator: AppCoordinator, accessibilityStore: AccessibilitySettingsStore) {
        self.storageService = storageService
        self.coordinator = coordinator
        self.accessibilityStore = accessibilityStore
        self.playerName = UserDefaults.standard.string(forKey: StorageKeys.playerName) ?? "Player"
        if let saved = UserDefaults.standard.string(forKey: StorageKeys.defaultDifficulty),
           let difficulty = Difficulty(rawValue: saved) {
            self.defaultDifficulty = difficulty
        } else {
            self.defaultDifficulty = .medium
        }
        self.accessibility = accessibilityStore.load()
    }

    func savePlayerName() {
        UserDefaults.standard.set(playerName, forKey: StorageKeys.playerName)
    }

    func saveDifficulty() {
        UserDefaults.standard.set(defaultDifficulty.rawValue, forKey: StorageKeys.defaultDifficulty)
    }

    func saveAccessibility() {
        accessibilityStore.save(accessibility)
        NotificationCenter.default.post(name: .accessibilityChanged, object: nil)
    }

    func resetAllData() {
        storageService.delete(forKey: StorageKeys.sessions)
        storageService.delete(forKey: StorageKeys.dailyChallenges)
        storageService.delete(forKey: StorageKeys.leaderboard)
        storageService.delete(forKey: StorageKeys.stats)
        storageService.delete(forKey: StorageKeys.words)
        storageService.delete(forKey: StorageKeys.wordPairs)
        storageService.delete(forKey: StorageKeys.customChains)
        storageService.delete(forKey: StorageKeys.logicPuzzles)
        storageService.delete(forKey: StorageKeys.skillProgress)
        storageService.delete(forKey: StorageKeys.achievements)
        storageService.delete(forKey: StorageKeys.weeklyCampaign)

        let defaultStats = Stats(
            totalGames: 0, totalWins: 0, bestChainLength: 0, totalWordsUsed: 0,
            favoriteCategory: nil, averageChainLength: 0, streaks: 0, maxStreaks: 0
        )
        storageService.saveObject(defaultStats, forKey: StorageKeys.stats)
    }

    func goBack() {
        savePlayerName()
        saveDifficulty()
        saveAccessibility()
        coordinator.pop()
    }

    func openLink(_ link: AppLink) {
        if let url = link.url {
            UIApplication.shared.open(url)
        }
    }

    func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
