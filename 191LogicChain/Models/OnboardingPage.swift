import SwiftUI

struct OnboardingPage: Identifiable {
    let id: Int
    let icon: String
    let title: String
    let subtitle: String
    let accent: Color
}

extension OnboardingPage {
    static let all: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            icon: "🔗",
            title: "Build Word Chains",
            subtitle: "Each new word must start with the last letter of the previous one. Link start to goal in as few steps as you can.",
            accent: Theme.accent
        ),
        OnboardingPage(
            id: 1,
            icon: "🎮",
            title: "Many Ways to Play",
            subtitle: "Solo mode, AI battles, logic puzzles, daily challenges, weekly campaigns, and friend pass-and-play.",
            accent: Color(hex: "7b68ee")
        ),
        OnboardingPage(
            id: 2,
            icon: "📈",
            title: "Grow Your Skills",
            subtitle: "Earn XP, unlock features, collect badges, and climb the leaderboard as your chains get sharper.",
            accent: Color(hex: "ffa500")
        )
    ]
}
