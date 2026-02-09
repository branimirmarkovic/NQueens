//
//  GameCreationScreenComposer.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//
import SwiftUI

struct GameCreationScreenComposer {
    private init() {}
    
    
    static func compose() -> some View {
        let viewModel = GameCreationViewModel()
        let view = StartScreenView(viewModel: viewModel)
        return view
    }
}
