//
//  ViewFactory.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import SwiftUI

struct ViewFactory {
    
    @ViewBuilder
    func view(for destination: PushDestination) -> some View {
        switch destination {
        case .gameBoard(let gameSize):
            GameBoardScreenComposer.compose()
        }
    }
    
    func rootView() -> some View {
        GameCreationScreenComposer.compose()
    }
}

struct GameBoardScreenComposer {
    private init() {}
    
    
    static func compose() -> some View {
        let gameEngine = GameEngineController()
        let viewModel = GameBoardViewModel(gameEngine: gameEngine)
        return GameBoardView(viewModel: viewModel)
    }
}

struct GameCreationScreenComposer {
    private init() {}
    
    
    static func compose() -> some View {
        let viewModel = GameCreationViewModel()
        let view = StartScreenView(viewModel: viewModel)
        return view
    }
}
