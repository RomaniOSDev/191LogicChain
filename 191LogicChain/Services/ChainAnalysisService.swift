import Foundation

class ChainAnalysisService {
    private let chainEngine: ChainEngine

    init(chainEngine: ChainEngine) {
        self.chainEngine = chainEngine
    }

    func analyze(chain: [String], endWord: String, category: Category?, optimalSolution: [String]?) -> ChainAnalysis {
        var moves: [ChainMoveExplanation] = []
        for i in 0..<(chain.count - 1) {
            let from = chain[i]
            let to = chain[i + 1]
            let letter = from.last.map { String($0).lowercased() } ?? "?"
            moves.append(ChainMoveExplanation(
                fromWord: from,
                toWord: to,
                linkingLetter: letter,
                reason: "'\(to)' starts with '\(letter)' — valid letter link from '\(from)'"
            ))
        }

        let optimal = optimalSolution ?? chainEngine.findShortestChain(
            from: chain.first ?? "",
            to: endWord,
            category: category,
            maxDepth: 8
        )

        let alternatives = chainEngine.findAlternativePaths(
            from: chain.first ?? "",
            to: endWord,
            category: category,
            limit: 3,
            maxDepth: 7
        ).filter { $0 != chain }

        let playerLen = chain.count
        let optimalLen = optimal?.count
        let efficiency: String
        if let optimalLen, playerLen == optimalLen {
            efficiency = "Perfect! You found the shortest possible chain."
        } else if let optimalLen, playerLen <= optimalLen + 1 {
            efficiency = "Excellent — only 1 word longer than optimal (\(optimalLen) words)."
        } else if let optimalLen {
            efficiency = "Optimal chain uses \(optimalLen) words. Yours used \(playerLen)."
        } else {
            efficiency = "Keep exploring — shorter paths may exist!"
        }

        return ChainAnalysis(
            moves: moves,
            alternativePaths: alternatives,
            optimalChain: optimal,
            playerChainLength: playerLen,
            optimalLength: optimalLen,
            efficiencyMessage: efficiency
        )
    }
}
