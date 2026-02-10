import Testing
import Foundation
@testable import NQueens

@MainActor
struct NQueenEngineControllerTests: Sendable {
    
    @Test func init_doesNotStartEngine() async throws {
        let game = makeGame(size: 4, queens: [], mode: .easy)
        let sut = NQueenEngineController(game: game)
        
        #expect(sut.boardSize == 0)
        #expect(sut.queensRemaining() == 0)
        #expect(sut.queensPlaced().isEmpty)
        #expect(sut.availablePositions().isEmpty)
        #expect(sut.conflictingPositions().isEmpty)
    }
    
    @Test func startGame_initializesEngineWithQueens() async throws {
        let queens = [GamePosition(row: 0, column: 0), GamePosition(row: 1, column: 2)]
        let game = makeGame(size: 4, queens: queens, mode: .easy)
        let sut = NQueenEngineController(game: game)
        
        try sut.startGame()
        
        #expect(sut.boardSize == 4)
        #expect(Set(sut.queensPlaced()) == Set(queens))
        #expect(sut.queensRemaining() == 2)
    }
    
    @Test func toggle_beforeStartGame_throws() async throws {
        let game = makeGame(size: 4, queens: [], mode: .easy)
        let sut = NQueenEngineController(game: game)
        
        var didThrow = false
        do {
            try sut.toggle(GamePosition(row: 0, column: 0))
        } catch {
            didThrow = true
        }
        
        #expect(didThrow == true)
    }
    
    @Test func toggle_inEasyMode_conflictThrows() async throws {
        let queens = [GamePosition(row: 0, column: 0)]
        let game = makeGame(size: 4, queens: queens, mode: .easy)
        let sut = NQueenEngineController(game: game)
        try sut.startGame()
        
        #expect(throws: BoardPlacementError.conflicts) {
            try sut.toggle(GamePosition(row: 1, column: 1))
        }
    }
    
    @Test func toggle_inMediumMode_allowsConflicts() async throws {
        let queens = [GamePosition(row: 0, column: 0)]
        let game = makeGame(size: 4, queens: queens, mode: .medium)
        let sut = NQueenEngineController(game: game)
        try sut.startGame()
        
        try sut.toggle(GamePosition(row: 1, column: 1))
        
        #expect(Set(sut.queensPlaced()) == Set(queens + [GamePosition(row: 1, column: 1)]))
    }
    
    @Test func resetGame_recreatesEngineWithInitialQueens() async throws {
        let initialQueens = [GamePosition(row: 0, column: 0)]
        let game = makeGame(size: 4, queens: initialQueens, mode: .easy)
        let sut = NQueenEngineController(game: game)
        try sut.startGame()
        
        try sut.toggle(GamePosition(row: 1, column: 2))
        #expect(sut.queensPlaced().count == 2)
        
        try sut.resetGame()
        
        #expect(Set(sut.queensPlaced()) == Set(initialQueens))
    }

    @Test func availablePositions_excludesOccupiedAndConflicts() async throws {
        let queen = GamePosition(row: 0, column: 0)
        let game = makeGame(size: 4, queens: [queen], mode: .easy)
        let sut = NQueenEngineController(game: game)
        try sut.startGame()

        let result = Set(sut.availablePositions())

        let expected: Set<GamePosition> = [
            GamePosition(row: 1, column: 2),
            GamePosition(row: 1, column: 3),
            GamePosition(row: 2, column: 1),
            GamePosition(row: 2, column: 3),
            GamePosition(row: 3, column: 1),
            GamePosition(row: 3, column: 2)
        ]
        #expect(result == expected)
    }
    
    @Test func conflictingPositions_returnsOnlyConflictingQueens() async throws {
        let conflictA = GamePosition(row: 0, column: 0)
        let conflictB = GamePosition(row: 0, column: 3)
        let safe = GamePosition(row: 3, column: 1)
        let game = makeGame(size: 4, queens: [conflictA, conflictB, safe], mode: .medium)
        let sut = NQueenEngineController(game: game)
        try sut.startGame()
        
        let result = Set(sut.conflictingPositions())
        
        #expect(result == Set([conflictA, conflictB]))
    }
    
    private func makeGame(size: Int, queens: [GamePosition], mode: GameMode) -> NQueenGame {
        NQueenGame(id: UUID(), size: size, queens: queens, mode: mode, movesMade: 0)
    }
}
