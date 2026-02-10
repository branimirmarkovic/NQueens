//
//  GameBoardSolvedScreenComposer.swift
//  NQueens
//
//  Created by Branimir Markovic on 10. 2. 2026..
//
import SwiftUI

struct GameBoardSolvedScreenComposer {
    private init() {}
    
    static func compose(viewModel: GameBoardViewModel) -> some View {
        GameBoardSolvedView(viewModel: viewModel)
    }
}
