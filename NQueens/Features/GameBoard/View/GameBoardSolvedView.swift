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
            Text(GameBoardViewModel.Constants.gameEndTitle(gameSolved: viewModel.gameState == .won))
                .font(.title)
                .bold()
            
            Text(GameBoardViewModel.Constants.gameEndMessage(gameSolved: viewModel.gameState == .won))
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


