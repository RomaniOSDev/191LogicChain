import SwiftUI

struct TimerCountdownView: View {
    let timeLeft: Int
    let totalTime: Int

    var percentage: CGFloat {
        guard totalTime > 0 else { return 0 }
        return CGFloat(timeLeft) / CGFloat(totalTime)
    }

    var color: Color {
        if percentage > 0.5 { return Theme.accent }
        if percentage > 0.25 { return Color(hex: "ffa500") }
        return Theme.danger
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "timer")
                .font(.caption.weight(.semibold))
                .foregroundColor(color)

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Theme.background.opacity(0.65))
                    .frame(width: 72, height: 8)
                Capsule()
                    .fill(
                        LinearGradient(colors: [color, color.opacity(0.55)], startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(width: max(72 * percentage, 4), height: 8)
            }

            Text("\(timeLeft)s")
                .font(.caption.monospacedDigit().weight(.bold))
                .foregroundColor(color)
                .frame(minWidth: 28, alignment: .trailing)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .surfaceStyle(cornerRadius: 20, accent: color, elevation: .flat)
    }
}
