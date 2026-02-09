//
//  GameBoardViewModel.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import Foundation
import Observation

struct BoardPosition {
    let row: Int
    let column: Int
    var hasQueen: Bool
    var highlighted: Bool
}

enum BoardPlacementError: Error, Equatable {
    case invalidPosition
    case positionOccupied
    case conflicts
    case noQueensRemaining
}

@Observable
final class GameBoardViewModel {
    enum Constants {
        static let title = "Board"
        static let availablePositionsTitle = "Available positions"
        static let resetButtonTitle = "Reset"
        static let placementErrorTitle = "Placement error"
    }
    
    var board: [[BoardPosition]]
    var remainingQueens: Int = 0
    var placementError: BoardPlacementError?
    private let gameEngine: GameEngine
    
    init(
        gameEngine: GameEngine
    ) {
        self.gameEngine = gameEngine
        let size = gameEngine.boardSize
        self.board = (0..<size).map { row in
            (0..<size).map { column in
                BoardPosition(row: row, column: column, hasQueen: false, highlighted: false)
            }
        }
    }
    
    func tap(at position: BoardPosition) {
        if position.hasQueen {
            removeQueen(at: position)
        } else {
            if position.highlighted {
                placeQueen(at: position)
            } else {
                placementError = .invalidPosition
            }
        }
    }
    
    
    private func placeQueen(at position: BoardPosition) {
        do {
            try gameEngine.placeQueen(at: position.toGamePosition())
            placementError = nil
            refresh()
        } catch {
            placementError = error as? BoardPlacementError
        }
    }

    private func removeQueen(at position: BoardPosition) {
        do {
            try gameEngine.removeQueen(at: position.toGamePosition())
            refresh()
        } catch {
        }
    }
    
    func refresh() {
        let available = Set(gameEngine.avaivablePositions())
        remainingQueens = gameEngine.queensRemaining()

        for row in 0..<board.count {
            for col in 0..<board[row].count {
                let isAvailable = available.contains(GamePosition(row: row, column: col))
                board[row][col].highlighted = isAvailable
            }
        }
    }

    
    func remainingQueens(_ count: Int) -> String { "Remaining queens: \(count)" }
}

extension BoardPosition {
    func toGamePosition() -> GamePosition {
        .init(row: row, column: column)
    }
}

