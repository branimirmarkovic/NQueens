//
//  GamePosition.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import Foundation

struct GamePosition: Hashable, Equatable {
    let row: Int
    let column: Int
}

struct NQueenGame: Hashable, Equatable {
    let id: UUID
    var size: Int
    var queens: [GamePosition]
    var mode: GameMode
    var maxActions: Int?
    var movesMade: Int?
}

enum GameMode: CaseIterable {
    case easy
    case medium
    case hard
}
