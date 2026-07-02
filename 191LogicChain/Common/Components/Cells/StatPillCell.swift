import SwiftUI

struct StatPillCell: View {
    let icon: String
    let value: String
    let label: String
    var accent: Color = Theme.accent

    var body: some View {
        VStack(spacing: 6) {
            Text(icon).font(.title3)
            Text(value)
                .font(.title3.bold())
                .foregroundColor(Theme.primaryText)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(label)
                .font(.caption2)
                .foregroundColor(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .surfaceStyle(cornerRadius: Theme.Radius.md, accent: accent, elevation: .flat)
    }
}
