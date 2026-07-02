import Foundation

struct ChainMoveExplanation: Identifiable, Hashable {
    let id = UUID()
    let fromWord: String
    let toWord: String
    let linkingLetter: String
    let reason: String
}

struct ChainAnalysis: Hashable {
    let moves: [ChainMoveExplanation]
    let alternativePaths: [[String]]
    let optimalChain: [String]?
    let playerChainLength: Int
    let optimalLength: Int?
    let efficiencyMessage: String

    static let empty = ChainAnalysis(
        moves: [],
        alternativePaths: [],
        optimalChain: nil,
        playerChainLength: 0,
        optimalLength: nil,
        efficiencyMessage: ""
    )
}
