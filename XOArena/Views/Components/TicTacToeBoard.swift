import SwiftUI

// MARK: - Enhanced TicTacToe Board Component

struct TicTacToeBoard: View {
    let board: Board
    let onCellTap: (Int) -> Void
    let isInteractive: Bool
    
    @State private var pressedCell: Int?
    @State private var hoveredCell: Int?
    @State private var boardScale: CGFloat = 1.0
    @State private var boardRotation: Double = 0
    @State private var isBoardAnimating = false
    
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
                            isHovered: hoveredCell == index,
                            isInteractive: isInteractive && board.cells[index] == .empty,
                            position: (row, column),
                            boardState: boardState
                        ) {
                            handleCellTap(index)
                        } onHover: { isHovered in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                hoveredCell = isHovered ? index : nil
                            }
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(
            // Enhanced board background with 3D effect
            ZStack {
                // Base metallic background
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient.xoMetallicGradient)
                    .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 6)
                
                // Inner depth effect
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.xoDarkerBackground.opacity(0.8),
                                Color.xoDarkBackground.opacity(0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .padding(2)
                
                // Border with glow
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [Color.xoDarkMetallic, Color.xoMetallicSilver],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            }
        )
        .overlay(
            // Winner celebration overlay
            Group {
                if let winner = board.winner {
                    WinnerCelebrationOverlay(winner: winner)
                }
            }
        )
        .scaleEffect(boardScale)
        .rotation3DEffect(
            .degrees(boardRotation),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: boardScale)
        .animation(.easeInOut(duration: 0.8), value: boardRotation)
        .onAppear {
            animateBoardAppearance()
        }
        .onChange(of: board.winner) { _, winner in
            if winner != nil {
                animateWinnerCelebration()
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
    
    // MARK: - Animation Methods
    
    private func animateBoardAppearance() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
            boardScale = 1.0
        }
        
        withAnimation(.easeInOut(duration: 1.2).delay(0.3)) {
            boardRotation = 360
        }
    }
    
    private func animateWinnerCelebration() {
        // Board celebration animation
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            boardScale = 1.05
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                boardScale = 1.0
            }
        }
        
        // Particle effect
        let center = CGPoint(
            x: UIScreen.main.bounds.width * 0.5,
            y: UIScreen.main.bounds.height * 0.5
        )
        particleManager.createBoardWinEffect(at: center, player: board.winner!)
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
    let isHovered: Bool
    let isInteractive: Bool
    let position: (row: Int, column: Int)
    let boardState: BoardState
    let onTap: () -> Void
    let onHover: (Bool) -> Void
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var particleManager: ParticleManager
    
    @State private var isAnimating = false
    @State private var cellFrame: CGRect = .zero
    @State private var shimmerOffset: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Enhanced cell background with 3D effect
                RoundedRectangle(cornerRadius: 12)
                    .fill(cellBackground)
                    .overlay(
                        // Inner depth
                        RoundedRectangle(cornerRadius: 10)
                            .fill(cellInnerBackground)
                            .padding(1)
                    )
                    .overlay(
                        // Border with glow
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(cellBorder, lineWidth: cellBorderWidth)
                            .shadow(color: cellGlowColor.opacity(0.6), radius: cellGlowRadius)
                    )
                    .shadow(
                        color: cellShadowColor,
                        radius: cellShadowRadius,
                        x: cellShadowOffset.x,
                        y: cellShadowOffset.y
                    )
                    .scaleEffect(cellScale)
                    .rotation3DEffect(
                        .degrees(cellRotation),
                        axis: (x: cellRotationAxis.x, y: cellRotationAxis.y, z: cellRotationAxis.z)
                    )
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isPressed)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: cell)
                    .animation(.easeInOut(duration: 0.3), value: isHovered)
                
                // Shimmer effect for interactive cells
                if isInteractive && isHovered {
                    ShimmerEffect()
                        .mask(
                            RoundedRectangle(cornerRadius: 12)
                        )
                }
                
                // Cell content with enhanced animations
                if cell != .empty {
                    ZStack {
                        // Background glow
                        RoundedRectangle(cornerRadius: 8)
                            .fill(cellContentGlow)
                            .blur(radius: 8)
                            .scaleEffect(pulseScale)
                            .opacity(0.6)
                        
                        // Main content
                        Text(cell.displayValue)
                            .font(.system(size: cellFontSize, weight: .bold, design: .rounded))
                            .foregroundStyle(cellTextGradient)
                            .glow(color: cellGlowColor, radius: cellGlowRadius)
                            .minimumScaleFactor(0.5)
                            .scaleEffect(isAnimating ? 1.15 : 1.0)
                            .rotationEffect(.degrees(isAnimating ? 5 : 0))
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isAnimating)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isInteractive)
        .onHover { isHovered in
            onHover(isHovered)
        }
        .onAppear {
            if cell != .empty {
                animateCellAppearance()
            }
        }
        .onChange(of: cell) { _, newCell in
            if newCell != .empty {
                animateCellChange(newCell)
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
    
    private var cellBackground: LinearGradient {
        switch cell {
        case .empty:
            return LinearGradient(
                colors: [
                    Color.xoDarkerBackground.opacity(0.9),
                    Color.xoDarkBackground.opacity(0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .x:
            return LinearGradient(
                colors: [
                    Color.adaptiveBlue().opacity(0.3),
                    Color.xoCyanBlue.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .o:
            return LinearGradient(
                colors: [
                    Color.adaptiveOrange().opacity(0.3),
                    Color.xoOrangeRed.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var cellInnerBackground: LinearGradient {
        switch cell {
        case .empty:
            return LinearGradient(
                colors: [
                    Color.xoDarkBackground.opacity(0.5),
                    Color.xoDarkerBackground.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .x:
            return LinearGradient(
                colors: [
                    Color.adaptiveBlue().opacity(0.1),
                    Color.xoCyanBlue.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .o:
            return LinearGradient(
                colors: [
                    Color.adaptiveOrange().opacity(0.1),
                    Color.xoOrangeRed.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var cellBorder: Color {
        switch cell {
        case .empty:
            return isHovered ? Color.xoGold.opacity(0.6) : Color.xoDarkMetallic
        case .x:
            return Color.adaptiveBlue()
        case .o:
            return Color.adaptiveOrange()
        }
    }
    
    private var cellBorderWidth: CGFloat {
        switch cell {
        case .empty:
            return isHovered ? 2 : 1
        case .x, .o:
            return 2
        }
    }
    
    private var cellShadowColor: Color {
        switch cell {
        case .empty:
            return isHovered ? Color.xoGold.opacity(0.3) : Color.black.opacity(0.3)
        case .x:
            return Color.adaptiveBlue().opacity(0.5)
        case .o:
            return Color.adaptiveOrange().opacity(0.5)
        }
    }
    
    private var cellShadowRadius: CGFloat {
        switch cell {
        case .empty:
            return isHovered ? 8 : 4
        case .x, .o:
            return 6
        }
    }
    
    private var cellShadowOffset: (x: CGFloat, y: CGFloat) {
        switch cell {
        case .empty:
            return isHovered ? (0, 3) : (0, 2)
        case .x, .o:
            return (0, 3)
        }
    }
    
    private var cellTextGradient: LinearGradient {
        switch cell {
        case .empty:
            return LinearGradient(colors: [Color.clear], startPoint: .center, endPoint: .center)
        case .x:
            return LinearGradient(
                colors: [
                    Color.adaptiveBlue(),
                    Color.xoCyanBlue,
                    Color.adaptiveBlue()
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .o:
            return LinearGradient(
                colors: [
                    Color.adaptiveOrange(),
                    Color.xoOrangeRed,
                    Color.adaptiveOrange()
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var cellContentGlow: LinearGradient {
        switch cell {
        case .empty:
            return LinearGradient(colors: [Color.clear], startPoint: .center, endPoint: .center)
        case .x:
            return LinearGradient(
                colors: [
                    Color.adaptiveBlue().opacity(0.8),
                    Color.xoCyanBlue.opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .o:
            return LinearGradient(
                colors: [
                    Color.adaptiveOrange().opacity(0.8),
                    Color.xoOrangeRed.opacity(0.6)
                ],
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
    
    private var cellGlowRadius: CGFloat {
        switch cell {
        case .empty:
            return 0
        case .x, .o:
            return isAnimating ? 15 : 12
        }
    }
    
    private var cellScale: CGFloat {
        if isInteractive {
            if isPressed {
                return 0.92
            } else if isHovered {
                return 1.05
            }
        }
        return 1.0
    }
    
    private var cellRotation: Double {
        if cell != .empty {
            return isAnimating ? 8 : 0
        }
        return 0
    }
    
    private var cellRotationAxis: (x: Double, y: Double, z: Double) {
        if cell != .empty {
            return (x: 0, y: 0, z: isAnimating ? 1 : 0)
        }
        return (x: 0, y: 0, z: 0)
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
    
    // MARK: - Animation Methods
    
    private func animateCellAppearance() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isAnimating = false
            }
        }
    }
    
    private func animateCellChange(_ newCell: Cell) {
        // Trigger animation
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            isAnimating = true
        }
        
        // Create particle effect
        let center = CGPoint(
            x: cellFrame.midX,
            y: cellFrame.midY
        )
        let player: Player = newCell == .x ? .x : .o
        particleManager.createMoveEffect(at: center, player: player)
        
        // Pulse animation
        withAnimation(.easeInOut(duration: 0.3)) {
            pulseScale = 1.2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isAnimating = false
                pulseScale = 1.0
            }
        }
    }
}

// MARK: - Shimmer Effect Component

struct ShimmerEffect: View {
    @State private var shimmerOffset: CGFloat = -1
    
    var body: some View {
        LinearGradient(
            colors: [
                Color.clear,
                Color.xoGold.opacity(0.3),
                Color.clear
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .offset(x: shimmerOffset)
        .onAppear {
            withAnimation(
                .linear(duration: 1.5)
                .repeatForever(autoreverses: false)
            ) {
                shimmerOffset = 1
            }
        }
    }
}

// MARK: - Winner Celebration Overlay

struct WinnerCelebrationOverlay: View {
    let winner: Player
    
    @State private var celebrationScale: CGFloat = 0
    @State private var celebrationOpacity: Double = 0
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Background glow
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    RadialGradient(
                        colors: [
                            winner == .x ? Color.adaptiveBlue().opacity(0.3) : Color.adaptiveOrange().opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .scaleEffect(celebrationScale)
                .opacity(celebrationOpacity)
            
            // Border glow
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    winner == .x ? Color.adaptiveBlue() : Color.adaptiveOrange(),
                    lineWidth: 4
                )
                .glow(
                    color: winner == .x ? Color.adaptiveBlue() : Color.adaptiveOrange(),
                    radius: 20
                )
                .scaleEffect(celebrationScale)
                .opacity(celebrationOpacity)
        }
        .onAppear {
            animateCelebration()
        }
    }
    
    private func animateCelebration() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            celebrationScale = 1.0
            celebrationOpacity = 1.0
        }
        
        withAnimation(
            .easeInOut(duration: 2.0)
            .repeatForever(autoreverses: true)
        ) {
            isAnimating = true
        }
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