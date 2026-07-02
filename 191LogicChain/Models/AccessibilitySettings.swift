import Foundation

struct AccessibilitySettings: Codable, Hashable {
    var largeFont: Bool
    var highContrast: Bool
    var speechEnabled: Bool

    static let `default` = AccessibilitySettings(largeFont: false, highContrast: false, speechEnabled: false)
}
