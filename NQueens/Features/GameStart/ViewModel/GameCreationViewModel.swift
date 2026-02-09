import Observation
import NQueenEngine

@Observable
final class GameCreationViewModel {
    
    enum Constants {
        static let title = "N-Queens"
        static let setupSectionTitle = "Game setup"
        static let boardSizeLabel = "Board size"
        static let descriptionSectionTitle = "Description"
        static let errorSectionTitle = "Error"
        static let startButtonTitle = "Start"
    }
    
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
    
    func descriptionText(for size: Int) -> String {
        "Place \(size) queens on an \(size)×\(size) chessboard so that no two queens threaten each other. Queens cannot share the same row, column, or diagonal."
    }
}

