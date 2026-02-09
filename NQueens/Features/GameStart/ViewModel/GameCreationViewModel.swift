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

    func startGame() {
    }
    
    var availableSizes: [Int] {
        Array(3...25)
    }
    
    func descriptionText() -> String {
        "Place \(boardSize) queens on an \(boardSize)×\(boardSize) chessboard so that no two queens threaten each other. Queens cannot share the same row, column, or diagonal."
    }
}

