import Testing
@testable import NQueens

@MainActor
struct GameWinCheckerTests: Sendable {
    
    @Test func isGameSolved_whenNoQueensLeft_andNoConflicts_returnsTrue() async throws {
        let result = GameWinChecker.isGameSolved(remainingQueens: 0, conflictingPositions: [])
        #expect(result == true)
    }
    
    @Test func isGameSolved_whenConflictsExist_returnsFalse() async throws {
        let conflicts: Set<GamePosition> = [GamePosition(row: 0, column: 0)]
        let result = GameWinChecker.isGameSolved(remainingQueens: 0, conflictingPositions: conflicts)
        #expect(result == false)
    }
    
    @Test func isGameSolved_whenQueensRemain_returnsFalse() async throws {
        let result = GameWinChecker.isGameSolved(remainingQueens: 1, conflictingPositions: [])
        #expect(result == false)
    }
    
    @Test func isGameOver_whenNotHardMode_returnsFalse() async throws {
        let result = GameWinChecker.isGameOver(gameMode: .easy, movesMade: 10, maxActions: 5)
        #expect(result == false)
    }
    
    @Test func isGameOver_whenMissingCounts_returnsFalse() async throws {
        let result = GameWinChecker.isGameOver(gameMode: .hard, movesMade: nil, maxActions: 5)
        #expect(result == false)
    }
    
    @Test func isGameOver_whenMovesEqualLimit_returnsFalse() async throws {
        let result = GameWinChecker.isGameOver(gameMode: .hard, movesMade: 5, maxActions: 5)
        #expect(result == false)
    }
    
    @Test func isGameOver_whenMovesExceedLimit_returnsTrue() async throws {
        let result = GameWinChecker.isGameOver(gameMode: .hard, movesMade: 6, maxActions: 5)
        #expect(result == true)
    }
}
