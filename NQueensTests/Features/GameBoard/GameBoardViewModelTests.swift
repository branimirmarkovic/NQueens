import Testing
import Foundation
@testable import NQueens

@MainActor
struct GameBoardViewModelTests: Sendable {
    
    @Test func startGame_transitionsToOngoing_andCallsStart() async throws {
        let controller = makeGameController()
        let sut = makeSUT(gameController: controller)
        
        sut.startGame()
        
        #expect(sut.gameState == .ongoing)
        #expect(controller.startCalled == true)
    }
    
    @Test func startGame_whenStartThrows_setsPlacementError() async throws {
        let controller = makeGameController(startError: BoardPlacementError.conflicts)
        let sut = makeSUT(gameController: controller)
        
        sut.startGame()
        
        #expect(sut.placementError?.error == .unknown)
    }
    
    @Test func tap_whenToggleThrows_setsPlacementError() async throws {
        let controller = makeGameController(toggleError: BoardPlacementError.conflicts)
        let sut = makeSUT(gameController: controller)
        let position = BoardPosition(row: 0, column: 0, hasQueen: false, isFreeToPlace: false, isConflicting: false)
        
        sut.tap(at: position)
        
        #expect(sut.placementError?.error == .conflicts)
    }
    
    @Test(arguments: [
        (BoardPlacementError.invalidPosition, "Invalid position selected."),
        (BoardPlacementError.positionOccupied, "This position is already occupied by a queen."),
        (BoardPlacementError.conflicts, "Placing a queen here would cause a conflict with another queen."),
        (BoardPlacementError.noQueensRemaining, "No queens remaining to place.")
    ]) func tap_whenToggleThrows_setsPlacementErrorMessage(error: BoardPlacementError, expectedMessage: String) async throws {
        let controller = makeGameController(toggleError: error)
        let sut = makeSUT(gameController: controller)
        let position = BoardPosition(row: 0, column: 0, hasQueen: false, isFreeToPlace: false, isConflicting: false)
        
        sut.tap(at: position)
        
        #expect(sut.placementError?.message == expectedMessage)
    }
    
    @Test func tap_whenToggleThrowsUnknownError_setsUnknownMessage() async throws {
        let controller = makeGameController(toggleError: DummyError())
        let sut = makeSUT(gameController: controller)
        let position = BoardPosition(row: 0, column: 0, hasQueen: false, isFreeToPlace: false, isConflicting: false)
        
        sut.tap(at: position)
        
        #expect(sut.placementError?.error == .unknown)
        #expect(sut.placementError?.message == "An unknown error occurred.")
    }
    
    @Test func tap_inHardMode_incrementsMovesMade() async throws {
        let game = NQueenGame(id: UUID(), size: 4, queens: [], mode: .hard, movesMade: 0)
        let controller = makeGameController(game: game)
        let sut = makeSUT(gameController: controller)
        let position = BoardPosition(row: 0, column: 0, hasQueen: false, isFreeToPlace: false, isConflicting: false)
        
        sut.tap(at: position)
        
        #expect(controller.game.movesMade == 1)
    }
    
    @Test func tap_whenWinConditionsMet_setsGameStateWon() async throws {
        let controller = makeGameController(
            mode: .easy,
            remainingQueens: 0,
            conflicting: []
        )
        let sut = makeSUT(gameController: controller)
        let position = BoardPosition(row: 0, column: 0, hasQueen: false, isFreeToPlace: false, isConflicting: false)
        
        sut.tap(at: position)
        
        #expect(sut.gameState == .won)
    }
    
    @Test func tap_whenMovesExceedLimit_setsGameStateLost() async throws {
        let game = NQueenGame(id: UUID(), size: 4, queens: [], mode: .hard, movesMade: 8)
        let controller = makeGameController(game: game)
        let sut = makeSUT(gameController: controller)
        let position = BoardPosition(row: 0, column: 0, hasQueen: false, isFreeToPlace: false, isConflicting: false)
        
        sut.tap(at: position)
        
        #expect(sut.gameState == .lost)
    }
    
    @Test func movesLeftTitle_whenNotHard_returnsEmptyString() async throws {
        let controller = makeGameController(mode: .easy)
        let sut = makeSUT(gameController: controller)
        
        #expect(sut.movesLeftTitle.isEmpty == true)
    }
    
    @Test func movesLeftTitle_whenHard_returnsRemainingMoves() async throws {
        let game = NQueenGame(id: UUID(), size: 4, queens: [], mode: .hard, movesMade: 3)
        let controller = makeGameController(game: game)
        let sut = makeSUT(gameController: controller)
        
        #expect(sut.movesLeftTitle == "Moves left: 5")
    }
    
    @Test func remainingQueensTitle_returnsExpectedText() async throws {
        let controller = makeGameController(remainingQueens: 2)
        let sut = makeSUT(gameController: controller)
        
        #expect(sut.remainingQueensTitle == "Remaining queens: 2")
    }
    
    @Test func boardSize_returnsControllerBoardSize() async throws {
        let controller = makeGameController(size: 7)
        let sut = makeSUT(gameController: controller)
        
        #expect(sut.boardSize == 7)
    }

