//
//  GameEngine.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

protocol GameController {
    
    var boardSize: Int { get }
    func toggle(_ position: GamePosition) throws
    func avaivablePositions() -> [GamePosition]
    func queensPlaced() -> [GamePosition]
    func queensRemaining() -> Int
    func startGame(size: Int, queens: [GamePosition]) throws
}
