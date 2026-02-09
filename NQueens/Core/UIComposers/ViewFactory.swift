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
        case .gameBoard(let game):
            GameBoardScreenComposer.compose(game: game)
        }
    }
    
    func view(for sheet: SheetDestination) -> some View {
        switch sheet {
        case .gameWinner(let viewModel):
            GameBoardSolvedScreenComposer.compose(viewModel: viewModel)
        }
    }
    
    func rootView() -> some View {
        GameCreationScreenComposer.compose()
    }
}
