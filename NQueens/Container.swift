//
//  Container.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import Foundation
import NQueenEngine


final class GameEngineAdapter: GameEngine {
    func queensRemaining() -> Int {
        0
    }
    
    
    private enum AdapterError: Error {
        case engineNotInitialized
    }
    
    private(set) var engine: NQueensEngine?
    static let shared = GameEngineAdapter()
    
    private init() {}
    
    func setUpEngine(size: Int) throws {
        self.engine = try NQueensEngine(size: size)
    }
    
    func avaivablePositions() -> [GamePosition] {
        []
    }
    
    func placeQueen(at position: GamePosition) throws {
        guard let engine = engine else {
            throw AdapterError.engineNotInitialized
        }
        let pos = Position(row: position.row, column: position.column)
        try engine.place(pos)
    }
    
    func removeQueen(at position: GamePosition) throws {
        guard let engine = engine else {
            throw AdapterError.engineNotInitialized
        }
        let pos = Position(row: position.row, column: position.column)
        try engine.remove(pos)
    }
    
    func resetBoard(size: Int) {
        engine?.reset(size: size)
    }
    
}

