//
//  GameStorageService.swift
//  NQueens
//
//  Created by Branimir Markovic on 10. 2. 2026..
//

import Foundation

struct UserDefaultsGameStorageService {
    enum StorageError: Error {
        case noSavedGame
        case decodeFailed
    }
    
    struct StoredGame: Codable {
        let id: UUID
        let boardSize: Int
        let queens: [StoredPosition]
        let difficulty: StoredDifficulty
        let movesLeft: Int?
        let maxActions: Int?
    }
    
    struct StoredPosition: Codable {
        let row: Int
        let column: Int
    }
    
    enum StoredDifficulty: Codable {
        case easy
        case medium
        case hard
    }
    
    private let gameKey = "savedGame"
}

extension UserDefaultsGameStorageService: GameStorageService {
    func saveGame(_ game: NQueenGame) async throws {
        let stored = StoredGame(from: game)
        let data = try JSONEncoder().encode(stored)
        UserDefaults.standard.set(data, forKey: gameKey)
    }
    
    func loadGame(_ game: NQueenGame) async throws -> NQueenGame {
        guard let data = UserDefaults.standard.data(forKey: gameKey) else {
            throw StorageError.noSavedGame
        }
        guard let stored = try? JSONDecoder().decode(StoredGame.self, from: data) else {
            throw StorageError.decodeFailed
        }
        return stored.toNQueenGame()
    }
    
    func checkForSavedGame() async throws -> Bool {
        UserDefaults.standard.data(forKey: gameKey) != nil
    }
    
    
}

extension UserDefaultsGameStorageService.StoredDifficulty {
    init(from gameMode: GameMode) {
        switch gameMode {
        case .easy:
            self = .easy
        case .medium:
            self = .medium
        case .hard:
            self = .hard
        }
    }
    
    func toGameMode() -> GameMode {
        switch self {
        case .easy:
            return .easy
        case .medium:
            return .medium
        case .hard:
            return .hard
        }
    }
}
    
extension UserDefaultsGameStorageService.StoredGame {
    init(from game: NQueenGame) {
        self.boardSize = game.size
        self.queens = game.queens.map { UserDefaultsGameStorageService.StoredPosition(from: $0) }
        self.difficulty = UserDefaultsGameStorageService.StoredDifficulty(from: game.mode)
        self.movesLeft = game.movesLeft
        self.maxActions = game.maxActions
        self.id = game.id
    }
    
    func toNQueenGame() -> NQueenGame {
        return NQueenGame(
            id: id,
            size: boardSize,
            queens: queens.map { $0.toGamePosition() },
            mode: difficulty.toGameMode(),
            maxActions: maxActions,
            movesLeft: movesLeft
        )
    }
}

extension UserDefaultsGameStorageService.StoredPosition {
    init(from position: GamePosition) {
        self.row = position.row
        self.column = position.column
    }
    
    func toGamePosition() -> GamePosition {
        return GamePosition(row: row, column: column)
    }
}





