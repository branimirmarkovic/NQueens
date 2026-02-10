import Testing
import SwiftUI
@testable import NQueens

@MainActor
struct GameCreationScreenComposerTests: Sendable {
    
    @Test func compose_buildsStartScreenView() async throws {
        let view = GameCreationScreenComposer.compose()
        
        #expect(type(of: view) == StartScreenView.self)
    }
}
