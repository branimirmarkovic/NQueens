//
//  GameEngine.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//


protocol GameEngine {
    func placeQueen(at position: GamePosition) throws
    func removeQueen(at position: GamePosition) throws
    func canPlaceQueen(at position: GamePosition) -> Bool
    func avaivablePositions() -> [GamePosition]
    func resetBoard(size: Int)
}

protocol GameEngineOwner {
    var gameEngine: GameEngine { get }
}
