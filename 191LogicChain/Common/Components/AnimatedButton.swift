import SwiftUI

struct AnimatedButton: View {
    let title: String
    var icon: String? = nil
    let color: Color
    var style: Style = .filled
    let action: () -> Void

    enum Style { case filled, outline }

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(.headline.weight(.semibold))
            .foregroundColor(style == .filled ? Theme.background : color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous))
            .overlay(buttonBorder)
            .shadow(
                color: style == .filled ? color.opacity(0.22) : .clear,
                radius: 8,
                y: 4
            )
            .scaleEffect(isPressed ? 0.97 : 1)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .animation(.easeInOut(duration: 0.12), value: isPressed)
    }

    @ViewBuilder
    private var background: some View {
        if style == .filled {
            LinearGradient(
                colors: [color.opacity(0.95), color.opacity(0.72)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            LinearGradient(
                colors: [color.opacity(0.14), color.opacity(0.06)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    @ViewBuilder
    private var buttonBorder: some View {
        let shape = RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
        if style == .outline {
            shape.stroke(color.opacity(0.55), lineWidth: 1.5)
        } else {
            shape.stroke(
                LinearGradient(
                    colors: [Color.white.opacity(0.28), color.opacity(0.15)],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 1.5
            )
        }
    }
}
