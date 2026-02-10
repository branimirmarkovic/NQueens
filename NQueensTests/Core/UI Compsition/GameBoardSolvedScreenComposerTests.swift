import Testing
import SwiftUI
@testable import NQueens

@MainActor
struct GameBoardSolvedScreenComposerTests: Sendable {
    
    @Test func compose_buildsSolvedView() async throws {
        let controller = GameControllerStub(
            game: NQueenGame(id: UUID(), size: 4, queens: [], mode: .easy, movesMade: 0)
        )
        let viewModel = GameBoardViewModel(gameController: controller)
        
        let view = GameBoardSolvedScreenComposer.compose(viewModel: viewModel)
        
        #expect(type(of: view) == GameBoardSolvedView.self)
    }
}

private final class GameControllerStub: GameController {
    var boardSize: Int
    var game: NQueenGame
    
    init(game: NQueenGame) {
        self.game = game
        self.boardSize = game.size
    }
    
    func toggle(_ position: GamePosition) throws {}
    func availablePositions() -> [GamePosition] { [] }
    func conflictingPositions() -> [GamePosition] { [] }
    func queensPlaced() -> [GamePosition] { [] }
    func queensRemaining() -> Int { game.size }
    func startGame() throws {}
    func resetGame() throws {}
}