    @Test func resetGame_callsController_andSetsOngoingState() async throws {
        let controller = makeGameController()
        let sut = makeSUT(gameController: controller)
        sut.gameState = .won
        
        sut.resetGame()
        
        #expect(controller.resetCalled == true)
        #expect(sut.gameState == .ongoing)
    }
    
    @Test func resetGame_whenResetThrows_setsPlacementError() async throws {
        let controller = makeGameController(resetError: BoardPlacementError.noQueensRemaining)
        let sut = makeSUT(gameController: controller)
        
        sut.resetGame()
        
        #expect(sut.placementError?.error == .unknown)
    }
    
    @Test func constants_haveExpectedValues() async throws {
        #expect(GameBoardViewModel.Constants.title == "Board")
        #expect(GameBoardViewModel.Constants.availablePositionsTitle == "Available positions")
        #expect(GameBoardViewModel.Constants.resetButtonTitle == "Reset")
        #expect(GameBoardViewModel.Constants.placementErrorTitle == "Placement error")
        #expect(GameBoardViewModel.Constants.winingTitle == "Congratulations!")
        #expect(GameBoardViewModel.Constants.loosingTitle == "Game Over")
        #expect(GameBoardViewModel.Constants.winningMessage == "You solved the puzzle.")
        #expect(GameBoardViewModel.Constants.loosingMessage == "You have exceeded the maximum number of moves allowed.")
        #expect(GameBoardViewModel.Constants.playAgainTitle == "Play again")
        #expect(GameBoardViewModel.Constants.chooseBoardTitle == "Choose different board")
    }
    
    @Test func constants_gameEndTitle_returnsExpectedValue() async throws {
        #expect(GameBoardViewModel.Constants.gameEndTitle(gameSolved: true) == "Congratulations!")
        #expect(GameBoardViewModel.Constants.gameEndTitle(gameSolved: false) == "Game Over")
    }
    
    @Test func constants_gameEndMessage_returnsExpectedValue() async throws {
        #expect(GameBoardViewModel.Constants.gameEndMessage(gameSolved: true) == "You solved the puzzle.")
        #expect(GameBoardViewModel.Constants.gameEndMessage(gameSolved: false) == "You have exceeded the maximum number of moves allowed.")
    }
    typealias SUT = GameBoardViewModel
    private func makeSUT(gameController: GameController) -> SUT {
        return .init(gameController: gameController)
    }
    
    private func makeGameController(
        size: Int = 4,
        mode: GameMode = .easy,
        remainingQueens: Int = 4,
        conflicting: [GamePosition] = [],
        available: [GamePosition] = [],
        queens: [GamePosition] = [],
        game: NQueenGame? = nil,
        toggleError: Error? = nil,
        startError: Error? = nil,
        resetError: Error? = nil
    ) -> GameControllerStub {
        let gameValue = game ?? NQueenGame(id: UUID(), size: size, queens: queens, mode: mode, movesMade: 0)
        return GameControllerStub(
            boardSize: size,
            game: gameValue,
            availablePositionsValue: available,
            conflictingPositionsValue: conflicting,
            queensPlacedValue: queens,
            queensRemainingValue: remainingQueens,
            toggleError: toggleError,
            startError: startError,
            resetError: resetError
        )
    }
}

private final class GameControllerStub: GameController {
    var boardSize: Int
    var game: NQueenGame
    var availablePositionsValue: [GamePosition]
    var conflictingPositionsValue: [GamePosition]
    var queensPlacedValue: [GamePosition]
    var queensRemainingValue: Int
    var toggleError: Error?
    var startError: Error?
    var resetError: Error?
    var startCalled = false
    var resetCalled = false
    
    init(
        boardSize: Int,
        game: NQueenGame,
        availablePositionsValue: [GamePosition],
        conflictingPositionsValue: [GamePosition],
        queensPlacedValue: [GamePosition],
        queensRemainingValue: Int,
        toggleError: Error?,
        startError: Error?,
        resetError: Error?
    ) {
        self.boardSize = boardSize
        self.game = game
        self.availablePositionsValue = availablePositionsValue
        self.conflictingPositionsValue = conflictingPositionsValue
        self.queensPlacedValue = queensPlacedValue
        self.queensRemainingValue = queensRemainingValue
        self.toggleError = toggleError
        self.startError = startError
        self.resetError = resetError
    }
    
    func toggle(_ position: GamePosition) throws {
        if let toggleError { throw toggleError }
    }
    
    func availablePositions() -> [GamePosition] { availablePositionsValue }
    func conflictingPositions() -> [GamePosition] { conflictingPositionsValue }
    func queensPlaced() -> [GamePosition] { queensPlacedValue }
    func queensRemaining() -> Int { queensRemainingValue }
    
    func startGame() throws {
        startCalled = true
        if let startError { throw startError }
    }
    
    func resetGame() throws {
        resetCalled = true
        if let resetError { throw resetError }
    }
}

private struct DummyError: Error {}
