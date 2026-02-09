//
//  GameBoardScreenComposer.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//
import SwiftUI

struct GameBoardScreenComposer {
    private init() {}
    
    
    static func compose() -> some View {
        let gameEngine = GameEngineController()
        let viewModel = GameBoardViewModel(gameEngine: gameEngine)
        return GameBoardView(viewModel: viewModel)
    }
}
