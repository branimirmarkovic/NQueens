//
//  GameBoardScreenComposer.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//
import SwiftUI

struct GameBoardScreenComposer {
    private init() {}
    
    static func compose(game: NQueenGame) -> some View {
        let gameEngine = GameEngineController(game: game)
        let viewModel = GameBoardViewModel(gameEngine: gameEngine)
        return GameBoardView(viewModel: viewModel)
    }
}
