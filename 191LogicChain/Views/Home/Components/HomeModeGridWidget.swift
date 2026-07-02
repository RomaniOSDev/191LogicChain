import SwiftUI

struct HomeModeGridWidget: View {
    let onSolo: () -> Void
    let onBattle: () -> Void
    let onTimeAttack: () -> Void
    let onMinimal: () -> Void
    let onPuzzles: () -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            HomeImageTile(
                imageName: "WidgetSolo",
                title: "Solo",
                subtitle: "Classic word chain mode",
                accent: Theme.accent,
                action: onSolo
            )

            HomeImageTile(
                imageName: "WidgetBattle",
                title: "AI Battle",
                subtitle: "Compete against the AI",
                accent: Theme.danger,
                action: onBattle
            )

            HomeImageTile(
                imageName: "WidgetTime",
                title: "Time Attack",
                subtitle: "Race against the clock",
                accent: Color(hex: "ffa500"),
                action: onTimeAttack
            )

            HomeImageTile(
                imageName: "WidgetMinimal",
                title: "Minimal Chain",
                subtitle: "Find the shortest path",
                accent: Theme.accent,
                action: onMinimal
            )

            HomeImageTile(
                imageName: "WidgetPuzzle",
                title: "Logic Puzzles",
                subtitle: "Levels with special rules",
                accent: Color(hex: "7b68ee"),
                height: 148,
                action: onPuzzles
            )
            .gridCellColumns(2)
        }
    }
}

struct HomeCreateShareWidget: View {
    let onChainBuilder: () -> Void
    let onFriendChallenge: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            HomeImageTile(
                imageName: "WidgetBuilder",
                title: "Chain Builder",
                subtitle: "Create custom chains",
                accent: Theme.accent,
                height: 132,
                action: onChainBuilder
            )

            HomeImageTile(
                imageName: "WidgetFriend",
                title: "Friend Challenge",
                subtitle: "Pass & play or share",
                accent: Color(hex: "4ecdc4"),
                height: 132,
                action: onFriendChallenge
            )
        }
    }
}
