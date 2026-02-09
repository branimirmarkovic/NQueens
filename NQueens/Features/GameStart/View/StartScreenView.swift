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
                Section("Game setup") {
                    Picker("Board size", selection: $viewModel.boardSize) {
                        ForEach(viewModel.availableSizes, id: \.self) { size in
                            Text("\(size) x \(size)").tag(size)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Description") {
                    Text(viewModel.gameRules)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if let error = viewModel.error {
                    Section("Error") {
                        Text(String(describing: error))
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    Button(action: {
                        viewModel.startGame()
                    }) {
                        Text("Start")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.boardSize <= 0)
                }
            }
            .navigationTitle("N-Queens")
        }
    }
}

#Preview {
    let vm = GameCreationViewModel(gameEngine: GameEngineAdapter.shared)
    return StartScreenView(viewModel: vm)
}
