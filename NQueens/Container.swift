//
//  Container.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import Foundation
import NQueenEngine


final class Container {
    static var queensEngine = try! NQueensEngine(size: 3)
    
}




final class GameEngineAdapter: GameEngine {
    
    private let engine: NQueensEngine
    
    static let shared = GameEngineAdapter(engine: Container.queensEngine)
    
    private init(engine: NQueensEngine) {
        self.engine = engine
    }
    
    func avaivablePositions() -> [GamePosition] {
        []
    }
    
    func placeQueen(at position: GamePosition) throws {}
    
    func removeQueen(at position: GamePosition) throws { }
    
    func canPlaceQueen(at position: GamePosition) -> Bool {
        true
    }
    
    func resetBoard(size: Int) {}
    
    
}



