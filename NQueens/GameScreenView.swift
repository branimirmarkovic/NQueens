//
//  GameScreenView.swift
//  NQueens
//
//  Created by Branimir Markovic on 5. 2. 2026..
//

import SwiftUI

struct BoardField {
    var row: Int
    var column: Int
    
    var isPopulated: Bool = false
}

struct Board {
    var fields: [[BoardField]]
    
    init(size: Int) {
        self.fields = (0..<size).map { row in
            (0..<size).map { column in
                BoardField(row: row, column: column)
            }
        }
        
    }
}
