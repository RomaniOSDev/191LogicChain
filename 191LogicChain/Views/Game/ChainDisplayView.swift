import SwiftUI

struct ChainDisplayView: View {
    let startWord: String
    let endWord: String
    let chain: [String]
    let isWin: Bool
    let isGameOver: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                chainNode(startWord, color: Theme.accent, isHighlighted: false)
                connector
            }

            if chain.count > 1 {
                ForEach(Array(chain.dropFirst().enumerated()), id: \.offset) { index, word in
                    let isLast = index == chain.count - 2
                    HStack(spacing: 8) {
                        connectorVertical
                        chainNode(
                            word,
                            color: isGameOver && isLast && isWin ? Theme.accent : Theme.primaryText,
                            isHighlighted: isGameOver && isLast && isWin
                        )
                    }
                    if !isLast {
                        HStack { connectorVertical; connector }
                    }
                }
            }

            HStack {
                connectorVertical
                HStack(spacing: 8) {
                    connector
                    chainNode(
                        endWord,
                        color: isGameOver && isWin ? Theme.accent : Theme.danger,
                        isHighlighted: isGameOver && isWin,
                        isTarget: true
                    )
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .surfaceStyle(cornerRadius: Theme.Radius.lg, accent: Theme.accent, elevation: .raised)
        .padding(.horizontal, Theme.Spacing.md)
    }

    private func chainNode(_ text: String, color: Color, isHighlighted: Bool, isTarget: Bool = false) -> some View {
        Text(text)
            .font(isTarget ? .title3.bold() : .headline)
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                color.opacity(isHighlighted ? 0.2 : 0.1),
                                color.opacity(isHighlighted ? 0.12 : 0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(color.opacity(isHighlighted ? 0.45 : 0.28), lineWidth: 1)
                    )
            )
    }

    private var connector: some View {
        Image(systemName: "arrow.right")
            .font(.caption2.weight(.bold))
            .foregroundColor(Theme.secondaryText)
    }

    private var connectorVertical: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [Theme.accent.opacity(0.45), Theme.accent.opacity(0.15)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 2, height: 12)
            .padding(.leading, 18)
    }
}
