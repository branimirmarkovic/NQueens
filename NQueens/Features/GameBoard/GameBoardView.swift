import SwiftUI

struct GameBoardView: View {
    @State var viewModel: GameBoardViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text(GameBoardViewModel.Constants.title)
                .font(.largeTitle)
                .bold()
            
            Text(viewModel.remainingQueens(viewModel.remainingQueens))
                .font(.headline)
            
            if let error = viewModel.placementError {
                Text("\(GameBoardViewModel.Constants.placementErrorTitle)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: max(viewModel.board.count,1))
            
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(0..<viewModel.board.count, id: \.self) { row in
                    ForEach(0..<viewModel.board[row].count, id: \.self) { column in
                        let position = BoardPosition(row: row, column: column, hasQueen:  false, highlighted: false)
                        Button {
                            viewModel.tap(at: position)
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(backgroundColor(for: position))
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay(
                                        Rectangle()
                                            .stroke(borderColor(for: position), lineWidth: borderWidth(for: position))
                                    )
                                
                                if viewModel.board[row][column].hasQueen {
                                    Image(systemName: "crown")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(6)
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            Button(GameBoardViewModel.Constants.resetButtonTitle) {
                viewModel.refresh()
            }
            .padding(.top, 12)
        }
        .padding()
    }
    
    private func backgroundColor(for position: BoardPosition) -> Color {
        if position.highlighted {
            return Color.green.opacity(0.3)
        }
        return Color(UIColor.systemBackground)
    }
    
    private func borderColor(for position: BoardPosition) -> Color {
        if position.highlighted {
            return .green
        }
        return Color.secondary.opacity(0.3)
    }
    
    private func borderWidth(for position: BoardPosition) -> CGFloat {
        return position.highlighted ? 3.0 : 1.0
    }
}

#Preview {
    let viewModel = GameBoardViewModel(gameEngine: GameEngineAdapter.shared)
    GameBoardView(viewModel: viewModel)
}
