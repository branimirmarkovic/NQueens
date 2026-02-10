//
//  BoardPosition.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//
import Foundation

struct BoardPosition: Identifiable {
    let row: Int
    let column: Int
    var hasQueen: Bool
    var isFreeToPlace: Bool
    var isConflicting: Bool
    
    var id: Int { (row << 16) | column }
}

enum BoardPlacementError: Error, Equatable {
    case invalidPosition
    case positionOccupied
    case conflicts
    case noQueensRemaining
    case uknown
}
