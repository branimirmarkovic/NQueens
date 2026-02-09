import Observation
import Foundation

@Observable
final class GameCreationViewModel {
    
    enum Constants {
        static let title = "N-Queens"
        static let setupSectionTitle = "Game setup"
        static let boardSizeLabel = "Board size"
        static let difficultySectionTitle = "Difficulty"
        static let difficultyLabel = "Mode"
        static let descriptionSectionTitle = "Description"
        static let errorSectionTitle = "Error"
        static let startButtonTitle = "Start"
    }
    
    var game: NQueenGame
    var gameStarted: Bool = false
    var error: Error?

    init() {
        let defaultSize = 4
        let defaultMode: GameMode = .easy
        let defaultMaxActions = GameCreationViewModel.actionLimit(for: defaultSize, mode: defaultMode)
        self.game = .init(id: .init(), size: defaultSize, queens: [], mode: defaultMode, maxActions: defaultMaxActions)
    }
    
    var availableSizes: [Int] {
        Array(4...25)
    }
    
    var availableModes: [GameMode] {
        GameMode.allCases
    }
    
    func updateActionLimit() {
        game.maxActions = Self.actionLimit(for: game.size, mode: game.mode)
    }
    
    func modeTitle(_ mode: GameMode) -> String {
        switch mode {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }
    
    func modeDescription(_ mode: GameMode) -> String {
        let limit = Self.actionLimit(for: game.size, mode: mode)
        switch mode {
        case .easy:
            return "Shows available fields and prevents conflicting moves."
        case .medium:
            return "Shows conflicting queens. Available fields are hidden and conflicting moves are allowed."
        case .hard:
            if let limit {
                return "No visual hints. Action limit: \(limit)."
            }
            return "No visual hints."
        }
    }
    
    func descriptionText() -> String {
        "Place \(game.size) queens on an \(game.size)×\(game.size) chessboard so that no two queens threaten each other. Queens cannot share the same row, column, or diagonal."
    }
    
    private static func actionLimit(for size: Int, mode: GameMode) -> Int? {
        switch mode {
        case .easy:
            return nil
        case .medium:
            return nil
        case .hard:
            return size * 3
        }
    }
}
