import AVFoundation
import Combine
import Foundation

@MainActor
class AccessibilitySpeechService: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String, enabled: Bool) {
        guard enabled, !text.isEmpty else { return }
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.48
        synthesizer.speak(utterance)
    }

    func speakCurrentLetter(_ word: String, enabled: Bool) {
        guard let last = word.last else { return }
        speak("Current letter: \(String(last).uppercased())", enabled: enabled)
    }
}

class AccessibilitySettingsStore {
    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }

    func load() -> AccessibilitySettings {
        storageService.loadObject(forKey: StorageKeys.accessibility) ?? .default
    }

    func save(_ settings: AccessibilitySettings) {
        storageService.saveObject(settings, forKey: StorageKeys.accessibility)
    }
}
