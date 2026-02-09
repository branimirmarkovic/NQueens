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
    
    func rootView() -> some View {
        GameCreationScreenComposer.compose()
    }
}
