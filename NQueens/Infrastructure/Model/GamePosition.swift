//
//  GamePosition.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

struct GamePosition: Hashable, Equatable {
    let row: Int
    let column: Int
}

struct NQueenGame: Hashable, Equatable {
    var size: Int
    var queens: [GamePosition]
}
