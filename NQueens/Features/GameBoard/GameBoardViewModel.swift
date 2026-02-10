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
    
    var board: [[BoardPosition]]
    var remainingQueens: Int
    var placementError: BoardPlacementError?
    var gameSolved: Bool = false
    var gameOver: Bool = false
    @ObservationIgnored private var hasStarted = false
    @ObservationIgnored private(set) var gameEngine: GameController
    @ObservationIgnored private var movesCounter: Int = 0
    
    init(
        gameEngine: GameController,
    ) {
        self.gameEngine = gameEngine
        self.board = BoardMapper.createBoard(from: gameEngine)
        self.remainingQueens = gameEngine.queensRemaining()
    }
    
    func startGame() {
        guard hasStarted == false else { return } 
        do {
            resetSolvedState()
            try gameEngine.startGame()
            refresh()
            hasStarted = true
        } catch {
            placementError = .uknown
        }
    }
    
    func tap(at position: BoardPosition) {
        do {
            try gameEngine.toggle(position.toGamePosition())
            movesCounter += 1
            refresh()
            checkIfSolved()
            checkIfGameOver()
        } catch let error as BoardPlacementError {
            self.placementError = error
        } catch {
            self.placementError = .uknown
        }
    }
    
    func resetGame() {
        do {
            resetSolvedState()
            try gameEngine.resetGame()
            refresh()
        } catch {
            placementError = .uknown
        }
    }
    
    func refresh() {
        let availablePositions = Set(gameEngine.availablePositions())
        let conflictingPositions = Set(gameEngine.conflictingPositions())
        remainingQueens = gameEngine.queensRemaining()

        var newBoard = BoardMapper.createBoard(from: gameEngine)
        if gameEngine.game.mode == .easy {
            applyHighlights(to: &newBoard, available: availablePositions)
        }
        if gameEngine.game.mode == .medium {
            applyConflicts(to: &newBoard, conflicts: conflictingPositions)
        }

        board = newBoard
    }

    private func applyHighlights(to board: inout [[BoardPosition]], available: Set<GamePosition>) {
        let shouldHighlight = shouldHighlightAvailablePositions(available, in: board)
        for row in board.indices {
            for column in board[row].indices {
                let position = GamePosition(row: row, column: column)
                board[row][column].isFreeToPlace = shouldHighlight && available.contains(position)
            }
        }
    }

    private func shouldHighlightAvailablePositions(_ available: Set<GamePosition>, in board: [[BoardPosition]]) -> Bool {
        let totalPositions = board.count * (board.first?.count ?? 0)
        return !available.isEmpty && available.count < totalPositions
    }
    
    private func applyConflicts(to board: inout [[BoardPosition]], conflicts: Set<GamePosition>) {
        for row in board.indices {
            for column in board[row].indices {
                let position = GamePosition(row: row, column: column)
                board[row][column].isConflicting = conflicts.contains(position)
            }
        }
    }
    
    private func checkIfSolved() {
        let conflictingPositions = Set(gameEngine.conflictingPositions())
        let isSolved = remainingQueens == 0 && gameEngine.boardSize > 0 && conflictingPositions.isEmpty
        if isSolved && gameSolved == false {
            gameSolved = true
        } else if isSolved == false {
            gameSolved = false
        }
    }
    
    private func checkIfGameOver() {
        guard gameEngine.game.mode == .hard,
        let maxActions = gameEngine.game.maxActions else { return }
        if movesCounter >  maxActions {
            gameOver = true
        }
    }
    
    private func resetSolvedState() {
        gameSolved = false
        gameOver = false
    }
    
    func message(for error: BoardPlacementError) -> String {
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
    
    var boardSize: Int { gameEngine.boardSize }

    
    func remainingQueens(_ count: Int) -> String { "Remaining queens: \(count)" }
}

struct BoardMapper{
    static func createBoard(from engine: GameController) -> [[BoardPosition]] {
        let board = (0..<engine.boardSize).map { row in
            (0..<engine.boardSize).map { column in
                let hasQueen = engine.queensPlaced().contains(where: { $0.row == row && $0.column == column })
                return BoardPosition(row: row, column: column, hasQueen: hasQueen, isFreeToPlace: false, isConflicting: false)
            }
        }
        return board
    }
}

extension BoardPosition {
    func toGamePosition() -> GamePosition {
        .init(row: row, column: column)
    }
}
