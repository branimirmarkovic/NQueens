//
//  BoardModelSynchronizer.swift
//  NQueens
//
//  Created by Branimir Markovic on 10. 2. 2026..
//

struct BoardModelSynchronizer {
    
    static func createSynchronizedBoard(with engine: GameController) -> GameBoardViewModel.BoardModel {
        let availablePositions = Set(engine.availablePositions())
        let conflictingPositions = Set(engine.conflictingPositions())
        
        var newBoard = createBoard(from: engine)
        if engine.game.mode == .easy {
            applyHighlights(to: &newBoard, available: availablePositions)
        }
        if engine.game.mode == .medium {
            applyConflicts(to: &newBoard, conflicts: conflictingPositions)
        }
        
        return newBoard
    }
        
    
    private static func applyHighlights(to board: inout GameBoardViewModel.BoardModel, available: Set<GamePosition>) {
        let shouldHighlight = shouldHighlightAvailablePositions(available, in: board)
        for row in board.indices {
            for column in board[row].indices {
                let position = GamePosition(row: row, column: column)
                board[row][column].isFreeToPlace = shouldHighlight && available.contains(position)
            }
        }
    }
    
    private static func createBoard(from engine: GameController) -> [[BoardPosition]] {
        let board = (0..<engine.boardSize).map { row in
            (0..<engine.boardSize).map { column in
                let hasQueen = engine.queensPlaced().contains(where: { $0.row == row && $0.column == column })
                return BoardPosition(row: row, column: column, hasQueen: hasQueen, isFreeToPlace: false, isConflicting: false)
            }
        }
        return board
    }

    private static func shouldHighlightAvailablePositions(_ available: Set<GamePosition>, in board: GameBoardViewModel.BoardModel) -> Bool {
        let totalPositions = board.count * (board.first?.count ?? 0)
        return !available.isEmpty && available.count < totalPositions
    }
    
    private static func applyConflicts(to board: inout GameBoardViewModel.BoardModel, conflicts: Set<GamePosition>) {
        for row in board.indices {
            for column in board[row].indices {
                let position = GamePosition(row: row, column: column)
                board[row][column].isConflicting = conflicts.contains(position)
            }
        }
    }
}
