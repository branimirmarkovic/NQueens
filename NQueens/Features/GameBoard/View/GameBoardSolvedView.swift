//
//  GameBoardSolvedSheet.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import SwiftUI

struct GameBoardSolvedView: View {
    let viewModel: GameBoardViewModel
    @Environment(MainCoordinator.self) var coordinator
    
    var body: some View {
        VStack(spacing: 16) {
            Text(GameBoardViewModel.Constants.gameEndTitle(gameSolved: viewModel.gameSolved))
                .font(.title)
                .bold()
            
            Text(GameBoardViewModel.Constants.gameEndMessage(gameSolved: viewModel.gameSolved))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button(GameBoardViewModel.Constants.playAgainTitle) {
                viewModel.resetGame()
                coordinator.dismissSheet()
            }
            .buttonStyle(.borderedProminent)
            
            Button(GameBoardViewModel.Constants.chooseBoardTitle) {
                coordinator.dismissSheet()
                coordinator.pop()
            }
            .buttonStyle(.bordered)
        }
        .padding(24)
    }
}


