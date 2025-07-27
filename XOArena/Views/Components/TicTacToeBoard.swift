import SwiftUI

// MARK: - TicTacToe Board Component

struct TicTacToeBoard: View {
    let board: Board
    let onCellTap: (Int) -> Void
    let isInteractive: Bool
    
    @State private var pressedCell: Int?
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @EnvironmentObject private var particleManager: ParticleManager
    
    init(board: Board, isInteractive: Bool = true, onCellTap: @escaping (Int) -> Void) {
        self.board = board
        self.isInteractive = isInteractive
        self.onCellTap = onCellTap
    }
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<3) { row in
                HStack(spacing: 4) {
                    ForEach(0..<3) { column in
                        let index = row * 3 + column
                        BoardCell(
                            cell: board.cells[index],
                            isPressed: pressedCell == index,
                            isInteractive: isInteractive && board.cells[index] == .empty,
                            position: (row, column)
                        ) {
                            if isInteractive && board.cells[index] == .empty {
                                pressedCell = index
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    pressedCell = nil
                                    onCellTap(index)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient.xoMetallicGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.xoDarkMetallic, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        )
        .overlay(
            // Winner highlight
            Group {
                if let winner = board.winner {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(winner == .x ? Color.adaptiveBlue() : Color.adaptiveOrange(), lineWidth: 4)
                        .glow(color: winner == .x ? Color.adaptiveBlue() : Color.adaptiveOrange(), radius: 15)
                        .onAppear {
                            // Create board win effect
                            let center = CGPoint(
                                x: UIScreen.main.bounds.width * 0.5,
                                y: UIScreen.main.bounds.height * 0.5
                            )
                            particleManager.createBoardWinEffect(at: center, player: winner)
                        }
                }
            }
        )
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
}

// MARK: - Board Cell Component

struct BoardCell: View {
    let cell: Cell
    let isPressed: Bool
    let isInteractive: Bool
    let position: (row: Int, column: Int)
    let onTap: () -> Void
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @EnvironmentObject private var particleManager: ParticleManager
    @State private var isAnimating = false
    @State private var cellFrame: CGRect = .zero
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Cell background
                RoundedRectangle(cornerRadius: 8)
                    .fill(cellBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(cellBorder, lineWidth: 1)
                    )
                    .shadow(color: cellShadow, radius: isPressed ? 2 : 4, x: 0, y: isPressed ? 1 : 2)
                    .scaleEffect(cellScale * cellBounceEffect * cellPulseEffect)
                    .rotationEffect(.degrees(cellRotation))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: cell)
                
                // Cell content with animation
                if cell != .empty {
                    Text(cell.displayValue)
                        .font(.system(size: cellFontSize, weight: .bold, design: .rounded))
                        .foregroundStyle(cellTextGradient)
                        .glow(color: cellGlowColor, radius: cellGlowRadius * cellShimmerEffect)
                        .minimumScaleFactor(0.5)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isAnimating)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isInteractive)
        .onAppear {
            if cell != .empty {
                // Trigger animation when cell appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAnimating = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isAnimating = false
                    }
                }
            }
        }
        .onChange(of: cell) { _, newCell in
            if newCell != .empty {
                // Trigger animation when cell changes
                isAnimating = true
                
                // Create particle effect for the move
                let center = CGPoint(
                    x: cellFrame.midX,
                    y: cellFrame.midY
                )
                let player: Player = newCell == .x ? .x : .o
                particleManager.createMoveEffect(at: center, player: player)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isAnimating = false
                }
            }
        }
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        cellFrame = geometry.frame(in: .global)
                    }
                    .onChange(of: geometry.frame(in: .global)) { _, newFrame in
                        cellFrame = newFrame
                    }
            }
        )
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
            return 24
        case .medium:
            return 22
        case .large:
            return 20
        case .xLarge:
            return 18
        case .xxLarge:
            return 16
        case .xxxLarge:
            return 14
        case .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            return 12
        @unknown default:
            return 22
        }
    }
    
    private var cellBackground: LinearGradient {
        switch cell {
        case .empty:
            return LinearGradient(
                colors: [Color.xoDarkerBackground, Color.xoDarkBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .x:
            return LinearGradient(
                colors: [Color.adaptiveBlue().opacity(0.2), Color.xoCyanBlue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .o:
            return LinearGradient(
                colors: [Color.adaptiveOrange().opacity(0.2), Color.xoOrangeRed.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var cellBorder: Color {
        switch cell {
        case .empty:
            return Color.xoDarkMetallic
        case .x:
            return Color.adaptiveBlue()
        case .o:
            return Color.adaptiveOrange()
        }
    }
    
    private var cellShadow: Color {
        switch cell {
        case .empty:
            return Color.black.opacity(0.2)
        case .x:
            return Color.adaptiveBlue().opacity(0.4)
        case .o:
            return Color.adaptiveOrange().opacity(0.4)
        }
    }
    
    private var cellTextGradient: LinearGradient {
        switch cell {
        case .empty:
            return LinearGradient(colors: [Color.clear], startPoint: .center, endPoint: .center)
        case .x:
            return LinearGradient(
                colors: [Color.adaptiveBlue(), Color.xoCyanBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .o:
            return LinearGradient(
                colors: [Color.adaptiveOrange(), Color.xoOrangeRed],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var cellGlowColor: Color {
        switch cell {
        case .empty:
            return Color.clear
        case .x:
            return Color.adaptiveBlue()
        case .o:
            return Color.adaptiveOrange()
        }
    }
    
    private var cellScale: CGFloat {
        if isInteractive {
            return isPressed ? 0.95 : 1.0
        }
        return 1.0
    }
    
    private var cellRotation: Double {
        if cell != .empty {
            return isPressed ? 5 : 0
        }
        return 0
    }
    
    private var cellGlowIntensity: CGFloat {
        if isInteractive {
            return isPressed ? 0.8 : 0.4
        }
        return cell != .empty ? 0.6 : 0
    }
    
    private var cellBounceEffect: CGFloat {
        if cell != .empty && !isPressed {
            return 1.05
        }
        return 1.0
    }
    
    private var cellPulseEffect: CGFloat {
        if isInteractive && !isPressed {
            return 1.0 + 0.02 * sin(Date().timeIntervalSince1970 * 3)
        }
        return 1.0
    }
    
    private var cellShimmerEffect: CGFloat {
        if cell != .empty {
            return 0.8 + 0.2 * sin(Date().timeIntervalSince1970 * 2)
        }
        return 1.0
    }
    
    private var cellGlowRadius: CGFloat {
        if isInteractive {
            return isPressed ? 12 : 8
        }
        return cell != .empty ? 10 : 0
    }
    

    
    private var cellAccessibilityTraits: AccessibilityTraits {
        var traits: AccessibilityTraits = []
        
        if isInteractive {
            _ = traits.insert(.isButton)
        }
        
        if cell != .empty {
            _ = traits.insert(.isStaticText)
        }
        
        // Add selected trait if cell is marked
        if cell != .empty {
            _ = traits.insert(.isSelected)
        }
        
        return traits
    }
}

// MARK: - Preview

#Preview {
    let boardWithMoves = {
        var board = Board(id: 1)
        board.cells[0] = .x
        board.cells[4] = .o
        board.cells[8] = .x
        return board
    }()
    
    let winningBoard = {
        var board = Board(id: 2)
        board.cells[0] = .x
        board.cells[1] = .x
        board.cells[2] = .x
        board.winner = .x
        return board
    }()
    
    return VStack(spacing: 20) {
        // Empty board
        TicTacToeBoard(
            board: Board(id: 0),
            onCellTap: { _ in }
        )
        
        // Board with moves
        TicTacToeBoard(
            board: boardWithMoves,
            onCellTap: { _ in }
        )
        
        // Winning board
        TicTacToeBoard(
            board: winningBoard,
            onCellTap: { _ in }
        )
    }
    .padding()
    .background(LinearGradient.xoBackgroundGradient)
    .ignoresSafeArea()
} 