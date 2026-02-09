import SwiftUI

struct GameBoardView: View {
    @State var viewModel: GameBoardViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            header

            if let error = viewModel.placementError {
                errorBanner(error)
            }
            
            let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: max(viewModel.boardSize, 1))
            let positions = viewModel.board.flatMap { $0 }
            
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(positions) { position in
                    Button {
                        viewModel.tap(at: position)
                    } label: {
                        cell(for: position, row: position.row, column: position.column)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
            )
            
            Button(GameBoardViewModel.Constants.resetButtonTitle) {
                viewModel.refresh()
            }
            .padding(.top, 12)
        }
        .padding()
        .onAppear {
            viewModel.startGame()
        }
    }
    
    private var header: some View {
        VStack(spacing: 6) {
            Text(GameBoardViewModel.Constants.title)
                .font(.largeTitle)
                .bold()
            
            Text(viewModel.remainingQueens(viewModel.remainingQueens))
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
    
    private func errorBanner(_ error: BoardPlacementError) -> some View {
        Text(viewModel.message(for: error))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .background(Color.red.opacity(0.85), in: RoundedRectangle(cornerRadius: 8))
    }
    
    private func cell(for position: BoardPosition, row: Int, column: Int) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(backgroundColor(for: position, row: row, column: column))
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    Rectangle()
                        .stroke(borderColor(for: position), lineWidth: borderWidth(for: position))
                )
            
            if position.hasQueen {
                Image(systemName: "crown.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(6)
                    .foregroundColor(.yellow)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            }
        }
        .accessibilityLabel("Row \(row + 1), Column \(column + 1)")
    }
    
    private func backgroundColor(for position: BoardPosition, row: Int, column: Int) -> Color {
        if position.highlighted {
            return Color.green.opacity(0.35)
        }
        let isDark = (row + column) % 2 == 0
        return isDark ? Color(UIColor.systemGray6) : Color(UIColor.systemBackground)
    }
    
    private func borderColor(for position: BoardPosition) -> Color {
        if position.highlighted {
            return .green
        }
        return Color.secondary.opacity(0.25)
    }
    
    private func borderWidth(for position: BoardPosition) -> CGFloat {
        return position.highlighted ? 3.0 : 1.0
    }
}

#Preview {
}
