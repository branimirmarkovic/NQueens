//
//  GameStorageService.swift
//  NQueens
//
//  Created by Branimir Markovic on 10. 2. 2026..
//

protocol GameStorageService {
    func saveGame(_ game: NQueenGame) async throws
    func loadGame(_ game: NQueenGame) async throws -> NQueenGame
    func checkForSavedGame() async throws -> Bool
}
