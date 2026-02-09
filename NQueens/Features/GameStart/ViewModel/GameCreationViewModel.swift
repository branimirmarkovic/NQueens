import Observation
import NQueenEngine

@Observable
final class GameCreationViewModel {
    var boardSize: Int = 3
    var gameStarted: Bool = false
    var error: Error?
    private let gameEngine: GameEngine
    
    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
    }

    func startGame() {
        do {
            try gameEngine.startGame(size: boardSize, queens: [])
        } catch {
            self.error = error
        }
    }
    
    var availableSizes: [Int] {
        Array(3...25)
    }
    
    var gameRules: String {
        "Place N queens on an N×N chessboard so that no two queens threaten each other. Queens cannot share the same row, column, or diagonal."
    }
}

