import SwiftUI

// MARK: - Leaderboard

struct LeaderboardRowCell: View {
    let rank: Int
    let name: String
    let detail: String
    let score: Int

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [rankColor.opacity(0.22), rankColor.opacity(0.06)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 24
                        )
                    )
                    .frame(width: 44, height: 44)
                    .overlay(Circle().stroke(rankColor.opacity(rank < 3 ? 0.35 : 0.12), lineWidth: 1))
                Text(rankDisplay)
                    .font(rank < 3 ? .title3 : .subheadline.weight(.bold))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(Theme.primaryText)
                Text(detail)
                    .font(.caption)
                    .foregroundColor(Theme.secondaryText)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(score)")
                    .font(.title3.bold())
                    .foregroundColor(Theme.accent)
                Text("pts")
                    .font(.caption2)
                    .foregroundColor(Theme.secondaryText)
            }
        }
        .padding(14)
        .surfaceStyle(cornerRadius: Theme.Radius.md, accent: rankColor, elevation: .flat)
    }

    private var rankDisplay: String {
        switch rank {
        case 0: return "🥇"
        case 1: return "🥈"
        case 2: return "🥉"
        default: return "\(rank + 1)"
        }
    }

    private var rankColor: Color {
        switch rank {
        case 0: return Color(hex: "ffd700")
        case 1: return Color(hex: "c0c0c0")
        case 2: return Color(hex: "cd7f32")
        default: return Theme.secondaryText
        }
    }
}

// MARK: - Puzzle Level

struct PuzzleLevelCell: View {
    let level: LogicPuzzleLevel
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    AccentOrbBackground(
                        accent: level.isCompleted ? Theme.accent : Theme.danger,
                        cornerRadius: 12
                    )
                    Text(level.isCompleted ? "✅" : "🧩")
                        .font(.title3)
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(level.title)
                            .font(.headline)
                            .foregroundColor(Theme.primaryText)
                        Spacer()
                        TagBadge(text: level.difficulty.displayName)
                    }
                    Text(level.description)
                        .font(.caption)
                        .foregroundColor(Theme.secondaryText)
                    WordChainBadge(start: level.startWord, end: level.endWord, size: .subheadline)
                    Text(level.constraints.summary)
                        .font(.caption2)
                        .foregroundColor(Theme.accent.opacity(0.9))
                        .padding(.top, 2)
                }
            }
            .padding(14)
            .surfaceStyle(cornerRadius: Theme.Radius.lg, accent: Theme.accent, elevation: .flat)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Achievement

struct AchievementRowCell: View {
    let record: AchievementRecord

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.accent.opacity(record.isUnlocked ? 0.22 : 0.06),
                                Theme.accent.opacity(0.04)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .frame(width: 52, height: 52)
                    .overlay(Circle().stroke(Theme.accent.opacity(record.isUnlocked ? 0.4 : 0.1), lineWidth: 1))
                Text(record.id.icon)
                    .font(.title2)
                    .opacity(record.isUnlocked ? 1 : 0.35)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(record.id.title)
                    .font(.headline)
                    .foregroundColor(record.isUnlocked ? Theme.primaryText : Theme.secondaryText)
                Text(record.id.description)
                    .font(.caption)
                    .foregroundColor(Theme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
                if !record.isUnlocked {
                    ProgressView(value: record.progressFraction)
                        .tint(Theme.accent)
                }
            }

            Spacer(minLength: 0)

            if record.isUnlocked {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Theme.accent)
                    .font(.title3)
            }
        }
        .padding(14)
        .surfaceStyle(cornerRadius: Theme.Radius.md, accent: Theme.accent, elevation: .flat)
    }
}

// MARK: - Skill

struct SkillRowCell: View {
    let skill: SkillType
    let level: Int
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(skill.icon).font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(skill.displayName)
                        .font(.headline)
                        .foregroundColor(Theme.primaryText)
                    Text(skill.unlockDescription)
                        .font(.caption)
                        .foregroundColor(Theme.secondaryText)
                }
                Spacer()
                Text("Lv \(level)")
                    .font(.subheadline.bold())
                    .foregroundColor(Theme.accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Theme.accent.opacity(0.18), Theme.accent.opacity(0.08)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(Capsule().stroke(Theme.accent.opacity(0.25), lineWidth: 1))
                    )
            }
            ProgressView(value: progress)
                .tint(Theme.accent)
        }
        .padding(14)
        .surfaceStyle(cornerRadius: Theme.Radius.md, accent: Theme.accent, elevation: .flat)
    }
}

// MARK: - Dictionary Word

struct DictionaryWordCell: View {
    let word: Word
    var isExpanded: Bool = false
    var chainSuggestions: [String] = []
    let onTap: () -> Void

