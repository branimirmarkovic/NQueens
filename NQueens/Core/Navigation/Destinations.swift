//
//  PushDestination.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//
import Foundation

enum PushDestination: Hashable, Equatable {
    case gameBoard(game: NQueenGame)
}

enum SheetDestination: Identifiable, Hashable, Equatable {
    case gameEnded(viewModel: GameBoardViewModel)
    var id: String {
        switch self {
        case .gameEnded(let viewModel):
            viewModel.gameEngine.game.id.uuidString
        }
    }
}

extension GameBoardViewModel: Identifiable, Equatable, Hashable {
    static func == (lhs: GameBoardViewModel, rhs: GameBoardViewModel) -> Bool {
        lhs.gameEngine.game == rhs.gameEngine.game
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(gameEngine.game.id)
    }
}
