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
                setupSection()
                descriptionSection()
                errorSection()
                startSection()
            }
            .navigationTitle(GameCreationViewModel.Constants.title)
        }
    }

    @ViewBuilder
    private func setupSection() -> some View {
        Section(GameCreationViewModel.Constants.setupSectionTitle) {
            Picker(GameCreationViewModel.Constants.boardSizeLabel, selection: $viewModel.boardSize) {
                ForEach(viewModel.availableSizes, id: \.self) { size in
                    Text(sizeRowText(size)).tag(size)
                }
            }
            .pickerStyle(.menu)
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
            Button(action: { viewModel.startGame() }) {
                Text(GameCreationViewModel.Constants.startButtonTitle)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.boardSize <= 0)
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
