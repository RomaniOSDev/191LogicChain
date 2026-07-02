import Foundation

enum WordFrequency: String, Codable, Hashable, CaseIterable {
    case common
    case uncommon
    case rare

    var displayName: String {
        rawValue.capitalized
    }
}
