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
            viewModel.gameController.game.id.uuidString
        }
    }
}

extension GameBoardViewModel: Identifiable, Equatable, Hashable {
    static func == (lhs: GameBoardViewModel, rhs: GameBoardViewModel) -> Bool {
        lhs.gameController.game == rhs.gameController.game
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(gameController.game.id)
    }
}
