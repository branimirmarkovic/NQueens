//
//  NQueensTests.swift
//  NQueensTests
//
//  Created by Branimir Markovic on 5. 2. 2026..
//

import Testing
@testable import NQueens

@MainActor
@Suite(.serialized)
struct GameCreationViewModelTests: Sendable {
    
    @Test func init_setsDefaultGameValues() async throws {
        let sut = GameCreationViewModel()
        
        #expect(sut.game.size == 4)
        #expect(sut.game.mode == .easy)
        #expect(sut.game.queens.isEmpty)
        #expect(sut.game.maxActions == nil)
    }
    
    @Test func changeGameModeToEasy_maxActionsNil() async throws {
        let sut = GameCreationViewModel()
        sut.game.mode = .easy
        
        #expect(sut.game.maxActions == nil)
    }
    
    @Test func changeGameModeToMedium_maxActionsNil() async throws {
        let sut = GameCreationViewModel()
        sut.game.mode = .medium
        
        #expect(sut.game.maxActions == nil)
    }
    
    @Test func changeGameModeToHard_setsCorrectLimit() async throws {
        let sut = GameCreationViewModel()
        sut.game.size = 10
        sut.game.mode = .hard
        
        #expect(sut.game.maxActions == 20)
    }
    
}
