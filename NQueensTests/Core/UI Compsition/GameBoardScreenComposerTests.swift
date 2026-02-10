import Testing
import SwiftUI
@testable import NQueens

@MainActor
struct GameBoardScreenComposerTests: Sendable {
    
    @Test func compose_buildsGameBoardViewWithExpectedGame() async throws {
        let game = NQueenGame(id: UUID(), size: 6, queens: [], mode: .medium, movesMade: 0)
        
        let view = GameBoardScreenComposer.compose(game: game)
        
        #expect(type(of: view) == GameBoardView.self)
    }
}

