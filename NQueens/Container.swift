//
//  Container.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import Foundation
import NQueenEngine


final class GameEngineAdapter: GameEngine {
    
    private(set) var engine: NQueensEngine?
    static let shared = GameEngineAdapter()
    
    private init() {}
    
    func setUpEngine(size: Int) throws {
        self.engine = try NQueensEngine(size: size)
    }
    
    func avaivablePositions() -> [GamePosition] {
        []
    }
    
    func placeQueen(at position: GamePosition) throws {}
    
    func removeQueen(at position: GamePosition) throws { }
    
    func canPlaceQueen(at position: GamePosition) -> Bool {
        true
    }
    
    func resetBoard(size: Int) {
        engine?.reset(size: size)
    }
    
}

