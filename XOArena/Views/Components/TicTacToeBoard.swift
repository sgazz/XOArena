import SwiftUI

// MARK: - Enhanced TicTacToe Board Component

struct TicTacToeBoard: View {
    let board: Board
    let onCellTap: (Int) -> Void
    let isInteractive: Bool
    
    @State private var pressedCell: Int?
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var particleManager: ParticleManager
    
    init(board: Board, isInteractive: Bool = true, onCellTap: @escaping (Int) -> Void) {
        self.board = board
        self.isInteractive = isInteractive
        self.onCellTap = onCellTap
    }
    
    var body: some View {
        VStack(spacing: 6) {
            ForEach(0..<3) { row in
                HStack(spacing: 6) {
                    ForEach(0..<3) { column in
                        let index = row * 3 + column
                        EnhancedBoardCell(
                            cell: board.cells[index],
                            isPressed: pressedCell == index,
                            isInteractive: isInteractive && board.cells[index] == .empty,
                            position: (row, column),
                            boardState: boardState
                        ) {
                            handleCellTap(index)
                        }
                    }
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(boardBackgroundColor)
                .stroke(boardBorderColor, lineWidth: boardBorderWidth)
        )
        .overlay(
            // Winner celebration overlay
            Group {
                if let winner = board.winner {
                    WinnerCelebrationOverlay(winner: winner)
                }
            }
        )
        .onChange(of: board.winner) { _, winner in
            if winner != nil {
                // Simple winner indication
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(AccessibilityEnhancements.boardAccessibilityLabel(
            boardIndex: board.id,
            isActive: board.isActive,
            winner: board.winner,
            isCompleted: board.isComplete
        ))
        .accessibilityHint(AccessibilityEnhancements.boardAccessibilityHint(
            isActive: board.isActive,
            isCompleted: board.isComplete
        ))
        .accessibilityAddTraits(.allowsDirectInteraction)
        .accessibilityValue(board.isActive ? "Active board" : "Inactive board")
    }
    
    // MARK: - Computed Properties
    
    private var boardState: BoardState {
        if let winner = board.winner {
            return .won(winner)
        } else if board.isFull {
            return .draw
        } else if board.isActive {
            return .active
        } else {
            return .inactive
        }
    }
    
    // MARK: - Board Styling Properties
    
    private var boardBackgroundColor: Color {
        if board.isActive {
            return Color.xoDarkBackground.opacity(0.8)
        } else {
            return Color.xoInactiveBoardBackground
        }
    }
    
    private var boardBorderColor: Color {
        if board.isActive {
            return Color.xoGold
        } else {
            return Color.xoInactiveBoardBorder
        }
    }
    
    private var boardBorderWidth: CGFloat {
        if board.isActive {
            return 2.0
        } else {
            return 1.0
        }
    }
    
    private func handleCellTap(_ index: Int) {
        guard isInteractive && board.cells[index] == .empty else { return }
        
        // Haptic feedback
        HapticManager.shared.impact(.medium)
        
        // Press animation
        withAnimation(.easeInOut(duration: 0.1)) {
            pressedCell = index
        }
        
        // Release animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                pressedCell = nil
            }
            onCellTap(index)
        }
    }
}

// MARK: - Enhanced Board Cell Component

struct EnhancedBoardCell: View {
    let cell: Cell
    let isPressed: Bool
    let isInteractive: Bool
    let position: (row: Int, column: Int)
    let boardState: BoardState
    let onTap: () -> Void
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var particleManager: ParticleManager
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Simple cell background
                RoundedRectangle(cornerRadius: 8)
                    .fill(cellBackground)
                    .stroke(cellBorder, lineWidth: 1)
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isPressed)
                
                // Cell content
                if cell != .empty {
                    Text(cell.displayValue)
                        .font(.system(size: cellFontSize, weight: .bold))
                        .foregroundColor(cell == .x ? Color.adaptiveBlue() : Color.adaptiveOrange())
                        .minimumScaleFactor(0.5)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isInteractive)
        .accessibilityLabel(AccessibilityEnhancements.cellAccessibilityLabel(
            row: position.row,
            column: position.column,
            cell: cell,
            isInteractive: isInteractive
        ))
        .accessibilityHint(AccessibilityEnhancements.cellAccessibilityHint(
            cell: cell,
            isInteractive: isInteractive
        ))
        .accessibilityAddTraits(cellAccessibilityTraits)
        .accessibilityValue(cell.displayValue)
    }
    
    // MARK: - Computed Properties
    
    private var cellFontSize: CGFloat {
        switch dynamicTypeSize {
        case .xSmall, .small:
            return 28
        case .medium:
            return 26
        case .large:
            return 24
        case .xLarge:
            return 22
        case .xxLarge:
            return 20
        case .xxxLarge:
            return 18
        case .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            return 16
        @unknown default:
            return 26
        }
    }
    
    private var cellBackground: Color {
        switch cell {
        case .empty:
            return Color.xoDarkBackground.opacity(0.6)
        case .x:
            return Color.adaptiveBlue().opacity(0.1)
        case .o:
            return Color.adaptiveOrange().opacity(0.1)
        }
    }
    
    private var cellBorder: Color {
        switch cell {
        case .empty:
            return Color.xoDarkMetallic.opacity(0.5)
        case .x:
            return Color.adaptiveBlue().opacity(0.3)
        case .o:
            return Color.adaptiveOrange().opacity(0.3)
        }
    }
    
