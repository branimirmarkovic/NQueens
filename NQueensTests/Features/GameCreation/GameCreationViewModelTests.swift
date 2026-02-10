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
    
    @Test(arguments: [
        (mode: GameMode.easy, expectedTitle: "Easy"),
        (mode: GameMode.medium, expectedTitle: "Medium"),
        (mode: GameMode.hard, expectedTitle: "Hard")
    ]) func modeTitle_givenMode_returnsCorrectValue(mode: GameMode, expectedTitle: String) async throws {
        let sut = GameCreationViewModel()
        let title = sut.modeTitle(mode)
        
        #expect(title == expectedTitle)
    }
    
    @Test func testFor_size_givenSize_returnsCorrectText() async throws {
        let sut = GameCreationViewModel()
        let text = sut.text(for: 5)
        
        #expect(text == "5×5")
    }
    
    @Test(arguments: [
        (mode: GameMode.easy, boardSize: 4, expectedDescription: "Shows available fields and prevents conflicting moves."),
        (mode: GameMode.medium, boardSize: 6, expectedDescription: "Shows conflicting queens. Available fields are hidden and conflicting moves are allowed."),
        (mode: GameMode.hard, boardSize: 8, expectedDescription: "No visual hints. Action limit: 16.")
    ]) func modeDescription_givenMode_returnsCorrectText(mode: GameMode, boardSize: Int, expectedDescription: String) async throws {
        let sut = GameCreationViewModel()
        
        sut.game.size = boardSize
        sut.game.mode = mode
        let description = sut.modeDescription(mode)
        
        #expect(description == expectedDescription)
    }
    
    @Test func gameDescriptionText_returnsCorrectText() async throws {
        let sut = GameCreationViewModel()
        let description = sut.descriptionText()

        sut.game.size = 4
        
        #expect(description == "Place 4 queens on an 4×4 chessboard so that no two queens threaten each other. Queens cannot share the same row, column, or diagonal.")
    }
    
    @Test func availableSizes_returnsCorrectRange() async throws {
        let sut = GameCreationViewModel()
        let sizes = sut.availableSizes
        
        #expect(sizes == Array(4...15))
    }
    
    @Test func availableModes_returnsAllGameModes() async throws {
        let sut = GameCreationViewModel()
        let modes = sut.availableModes
        
        #expect(modes == [.easy, .medium, .hard])
    }
    
    
    @Test func screenStringConstants_haveExpectedValue() {
        
        #expect(GameCreationViewModel.Constants.title == "N-Queens")
        #expect(GameCreationViewModel.Constants.setupSectionTitle == "Game setup")
        #expect(GameCreationViewModel.Constants.boardSizeLabel == "Board size")
        #expect(GameCreationViewModel.Constants.difficultySectionTitle == "Difficulty")
        #expect(GameCreationViewModel.Constants.difficultyLabel == "Mode")
        #expect(GameCreationViewModel.Constants.descriptionSectionTitle == "Description")
        #expect(GameCreationViewModel.Constants.startButtonTitle == "Start")
    }

    typealias SUT = GameCreationViewModel
    private func makeSUT() -> SUT {
        GameCreationViewModel()
    }
    
}
