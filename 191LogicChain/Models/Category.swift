import Foundation

enum Category: String, CaseIterable, Codable, Hashable {
    case animals
    case food
    case cities
    case professions
    case nature
    case technology
    case sport
    case art
    case science
    case everyday

    var icon: String {
        switch self {
        case .animals: return "🐾"
        case .food: return "🍔"
        case .cities: return "🏙️"
        case .professions: return "💼"
        case .nature: return "🌿"
        case .technology: return "💻"
        case .sport: return "⚽"
        case .art: return "🎨"
        case .science: return "🔬"
        case .everyday: return "🏠"
        }
    }

    var displayName: String {
        switch self {
        case .animals: return "Animals"
        case .food: return "Food"
        case .cities: return "Cities"
        case .professions: return "Professions"
        case .nature: return "Nature"
        case .technology: return "Technology"
        case .sport: return "Sport"
        case .art: return "Art"
        case .science: return "Science"
        case .everyday: return "Everyday"
        }
    }

    var labeledName: String {
        "\(icon) \(displayName)"
    }
}
