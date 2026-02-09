//
//  GameEngineAdapter.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import NQueenEngine

final class GameEngineController: GameController {
    private enum ControllerError: Error {
        case engineNotInitialized
        case invalidSize
    }
    
    private(set) var engine: NQueensEngine?
    var game: NQueenGame
    
    init(game: NQueenGame) {
        self.game = game
    }

    func queensPlaced() -> [GamePosition] {
        guard let engine = engine else { return [] }
        return engine.board.queens.map { GamePosition(row: $0.row, column: $0.column) }
    }
    
    func toggle(_ position: GamePosition) throws {
           guard let engine else { throw ControllerError.engineNotInitialized }

           do {
               try engine.toggle(.init(row: position.row, column: position.column))
           } catch let error as NQueenEngine.PlacementError {
               throw BoardPlacementError(from: error)
           }
       }
    
    func queensRemaining() -> Int {
        guard let engine = engine else { return 0 }
        return engine.remainingQueensCount
    }
    
    func startGame() throws {
        let engineQueens = Set(game.queens.map { Position(row: $0.row, column: $0.column) })
        self.engine = try NQueensEngine(size: game.size, queens: engineQueens)
    }
    
    func availablePositions() -> [GamePosition] {
        guard let engine = engine else { return [] }
        return engine.availablePositions().map { GamePosition(row: $0.row, column: $0.column) }
    }
    
    func resetBoard(size: Int) throws {
        self.engine = try NQueensEngine(size: size)
    }
    
    var boardSize: Int {
        engine?.board.size ?? 0
    }
}

extension BoardPlacementError {
    init(from error: NQueenEngine.PlacementError) {
        switch error {
        case .invalidPosition: self = .invalidPosition
        case .positionOccupied: self = .positionOccupied
        case .conflicts: self = .conflicts
        case .noQueensRemaining: self = .noQueensRemaining
        }
    }
}
