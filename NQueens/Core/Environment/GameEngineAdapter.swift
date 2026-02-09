//
//  GameEngineAdapter.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import NQueenEngine

final class GameEngineAdapter: GameEngine {
    private enum AdapterError: Error {
        case engineNotInitialized
    }
    
    private(set) var engine: NQueensEngine?
    static let shared = GameEngineAdapter()
    
    private init() {}
    
    func startGame(size: Int, queens: [GamePosition]) throws {
       try setUpEngine(size: size)
    }
    
    func avaivablePositions() -> [GamePosition] {
        guard let engine = engine else { return [] }
        return engine.availablePositions().map { GamePosition(row: $0.row, column: $0.column) }
    }
    
    func placeQueen(at position: GamePosition) throws {
        guard let engine = engine else {
            throw AdapterError.engineNotInitialized
        }
        let pos = Position(row: position.row, column: position.column)
        do {
            try engine.place(pos)
        } catch let error as NQueenEngine.PlacementError {
            throw BoardPlacementError(from: error)
        }
    }
    
    func removeQueen(at position: GamePosition) throws {
        guard let engine = engine else {
            throw AdapterError.engineNotInitialized
        }
        let pos = Position(row: position.row, column: position.column)
        do {
            try engine.remove(pos)
        } catch let error as NQueenEngine.PlacementError {
            throw BoardPlacementError(from: error)
        }
    }
    
    func resetBoard(size: Int) {
        engine?.reset(size: size)
    }
    
    func queensRemaining() -> Int {
        guard let engine = engine else { return 0 }
        return engine.remainingQueens
    }
    
    private func setUpEngine(size: Int) throws {
        self.engine = try NQueensEngine(size: size)
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
