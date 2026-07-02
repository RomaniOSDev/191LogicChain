import Combine
import SwiftUI

@MainActor
class DictionaryViewModel: ObservableObject {
    @Published var words: [Word] = []
    @Published var searchText = ""
    @Published var selectedCategory: Category?
    @Published var expandedWordId: UUID?

    private let coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        load()
    }

    func load() {
        words = coordinator.wordService.getWords()
    }

    var filteredWords: [Word] {
        words.filter { word in
            let matchesSearch = searchText.isEmpty ||
                word.text.localizedCaseInsensitiveContains(searchText) ||
                word.synonyms.contains { $0.localizedCaseInsensitiveContains(searchText) }
            let matchesCategory = selectedCategory == nil || word.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }

    func goBack() { coordinator.pop() }

    func toggleWord(_ word: Word) {
        expandedWordId = expandedWordId == word.id ? nil : word.id
    }

    func chainSuggestions(for word: Word) -> [String] {
        coordinator.chainEngine.getPossibleNextWords(
            currentWord: word.text,
            usedWords: [word.text],
            category: word.category
        )
        .prefix(8)
        .map(\.text)
    }
}
