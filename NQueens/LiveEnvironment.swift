//
//  LiveEnvironment.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import Foundation


typealias LiveEnvironment = GameEngineOwner

extension Container: LiveEnvironment {
    var gameEngine: GameEngine {
        GameEngineAdapter.shared
    }
}