    @State private var pressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(word.text)
                            .font(.title3.bold())
                            .foregroundColor(Theme.primaryText)
                        Text(word.category.labeledName)
                            .font(.caption)
                            .foregroundColor(Theme.secondaryText)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        TagBadge(text: word.frequency.displayName)
                        HStack(spacing: 2) {
                            ForEach(0..<word.letterDifficulty, id: \.self) { _ in
                                Circle().fill(Theme.accent).frame(width: 5, height: 5)
                            }
                        }
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption.weight(.bold))
                            .foregroundColor(Theme.accent)
                            .padding(.top, 4)
                    }
                }

                if !word.synonyms.isEmpty {
                    Text("Synonyms: \(word.synonyms.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundColor(Theme.secondaryText)
                        .lineLimit(isExpanded ? nil : 1)
                }

                if isExpanded {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            TagBadge(text: word.difficulty.displayName, color: Theme.secondaryText)
                            if word.isCommon {
                                TagBadge(text: "Common", color: Theme.accent)
                            }
                        }

                        if !word.exampleUsage.isEmpty {
                            Text(word.exampleUsage)
                                .font(.caption)
                                .italic()
                                .foregroundColor(Theme.secondaryText.opacity(0.9))
                        }

                        if !chainSuggestions.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Chain suggestions")
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(Theme.accent)
                                FlowLayout(spacing: 6) {
                                    ForEach(chainSuggestions, id: \.self) { suggestion in
                                        Text(suggestion)
                                            .font(.caption.weight(.medium))
                                            .foregroundColor(Theme.primaryText)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .insetSurface(cornerRadius: Theme.Radius.sm)
                                    }
                                }
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                } else if !word.exampleUsage.isEmpty {
                    Text(word.exampleUsage)
                        .font(.caption)
                        .italic()
                        .foregroundColor(Theme.secondaryText.opacity(0.9))
                        .lineLimit(1)
                }
            }
            .padding(14)
            .surfaceStyle(
                cornerRadius: Theme.Radius.md,
                accent: isExpanded ? Theme.accent : Theme.accent.opacity(0.6),
                elevation: .flat
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                    .stroke(isExpanded ? Theme.accent.opacity(0.45) : Color.clear, lineWidth: 1)
            )
            .scaleEffect(pressed ? 0.98 : 1)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded { _ in pressed = false }
        )
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}

// MARK: - Custom Chain

struct CustomChainCell: View {
    let chain: CustomChain
    let onPlay: () -> Void
    let onShare: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(chain.title)
                    .font(.headline)
                    .foregroundColor(Theme.primaryText)
                Spacer()
                TagBadge(text: chain.difficulty.displayName)
            }

            WordChainBadge(start: chain.startWord, end: chain.endWord)

            HStack(spacing: 8) {
                Label(chain.authorName, systemImage: "person.fill")
                Label("\(chain.timesPlayed)x", systemImage: "play.fill")
            }
            .font(.caption)
            .foregroundColor(Theme.secondaryText)

            HStack(spacing: 8) {
                ActionChipButton(title: "Play", icon: "play.fill", color: Theme.accent, action: onPlay)
                ActionChipButton(title: "Share", icon: "square.and.arrow.up", color: Theme.secondaryText, action: onShare)
                ActionChipButton(title: "Delete", icon: "trash", color: Theme.danger, action: onDelete)
            }
        }
        .padding(14)
        .surfaceStyle(cornerRadius: Theme.Radius.lg, accent: Theme.accent, elevation: .flat)
    }
}

struct ActionChipButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.caption.weight(.semibold))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.16), color.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(Capsule().stroke(color.opacity(0.22), lineWidth: 1))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Weekly Day

struct WeeklyDayCell: View {
    let day: WeeklyDayChallenge
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    AccentOrbBackground(
                        accent: day.isBoss ? Theme.danger : Theme.accent,
                        cornerRadius: 10,
                        size: 44
                    )
                    Text(day.isBoss ? "👹" : "D\(day.dayIndex)")
                        .font(day.isBoss ? .title3 : .caption.bold())
                        .foregroundColor(day.isBoss ? Theme.danger : Theme.accent)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(day.title)
                        .font(.headline)
                        .foregroundColor(Theme.primaryText)
                    WordChainBadge(start: day.startWord, end: day.endWord, size: .subheadline)
                }

                Spacer()

                if day.completed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Theme.accent)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundColor(Theme.secondaryText)
                }
            }
            .padding(14)
            .surfaceStyle(
                cornerRadius: Theme.Radius.md,
                accent: day.isBoss ? Theme.danger : Theme.accent,
                elevation: .flat
            )
        }
        .buttonStyle(.plain)
        .disabled(day.completed)
        .opacity(day.completed ? 0.7 : 1)
    }
}

// MARK: - Feature Unlock

struct FeatureUnlockCell: View {
    let feature: FeatureUnlock
    let isUnlocked: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isUnlocked ? "lock.open.fill" : "lock.fill")
                .foregroundColor(isUnlocked ? Theme.accent : Theme.secondaryText)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(feature.displayName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Theme.primaryText)
                Text("Skill level \(feature.requiredLevel)+")
                    .font(.caption)
                    .foregroundColor(Theme.secondaryText)
            }
            Spacer()
            if isUnlocked {
                TagBadge(text: "Unlocked", color: Theme.accent)
            }
        }
        .padding(12)
        .insetSurface(cornerRadius: Theme.Radius.sm)
    }
}
