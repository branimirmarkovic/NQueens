//
//  GameEngine.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

protocol GameEngine {
    func placeQueen(at position: GamePosition) throws
    func removeQueen(at position: GamePosition) throws
    func avaivablePositions() -> [GamePosition]
    func queensRemaining() -> Int
    func resetBoard(size: Int)
    func startGame(size: Int, queens: [GamePosition]) throws
}
