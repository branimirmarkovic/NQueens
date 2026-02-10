import Testing
import Foundation
@testable import NQueens

@MainActor
struct BoardModelSynchronizerTests: Sendable {
    
    @Test func createSynchronizedBoard_easyMode_highlightsAvailablePositions() async throws {
        let available = [
            GamePosition(row: 0, column: 1),
            GamePosition(row: 1, column: 1)
        ]
        let queens = [GamePosition(row: 0, column: 0)]
        let sut = makeController(
            size: 4,
            mode: .easy,
            available: available,
            conflicts: [],
            queens: queens
        )
        
        let board = BoardModelSynchronizer.createSynchronizedBoard(with: sut)
        
        #expect(board[0][0].hasQueen == true)
        #expect(board[0][1].isFreeToPlace == true)
        #expect(board[1][1].isFreeToPlace == true)
        #expect(board[2][2].isFreeToPlace == false)
        #expect(board[0][1].isConflicting == false)
    }
    
    @Test func createSynchronizedBoard_easyMode_whenAllAvailable_doesNotHighlight() async throws {
        let all = allPositions(size: 4)
        let sut = makeController(
            size: 4,
            mode: .easy,
            available: all,
            conflicts: [],
            queens: []
        )
        
        let board = BoardModelSynchronizer.createSynchronizedBoard(with: sut)
        let anyHighlighted = board.flatMap { $0 }.contains { $0.isFreeToPlace }
        
        #expect(anyHighlighted == false)
    }
    
    @Test func createSynchronizedBoard_mediumMode_marksConflictsOnly() async throws {
        let conflicts = [GamePosition(row: 2, column: 2)]
        let sut = makeController(
            size: 4,
            mode: .medium,
            available: [],
            conflicts: conflicts,
            queens: []
        )
        
        let board = BoardModelSynchronizer.createSynchronizedBoard(with: sut)
        
        #expect(board[2][2].isConflicting == true)
        #expect(board[2][2].isFreeToPlace == false)
    }
    
    @Test func createSynchronizedBoard_hardMode_hasNoHints() async throws {
        let sut = makeController(
            size: 4,
            mode: .hard,
            available: [GamePosition(row: 0, column: 1)],
            conflicts: [GamePosition(row: 2, column: 2)],
            queens: []
        )
        
        let board = BoardModelSynchronizer.createSynchronizedBoard(with: sut)
        let anyHighlighted = board.flatMap { $0 }.contains { $0.isFreeToPlace }
        let anyConflicting = board.flatMap { $0 }.contains { $0.isConflicting }
        
        #expect(anyHighlighted == false)
        #expect(anyConflicting == false)
    }
    
    private func makeController(
        size: Int,
        mode: GameMode,
        available: [GamePosition],
        conflicts: [GamePosition],
        queens: [GamePosition]
    ) -> GameControllerStub {
        let game = NQueenGame(id: UUID(), size: size, queens: [], mode: mode, movesMade: nil)
        return GameControllerStub(
            boardSize: size,
            game: game,
            availablePositionsValue: available,
            conflictingPositionsValue: conflicts,
            queensPlacedValue: queens,
            queensRemainingValue: size - queens.count
        )
    }
    
    private func allPositions(size: Int) -> [GamePosition] {
        (0..<size).flatMap { row in
            (0..<size).map { column in
                GamePosition(row: row, column: column)
            }
        }
    }
}

private final class GameControllerStub: GameController {
    var boardSize: Int
    var game: NQueenGame
    var availablePositionsValue: [GamePosition]
    var conflictingPositionsValue: [GamePosition]
    var queensPlacedValue: [GamePosition]
    var queensRemainingValue: Int
    
    init(
        boardSize: Int,
        game: NQueenGame,
        availablePositionsValue: [GamePosition],
        conflictingPositionsValue: [GamePosition],
        queensPlacedValue: [GamePosition],
        queensRemainingValue: Int
    ) {
        self.boardSize = boardSize
        self.game = game
        self.availablePositionsValue = availablePositionsValue
        self.conflictingPositionsValue = conflictingPositionsValue
        self.queensPlacedValue = queensPlacedValue
        self.queensRemainingValue = queensRemainingValue
    }
    
    func toggle(_ position: GamePosition) throws {}
    func availablePositions() -> [GamePosition] { availablePositionsValue }
    func conflictingPositions() -> [GamePosition] { conflictingPositionsValue }
    func queensPlaced() -> [GamePosition] { queensPlacedValue }
    func queensRemaining() -> Int { queensRemainingValue }
    func startGame() throws {}
    func resetGame() throws {}
}
