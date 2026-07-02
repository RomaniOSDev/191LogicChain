import Foundation

class WordService {
    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol = UserDefaultsStorageService()) {
        self.storageService = storageService
    }

    func getWords() -> [Word] {
        var words: [Word] = storageService.load(forKey: StorageKeys.words)
        if words.isEmpty {
            words = getDefaultWords()
            storageService.save(words, forKey: StorageKeys.words)
        }
        return words.map(enrichMetadata)
    }

    private func enrichMetadata(_ word: Word) -> Word {
        guard word.synonyms.isEmpty, word.exampleUsage.isEmpty else { return word }
        let meta = Self.metadataMap[word.text.lowercased()]
        return Word(
            id: word.id, text: word.text, category: word.category,
            difficulty: word.difficulty, isCommon: word.isCommon,
            synonyms: meta?.synonyms ?? [],
            frequency: meta?.frequency ?? (word.isCommon ? .common : .uncommon),
            letterDifficulty: meta?.letterDifficulty ?? letterDifficulty(for: word.text),
            exampleUsage: meta?.example ?? "A common \(word.category.displayName.lowercased()) word."
        )
    }

    private func letterDifficulty(for text: String) -> Int {
        let rare = Set(["q", "x", "z", "j"])
        let medium = Set(["k", "v", "w", "y"])
        for char in text.lowercased() {
            if rare.contains(String(char)) { return 5 }
            if medium.contains(String(char)) { return 3 }
        }
        return text.count > 7 ? 2 : 1
    }

    private struct WordMeta {
        let synonyms: [String]
        let frequency: WordFrequency
        let letterDifficulty: Int
        let example: String
    }

    private static let metadataMap: [String: WordMeta] = [
        "cat": .init(synonyms: ["feline", "kitten"], frequency: .common, letterDifficulty: 1, example: "The cat sat on the mat."),
        "dog": .init(synonyms: ["puppy", "hound"], frequency: .common, letterDifficulty: 1, example: "Walk the dog every evening."),
        "atom": .init(synonyms: ["particle"], frequency: .rare, letterDifficulty: 3, example: "An atom is the basic unit of matter."),
        "gene": .init(synonyms: ["DNA", "trait"], frequency: .rare, letterDifficulty: 4, example: "Each gene carries hereditary info."),
        "pizza": .init(synonyms: ["pie"], frequency: .common, letterDifficulty: 2, example: "We ordered pizza for dinner."),
        "tiger": .init(synonyms: ["big cat"], frequency: .uncommon, letterDifficulty: 2, example: "The tiger prowled silently."),
        "engine": .init(synonyms: ["motor"], frequency: .uncommon, letterDifficulty: 3, example: "The engine roared to life."),
        "garden": .init(synonyms: ["yard", "plot"], frequency: .common, letterDifficulty: 2, example: "Flowers bloom in the garden.")
    ]

    func getWords(for category: Category?) -> [Word] {
        let words = getWords()
        if let category {
            return words.filter { $0.category == category }
        }
        return words
    }

    func getRandomWords(count: Int, category: Category? = nil) -> [Word] {
        let words = getWords(for: category)
        return Array(words.shuffled().prefix(count))
    }

    func getWordPairs() -> [WordPair] {
        var pairs: [WordPair] = storageService.load(forKey: StorageKeys.wordPairs)
        if pairs.isEmpty {
            pairs = getDefaultWordPairs()
            storageService.save(pairs, forKey: StorageKeys.wordPairs)
        }
        return pairs
    }

    func addWordPair(_ pair: WordPair) {
        storageService.append(pair, forKey: StorageKeys.wordPairs)
    }

    func getDefaultWordPairs() -> [WordPair] {
        [
            WordPair(id: UUID(), startWord: "Cat", endWord: "Tiger", category: .animals, difficulty: .easy, solution: nil, isUsed: false, createdAt: Date()),
            WordPair(id: UUID(), startWord: "Dog", endWord: "Garden", category: .animals, difficulty: .medium, solution: nil, isUsed: false, createdAt: Date()),
            WordPair(id: UUID(), startWord: "Pizza", endWord: "Apple", category: .food, difficulty: .easy, solution: nil, isUsed: false, createdAt: Date()),
            WordPair(id: UUID(), startWord: "Paris", endWord: "School", category: .cities, difficulty: .medium, solution: nil, isUsed: false, createdAt: Date()),
            WordPair(id: UUID(), startWord: "Forest", endWord: "River", category: .nature, difficulty: .easy, solution: nil, isUsed: false, createdAt: Date()),
            WordPair(id: UUID(), startWord: "Phone", endWord: "Engine", category: .technology, difficulty: .medium, solution: nil, isUsed: false, createdAt: Date()),
            WordPair(id: UUID(), startWord: "Music", endWord: "Camera", category: .art, difficulty: .hard, solution: nil, isUsed: false, createdAt: Date()),
            WordPair(id: UUID(), startWord: "Doctor", endWord: "Robot", category: .professions, difficulty: .medium, solution: nil, isUsed: false, createdAt: Date())
        ]
    }

    func getDefaultWords() -> [Word] {
        [
            Word(id: UUID(), text: "Cat", category: .animals, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Dog", category: .animals, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Lion", category: .animals, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Tiger", category: .animals, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Bear", category: .animals, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Rabbit", category: .animals, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Wolf", category: .animals, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Eagle", category: .animals, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Snake", category: .animals, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Horse", category: .animals, difficulty: .easy, isCommon: true),

            Word(id: UUID(), text: "Pizza", category: .food, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Sushi", category: .food, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Soup", category: .food, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Salad", category: .food, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Pasta", category: .food, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Tea", category: .food, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Coffee", category: .food, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Apple", category: .food, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Egg", category: .food, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Grape", category: .food, difficulty: .easy, isCommon: true),

            Word(id: UUID(), text: "London", category: .cities, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Paris", category: .cities, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Tokyo", category: .cities, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Rome", category: .cities, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Oslo", category: .cities, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Miami", category: .cities, difficulty: .medium, isCommon: true),

            Word(id: UUID(), text: "Doctor", category: .professions, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Teacher", category: .professions, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Pilot", category: .professions, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Artist", category: .professions, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Chef", category: .professions, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Robot", category: .professions, difficulty: .medium, isCommon: true),

            Word(id: UUID(), text: "Forest", category: .nature, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Sea", category: .nature, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Mountain", category: .nature, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "River", category: .nature, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Desert", category: .nature, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Garden", category: .nature, difficulty: .easy, isCommon: true),

            Word(id: UUID(), text: "Internet", category: .technology, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Computer", category: .technology, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Phone", category: .technology, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Robot", category: .technology, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Tablet", category: .technology, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Engine", category: .technology, difficulty: .medium, isCommon: true),

            Word(id: UUID(), text: "Football", category: .sport, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Tennis", category: .sport, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Swimming", category: .sport, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Running", category: .sport, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Golf", category: .sport, difficulty: .easy, isCommon: true),

            Word(id: UUID(), text: "Music", category: .art, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Cinema", category: .art, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Painting", category: .art, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Dance", category: .art, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Camera", category: .art, difficulty: .medium, isCommon: true),

            Word(id: UUID(), text: "Atom", category: .science, difficulty: .hard, isCommon: false),
            Word(id: UUID(), text: "Gene", category: .science, difficulty: .hard, isCommon: false),
            Word(id: UUID(), text: "Star", category: .science, difficulty: .medium, isCommon: true),
            Word(id: UUID(), text: "Cell", category: .science, difficulty: .hard, isCommon: false),
            Word(id: UUID(), text: "Neuron", category: .science, difficulty: .hard, isCommon: false),

            Word(id: UUID(), text: "Key", category: .everyday, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Book", category: .everyday, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Lamp", category: .everyday, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Chair", category: .everyday, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "School", category: .everyday, difficulty: .easy, isCommon: true),
            Word(id: UUID(), text: "Light", category: .everyday, difficulty: .easy, isCommon: true)
        ]
    }
}
