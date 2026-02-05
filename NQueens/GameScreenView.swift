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

class GameViewModel {
    private var numberOfQueensPicked: Int
    private var board: Board
    
    init(numberOfQueensPicked: Int) {
        self.numberOfQueensPicked = numberOfQueensPicked
    }
}

struct GameScreenView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    GameScreenView()
}
