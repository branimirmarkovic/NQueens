//
//  StartScreenView.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import SwiftUI

struct StartScreenView: View {
    @State var viewModel: GameCreationViewModel
    @Environment(MainCoordinator.self) var coordinator

    var body: some View {
        Form {
            setupSection()
            difficultySection()
            descriptionSection()
            errorSection()
            startSection()
        }
        .navigationTitle(GameCreationViewModel.Constants.title)
        .onChange(of: viewModel.game.size) { _, _ in
            viewModel.updateActionLimit()
        }
        .onChange(of: viewModel.game.mode) { _, _ in
            viewModel.updateActionLimit()
        }
    }

    @ViewBuilder
    private func setupSection() -> some View {
        Section(GameCreationViewModel.Constants.setupSectionTitle) {
            Picker(GameCreationViewModel.Constants.boardSizeLabel, selection: $viewModel.game.size) {
                ForEach(viewModel.availableSizes, id: \.self) { size in
                    Text(sizeRowText(size)).tag(size)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    @ViewBuilder
    private func difficultySection() -> some View {
        Section(GameCreationViewModel.Constants.difficultySectionTitle) {
            Picker(GameCreationViewModel.Constants.difficultyLabel, selection: $viewModel.game.mode) {
                ForEach(viewModel.availableModes, id: \.self) { mode in
                    Text(viewModel.modeTitle(mode)).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.modeTitle(viewModel.game.mode))
                    .font(.headline)
                Text(viewModel.modeDescription(viewModel.game.mode))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
    }

    @ViewBuilder
    private func descriptionSection() -> some View {
        Section(GameCreationViewModel.Constants.descriptionSectionTitle) {
            Text(viewModel.descriptionText())
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private func errorSection() -> some View {
        if let error = viewModel.error {
            Section(GameCreationViewModel.Constants.errorSectionTitle) {
                Text(String(describing: error))
                    .foregroundStyle(.red)
            }
        }
    }

    @ViewBuilder
    private func startSection() -> some View {
        Section {
            Button(action: {
                coordinator.push(to: .gameBoard(game: viewModel.game))
            }) {
                Text(GameCreationViewModel.Constants.startButtonTitle)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.game.size < 4)
        }
    }

    private func sizeRowText(_ size: Int) -> String {
        "\(size) x \(size)"
    }
}

#Preview {
    let vm = GameCreationViewModel()
    StartScreenView(viewModel: vm)
}
