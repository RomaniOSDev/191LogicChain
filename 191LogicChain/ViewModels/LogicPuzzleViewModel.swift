import Combine
import SwiftUI

@MainActor
class LogicPuzzleViewModel: ObservableObject {
    @Published var levels: [LogicPuzzleLevel] = []

    private let coordinator: AppCoordinator
    private let puzzleService: PuzzleService

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.puzzleService = coordinator.puzzleService
        load()
    }

    func load() { levels = puzzleService.getLevels() }

    func play(_ level: LogicPuzzleLevel) {
        var config = GamePlayConfig()
        config.puzzleLevelId = level.id
        config.constraints = level.constraints
        config.optimalSolution = level.optimalSolution
        config.maxSteps = level.constraints.maxSteps
        config.requiredWord = level.constraints.requiredWord
        config.forbidRepeatedLetters = level.constraints.forbidRepeatedLetters

        coordinator.navigateToGame(
            mode: .logicPuzzle,
            startWord: level.startWord,
            endWord: level.endWord,
            category: level.category,
            difficulty: level.difficulty,
            config: config
        )
    }

    func goBack() { coordinator.pop() }
}
