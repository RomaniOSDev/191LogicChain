import Foundation

enum AppLink {
    case privacyPolicy
    case termsOfUse

    var urlString: String {
        switch self {
        case .privacyPolicy:
            return "https://www.termsfeed.com/live/f9f05b3e-d59f-47b3-b497-f75758c8d940"
        case .termsOfUse:
            return "https://www.termsfeed.com/live/271d11a1-f4f7-43a4-8dcf-bf7898802a79"
        }
    }

    var url: URL? {
        URL(string: urlString)
    }
}
