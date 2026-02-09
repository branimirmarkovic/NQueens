//
//  GameEngineAdapter.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import NQueenEngine

final class GameEngineController {
    private enum ControllerError: Error {
        case engineNotInitialized
        case invalidSize
    }
    
    private(set) var engine: NQueensEngine?
    
    private func setUpEngine(size: Int, queens: [GamePosition]) throws {
        let engineQueens = Set(queens.map { Position(row: $0.row, column: $0.column) })
        self.engine = try NQueensEngine(size: size, queens: engineQueens)
    }
}

extension GameEngineController: GameController {
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
    
    func startGame(size: Int, queens: [GamePosition]) throws {
       try setUpEngine(size: size, queens: queens)
    }
    
    func avaivablePositions() -> [GamePosition] {
        guard let engine = engine else { return [] }
        return engine.availablePositions().map { GamePosition(row: $0.row, column: $0.column) }
    }
    
    func resetBoard(size: Int) throws {
        try setUpEngine(size: size, queens: [])
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
