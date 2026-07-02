import SwiftUI

struct HomeQuickAccessWidget: View {
    let onStatistics: () -> Void
    let onLeaderboard: () -> Void
    let onSkillTree: () -> Void
    let onAchievements: () -> Void
    let onDictionary: () -> Void
    let onSettings: () -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            QuickActionCell(icon: "chart.bar.fill", label: "Stats", action: onStatistics)
            QuickActionCell(icon: "crown.fill", label: "Records", action: onLeaderboard)
            QuickActionCell(icon: "tree.fill", label: "Skills", action: onSkillTree)
            QuickActionCell(icon: "medal.fill", label: "Badges", action: onAchievements)
            QuickActionCell(icon: "book.fill", label: "Dictionary", action: onDictionary)
            QuickActionCell(icon: "gear", label: "Settings", action: onSettings)
        }
    }
}
