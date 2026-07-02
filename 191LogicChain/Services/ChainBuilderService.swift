import Foundation

class ChainBuilderService {
    private let storageService: StorageServiceProtocol
    private let chainEngine: ChainEngine

    init(storageService: StorageServiceProtocol, chainEngine: ChainEngine) {
        self.storageService = storageService
        self.chainEngine = chainEngine
    }

    func getChains() -> [CustomChain] {
        storageService.load(forKey: StorageKeys.customChains)
    }

    func saveChain(_ chain: CustomChain) {
        var chains = getChains()
        if let index = chains.firstIndex(where: { $0.id == chain.id }) {
            chains[index] = chain
        } else {
            chains.append(chain)
        }
        storageService.save(chains, forKey: StorageKeys.customChains)
    }

    func deleteChain(id: UUID) {
        var chains = getChains()
        chains.removeAll { $0.id == id }
        storageService.save(chains, forKey: StorageKeys.customChains)
    }

    func incrementPlayCount(id: UUID) {
        var chains = getChains()
        if let index = chains.firstIndex(where: { $0.id == id }) {
            chains[index].timesPlayed += 1
            storageService.save(chains, forKey: StorageKeys.customChains)
        }
    }

    func validatePair(start: String, end: String) -> String? {
        guard chainEngine.getWord(from: start) != nil else { return "Start word not in dictionary" }
        guard chainEngine.getWord(from: end) != nil else { return "End word not in dictionary" }
        guard start.lowercased() != end.lowercased() else { return "Start and end must differ" }
        return nil
    }
}
