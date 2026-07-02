import Foundation

extension DateFormatter {
    static func dateFormat(_ format: String, from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

extension Notification.Name {
    static let playAgain = Notification.Name("playAgain")
    static let accessibilityChanged = Notification.Name("accessibilityChanged")
}
