//
//  GameEngine.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

protocol GameController {
    var boardSize: Int { get }
    var game: NQueenGame { get set }
    
    func toggle(_ position: GamePosition) throws
    func availablePositions() -> [GamePosition]
    func conflictingPositions() -> [GamePosition] 
    func queensPlaced() -> [GamePosition]
    func queensRemaining() -> Int
    func startGame() throws
    func resetGame() throws
}