    private var cellAccessibilityTraits: AccessibilityTraits {
        var traits: AccessibilityTraits = []
        
        if isInteractive {
            _ = traits.insert(.isButton)
        }
        
        if cell != .empty {
            _ = traits.insert(.isStaticText)
            _ = traits.insert(.isSelected)
        }
        
        return traits
    }
}

// MARK: - Winner Celebration Overlay

struct WinnerCelebrationOverlay: View {
    let winner: Player
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(
                winner == .x ? Color.adaptiveBlue() : Color.adaptiveOrange(),
                lineWidth: 3
            )
    }
}

// MARK: - Board State Enum

enum BoardState {
    case active
    case inactive
    case won(Player)
    case draw
}

// MARK: - Preview

// MARK: - Enhanced Preview

#Preview("TicTacToe Board - All States") {
    let emptyBoard = Board(id: 0)
    
    let boardWithMoves = {
        var board = Board(id: 1)
        board.cells[0] = .x
        board.cells[4] = .o
        board.cells[8] = .x
        board.cells[1] = .o
        board.cells[7] = .x
        return board
    }()
    
    let winningBoardX = {
        var board = Board(id: 2)
        board.cells[0] = .x
        board.cells[1] = .x
        board.cells[2] = .x
        board.winner = .x
        return board
    }()
    
    let winningBoardO = {
        var board = Board(id: 3)
        board.cells[3] = .o
        board.cells[4] = .o
        board.cells[5] = .o
        board.winner = .o
        return board
    }()
    
    let drawBoard = {
        var board = Board(id: 4)
        board.cells = [.x, .o, .x, .o, .x, .o, .o, .x, .o]
        return board
    }()
    
    let diagonalWin = {
        var board = Board(id: 5)
        board.cells[0] = .x
        board.cells[4] = .x
        board.cells[8] = .x
        board.winner = .x
        return board
    }()
    
    return ScrollView {
        VStack(spacing: 40) {
            // Title
            Text("Enhanced TicTacToe Board")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(LinearGradient.xoGoldGradient)
                .padding(.top, 20)
            
            // Empty Board
            VStack(spacing: 8) {
                Text("Empty Board")
                    .font(.headline)
                    .foregroundColor(.xoTextSecondary)
                
                TicTacToeBoard(
                    board: emptyBoard,
                    onCellTap: { _ in }
                )
            }
            
            // Board with Moves
            VStack(spacing: 8) {
                Text("Board with Moves")
                    .font(.headline)
                    .foregroundColor(.xoTextSecondary)
                
                TicTacToeBoard(
                    board: boardWithMoves,
                    onCellTap: { _ in }
                )
            }
            
            // Winning Board X
            VStack(spacing: 8) {
                Text("Winning Board - X")
                    .font(.headline)
                    .foregroundColor(.xoTextSecondary)
                
                TicTacToeBoard(
                    board: winningBoardX,
                    onCellTap: { _ in }
                )
            }
            
            // Winning Board O
            VStack(spacing: 8) {
                Text("Winning Board - O")
                    .font(.headline)
                    .foregroundColor(.xoTextSecondary)
                
                TicTacToeBoard(
                    board: winningBoardO,
                    onCellTap: { _ in }
                )
            }
            
            // Diagonal Win
            VStack(spacing: 8) {
                Text("Diagonal Win")
                    .font(.headline)
                    .foregroundColor(.xoTextSecondary)
                
                TicTacToeBoard(
                    board: diagonalWin,
                    onCellTap: { _ in }
                )
            }
            
            // Draw Board
            VStack(spacing: 8) {
                Text("Draw Board")
                    .font(.headline)
                    .foregroundColor(.xoTextSecondary)
                
                TicTacToeBoard(
                    board: drawBoard,
                    onCellTap: { _ in }
                )
            }
            
            // Interactive Demo
            VStack(spacing: 8) {
                Text("Interactive Demo")
                    .font(.headline)
                    .foregroundColor(.xoTextSecondary)
                
                InteractiveBoardDemo()
            }
        }
        .padding()
    }
    .background(LinearGradient.xoBackgroundGradient)
    .ignoresSafeArea()
}

// MARK: - Interactive Demo Component

struct InteractiveBoardDemo: View {
    @State private var board = Board(id: 6)
    @State private var currentPlayer: Player = .x
    @State private var gameState: String = "X's turn"
    
    var body: some View {
        VStack(spacing: 16) {
            // Game status
            Text(gameState)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(LinearGradient.xoGoldGradient)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.xoDarkerBackground.opacity(0.8))
                        .stroke(Color.xoGold.opacity(0.3), lineWidth: 1)
                )
            
            // Board
            TicTacToeBoard(
                board: board,
                onCellTap: { index in
                    makeMove(at: index)
                }
            )
            
            // Reset button
            Button("Reset Game") {
                resetGame()
            }
            .metallicButton()
        }
    }
    
    private func makeMove(at index: Int) {
        guard board.cells[index] == .empty else { return }
        
        // Make move - convert Player to Cell
        board.cells[index] = currentPlayer == .x ? .x : .o
        
        // Check for winner
        if let winner = GameLogic.checkWinner(for: board) {
            board.winner = winner
            gameState = "\(winner.displayName) wins!"
            return
        }
        
        // Check for draw
        if board.isFull {
            gameState = "It's a draw!"
            return
        }
        
        // Switch player
        currentPlayer = currentPlayer.opposite
        gameState = "\(currentPlayer.displayName)'s turn"
    }
    
    private func resetGame() {
        board = Board(id: 6)
        currentPlayer = .x
        gameState = "X's turn"
    }
} 