//
//  GameBoardViewModel.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import Foundation
import Observation


@Observable
final class GameBoardViewModel {
    
    typealias BoardModel = [[BoardPosition]]
    typealias BoardPlacementErrorDescription = (error: BoardPlacementError, message: String)
    
    enum GameState {
        case notStarted
        case ongoing
        case won
        case lost
    }
    
    var board: BoardModel
    var placementError: BoardPlacementErrorDescription?
    var gameState: GameState = .notStarted
    var remainingQueens: Int
    var movesLeft: Int?
    
    @ObservationIgnored private(set) var gameController: GameController
    @ObservationIgnored private let boardModelSynchronizer = BoardModelSynchronizer.self
    @ObservationIgnored private let gameWinChecker = GameWinChecker.self
    @ObservationIgnored private var errorResetTask: Task<Void, Never>?
    @ObservationIgnored private var errorToken = UUID()
    
    init(
        gameController: GameController,
    ) {
        self.gameController = gameController
        self.board = boardModelSynchronizer.createSynchronizedBoard(with: gameController)
        self.remainingQueens = gameController.queensRemaining()
        self.movesLeft = Self.computeMovesLeft(for: gameController)
    }
    
    func startGame() {
        guard gameState == .notStarted else { return }
        do {
            clearPlacementError()
            try gameController.startGame()
            synchronizeBoard()
            gameState = .ongoing
        } catch {
            setPlacementError(.uknown)
        }
    }
    
    func tap(at position: BoardPosition) {
        do {
            try gameController.toggle(position.toGamePosition())
            addMoveToCounter()
            synchronizeBoard()
            checkGameConditions()
        } catch let error as BoardPlacementError {
            setPlacementError(error)
        } catch {
            setPlacementError(.uknown)
        }
    }
    
    func resetGame() {
        do {
            clearPlacementError()
            try gameController.resetGame()
            synchronizeBoard()
            gameState = .ongoing
        } catch {
            setPlacementError(.uknown)
        }
    }
    
    var movesLeftTitle: String {
        guard let movesLeft else { return "" }
        return "Moves left: \(movesLeft)"
    }
    
    var boardSize: Int { gameController.boardSize }
    
    var remainingQueensTitle: String {
        "Remaining queens: \(remainingQueens)"
    }
    
    private func schedulePlacementErrorClear() {
        errorResetTask?.cancel()
        let token = UUID()
        errorToken = token
        errorResetTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await MainActor.run {
                guard let self, self.errorToken == token else { return }
                self.placementError = nil
            }
        }
    }
    
    private func setPlacementError(_ error: BoardPlacementError) {
        placementError = (error, message(for: error))
        schedulePlacementErrorClear()
    }
    
    private func clearPlacementError() {
        errorResetTask?.cancel()
        placementError = nil
    }
    
    private func synchronizeBoard() {
        board = boardModelSynchronizer.createSynchronizedBoard(with: gameController)
        refreshCounters()
    }
    
    private func checkGameConditions() {
        if gameWinChecker.isGameOver(gameMode: gameController.game.mode, movesMade: gameController.game.movesMade, maxActions: gameController.game.maxActions)
        {    gameState = .lost }
        else if gameWinChecker.isGameSolved(remainingQueens: gameController.queensRemaining(), conflictingPositions: Set(gameController.conflictingPositions())) {
            gameState = .won
        }
    }
    
    private func addMoveToCounter() {
        guard gameController.game.mode == .hard else { return }
        gameController.game.movesMade? += 1
    }

    private func refreshCounters() {
        remainingQueens = gameController.queensRemaining()
        movesLeft = Self.computeMovesLeft(for: gameController)
    }

    private static func computeMovesLeft(for gameController: GameController) -> Int? {
        guard gameController.game.mode == .hard,
              let maxActions = gameController.game.maxActions,
              let movesCounter = gameController.game.movesMade else { return nil }
        return maxActions - movesCounter
    }
    
    private func message(for error: BoardPlacementError) -> String {
        switch error {
        case .invalidPosition:
            return "Invalid position selected."
        case .positionOccupied:
            return "This position is already occupied by a queen."
        case .conflicts:
            return "Placing a queen here would cause a conflict with another queen."
        case .noQueensRemaining:
            return "No queens remaining to place."
        case .uknown:
            return "An unknown error occurred."
        }
    }
}

extension GameBoardViewModel {
    enum Constants {
        static let title = "Board"
        static let availablePositionsTitle = "Available positions"
        static let resetButtonTitle = "Reset"
        static let placementErrorTitle = "Placement error"
        
        static let winingTitle = "Congratulations!"
        static let loosingTitle = "Game Over"
        
        static let loosingMessage = "You have exceeded the maximum number of moves allowed."
        static let winningMessage = "You solved the puzzle."
        static let playAgainTitle = "Play again"
        static let chooseBoardTitle = "Choose different board"
        
        static func gameEndTitle(gameSolved: Bool) -> String {
            gameSolved ? winingTitle : loosingTitle
        }
        
        static func gameEndMessage(gameSolved: Bool) -> String {
            gameSolved ? winningMessage : loosingMessage
        }
    }
}

extension BoardPosition {
    func toGamePosition() -> GamePosition {
        .init(row: row, column: column)
    }
}
