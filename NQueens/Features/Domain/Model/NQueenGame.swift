//
//  GamePosition.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import Foundation

struct NQueenGame: Hashable, Equatable {
    let id: UUID
    var size: Int
    var queens: [GamePosition]
    var mode: GameMode
    var movesMade: Int?
}

struct GamePosition: Hashable, Equatable {
    let row: Int
    let column: Int
}

enum GameMode: CaseIterable {
    case easy
    case medium
    case hard
}
