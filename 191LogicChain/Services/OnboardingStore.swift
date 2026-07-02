import Foundation

struct OnboardingStore {
    var hasCompleted: Bool {
        UserDefaults.standard.bool(forKey: StorageKeys.hasCompletedOnboarding)
    }

    func markCompleted() {
        UserDefaults.standard.set(true, forKey: StorageKeys.hasCompletedOnboarding)
    }
}
