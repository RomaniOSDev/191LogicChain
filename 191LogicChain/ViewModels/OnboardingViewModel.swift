import Combine
import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0

    let pages = OnboardingPage.all
    private let store = OnboardingStore()
    private let onComplete: () -> Void

    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }

    var isLastPage: Bool {
        currentPage == pages.count - 1
    }

    func next() {
        if isLastPage {
            finish()
        } else {
            currentPage += 1
        }
    }

    func skip() {
        finish()
    }

    private func finish() {
        store.markCompleted()
        onComplete()
    }
}
