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
    }
    
    var board: [[BoardPosition]]
    var remainingQueens: Int
    var placementError: BoardPlacementError?
    private var hasStarted = false
    private let gameEngine: GameController
    
    init(
        gameEngine: GameController,
    ) {
        self.gameEngine = gameEngine
        self.board = BoardMapper.createBoard(from: gameEngine)
        self.remainingQueens = gameEngine.queensRemaining()
    }
    
    func startGame() {
        if hasStarted {
            refresh()
            return
        }
        
        do {
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
            refresh()
        } catch let error as BoardPlacementError {
            self.placementError = error
        } catch {
            self.placementError = .uknown
        }
    }
    
    func resetGame() {
        do {
            try gameEngine.resetGame()
            refresh()
        } catch {
            placementError = .uknown
        }
    }
    
    func refresh() {
        let availablePositions = Set(gameEngine.availablePositions())
        remainingQueens = gameEngine.queensRemaining()

        var newBoard = BoardMapper.createBoard(from: gameEngine)
        applyHighlights(to: &newBoard, available: availablePositions)

        board = newBoard
    }

    private func applyHighlights(to board: inout [[BoardPosition]], available: Set<GamePosition>) {
        let shouldHighlight = shouldHighlightAvailablePositions(available, in: board)
        for row in board.indices {
            for column in board[row].indices {
                let position = GamePosition(row: row, column: column)
                board[row][column].highlighted = shouldHighlight && available.contains(position)
            }
        }
    }

    private func shouldHighlightAvailablePositions(_ available: Set<GamePosition>, in board: [[BoardPosition]]) -> Bool {
        let totalPositions = board.count * (board.first?.count ?? 0)
        return !available.isEmpty && available.count < totalPositions
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
                return BoardPosition(row: row, column: column, hasQueen: hasQueen, highlighted: false)
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
