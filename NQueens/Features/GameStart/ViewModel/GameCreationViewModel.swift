import Observation
import Foundation

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
    
    var game: NQueenGame
    var gameStarted: Bool = false
    var error: Error?

    init() {
        self.game = .init(id: .init(), size: 4, queens: [])
    }
    
    var availableSizes: [Int] {
        Array(4...25)
    }
    
    func descriptionText() -> String {
        "Place \(game.size) queens on an \(game.size)×\(game.size) chessboard so that no two queens threaten each other. Queens cannot share the same row, column, or diagonal."
    }
}
