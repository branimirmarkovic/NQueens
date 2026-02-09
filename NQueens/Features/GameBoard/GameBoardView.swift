import SwiftUI

struct GameBoardView: View {
    @State var viewModel: GameBoardViewModel
    
    var body: some View {
        GeometryReader { proxy in
            let isLandscape = proxy.size.width > proxy.size.height
            Group {
                if isLandscape {
                    HStack(spacing: Layout.sectionSpacing) {
                        actionsColumn
                            .fixedSize(horizontal: true, vertical: false)
                            .frame(maxWidth: Layout.actionsMaxWidth, alignment: .leading)
                        boardContainer
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                } else {
                    VStack(spacing: Layout.sectionSpacing) {
                        header
                        errorSection
                        boardContainer
                        resetButton
                    }
                }
            }
            .padding(Layout.screenPadding)
        }
        .onAppear(perform: viewModel.startGame)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private enum Layout {
        static let gridSpacing: CGFloat = 4
        static let sectionSpacing: CGFloat = 16
        static let screenPadding: CGFloat = 16
        static let boardPadding: CGFloat = 6
        static let boardCornerRadius: CGFloat = 12
        static let cellCornerRadius: CGFloat = 0
        static let highlightBorderWidth: CGFloat = 3
        static let normalBorderWidth: CGFloat = 1
        static let actionsMaxWidth: CGFloat = 180
    }
    
    private var positions: [BoardPosition] {
        viewModel.board.flatMap { $0 }
    }
    
    private var gridColumns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: Layout.gridSpacing),
            count: max(viewModel.boardSize, 1)
        )
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

    private var actionsColumn: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            header
            errorSection
            resetButton
            Spacer(minLength: 0)
        }
    }
    
    @ViewBuilder
    private var errorSection: some View {
        if let error = viewModel.placementError {
            Text(viewModel.message(for: error))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.85), in: RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private var boardContainer: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            boardGrid(size: side)
                .frame(width: side, height: side)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .layoutPriority(1)
    }
    
    private var resetButton: some View {
        Button(GameBoardViewModel.Constants.resetButtonTitle) {
            viewModel.resetGame()
        }
        .padding(.top, 12)
    }
    
    private func boardGrid(size: CGFloat) -> some View {
        LazyVGrid(columns: gridColumns, spacing: Layout.gridSpacing) {
            ForEach(positions) { position in
                Button {
                    viewModel.tap(at: position)
                } label: {
                    cell(for: position)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(Layout.boardPadding)
        .background(
            RoundedRectangle(cornerRadius: Layout.boardCornerRadius)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Layout.boardCornerRadius)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
        )
        .frame(width: size, height: size)
    }
    
    private func cell(for position: BoardPosition) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(backgroundColor(for: position))
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
        .accessibilityLabel("Row \(position.row + 1), Column \(position.column + 1)")
    }
    
    private func backgroundColor(for position: BoardPosition) -> Color {
        if position.highlighted {
            return Color.green.opacity(0.35)
        }
        let isDark = (position.row + position.column) % 2 == 0
        return isDark ? Color(UIColor.systemGray6) : Color(UIColor.systemBackground)
    }
    
    private func borderColor(for position: BoardPosition) -> Color {
        position.highlighted ? .green : Color.secondary.opacity(0.25)
    }
    
    private func borderWidth(for position: BoardPosition) -> CGFloat {
        position.highlighted ? Layout.highlightBorderWidth : Layout.normalBorderWidth
    }
}

#Preview {
//    let engine = GameEngineController()
//    let viewModel = GameBoardViewModel(gameEngine: engine, boardSize: 8)
//    GameBoardView(viewModel: viewModel)
}
