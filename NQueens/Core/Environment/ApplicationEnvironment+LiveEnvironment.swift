//
//  ApplicationEnvironment+LiveEnvironment.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import Foundation

extension ApplicationEnvironment: LiveEnvironment {
    var gameEngine: GameEngine {
        GameEngineAdapter.shared
    }
}
