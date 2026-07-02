import SwiftUI

struct ChainAnalysisView: View {
    let analysis: ChainAnalysis

    var body: some View {
        AppCard(accent: Color(hex: "7b68ee")) {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeaderView(title: "Chain Analysis", trailing: "Learn")

                Text(analysis.efficiencyMessage)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(Theme.accent)

                if !analysis.moves.isEmpty {
                    Text("Move breakdown")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(Theme.secondaryText)

                    ForEach(analysis.moves) { move in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "link")
                                .font(.caption)
                                .foregroundColor(Theme.accent)
                                .padding(.top, 2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(move.fromWord) → \(move.toWord)")
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(Theme.primaryText)
                                Text(move.reason)
                                    .font(.caption2)
                                    .foregroundColor(Theme.secondaryText)
                            }
                        }
                        .padding(8)
                        .insetSurface(cornerRadius: 8)
                    }
                }

                if let optimal = analysis.optimalChain, !optimal.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Optimal path (\(optimal.count) words)")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(Theme.secondaryText)
                        Text(optimal.joined(separator: " → "))
                            .font(.caption)
                            .foregroundColor(Theme.accent)
                    }
                }

                if !analysis.alternativePaths.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Alternatives")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(Theme.secondaryText)
                        ForEach(Array(analysis.alternativePaths.prefix(3).enumerated()), id: \.offset) { _, path in
                            Text(path.joined(separator: " → "))
                                .font(.caption2)
                                .foregroundColor(Theme.secondaryText)
                        }
                    }
                }
            }
        }
    }
}
