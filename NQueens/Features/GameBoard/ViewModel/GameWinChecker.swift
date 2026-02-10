//
//  GameWinChecker.swift
//  NQueens
//
//  Created by Branimir Markovic on 10. 2. 2026..
//

struct GameWinChecker {
    static func isGameSolved(remainingQueens: Int, conflictingPositions: Set<GamePosition>) -> Bool {
        return remainingQueens == 0 && conflictingPositions.isEmpty
    }
    
    static func isGameOver(gameMode: GameMode, movesMade: Int?, maxActions: Int?) -> Bool {
        guard gameMode == .hard, let movesMade, let maxActions else { return false }
        return movesMade > maxActions
    }
}
