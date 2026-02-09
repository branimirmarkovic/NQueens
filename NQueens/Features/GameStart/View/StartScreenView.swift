//
//  StartScreenView.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import SwiftUI

struct StartScreenView: View {
    @State var viewModel: GameCreationViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section(GameCreationViewModel.Constants.setupSectionTitle) {
                    Picker(GameCreationViewModel.Constants.boardSizeLabel, selection: $viewModel.boardSize) {
                        ForEach(viewModel.availableSizes, id: \.self) { size in
                            Text("\(size) x \(size)").tag(size)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(GameCreationViewModel.Constants.descriptionSectionTitle) {
                    Text(GameCreationViewModel.Constants.gameRules)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if let error = viewModel.error {
                    Section(GameCreationViewModel.Constants.errorSectionTitle) {
                        Text(String(describing: error))
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    Button(action: {
                        viewModel.startGame()
                    }) {
                        Text(GameCreationViewModel.Constants.startButtonTitle)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.boardSize <= 0)
                }
            }
            .navigationTitle(GameCreationViewModel.Constants.title)
        }
    }
}

#Preview {
    let vm = GameCreationViewModel(gameEngine: GameEngineAdapter.shared)
    StartScreenView(viewModel: vm)
}
