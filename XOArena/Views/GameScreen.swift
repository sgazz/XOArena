import SwiftUI
import Observation

// MARK: - Main Game Screen

struct GameScreen: View {
    let gameViewModel: GameViewModel
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var isHighContrast = false
    
    @State private var showingPauseMenu = false
    @State private var showingVictory = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient.xoBackgroundGradient
                    .ignoresSafeArea()
                
                // Light effects in background
                BackgroundLightEffects()
                
                VStack(spacing: 0) {
                    // Header
                    GameHeader(gameViewModel: gameViewModel)
                    
                    // Game content
                    GameContent(gameViewModel: gameViewModel)
                    
                    // Footer controls
                    GameFooter(gameViewModel: gameViewModel)
                }
            }
        }
        .onAppear {
            // Game content is now fully visible without scrolling
        }
        .onChange(of: gameViewModel.gameState) { oldState, newState in
            if newState == .paused {
                FeedbackManager.shared.buttonPressed()
            } else if newState == .menu {
                FeedbackManager.shared.buttonPressed()
            }
        }
        .sheet(isPresented: $showingPauseMenu) {
            PauseMenuView(gameViewModel: gameViewModel)
        }
        .sheet(isPresented: $showingVictory) {
            VictoryScreen(
                gameViewModel: gameViewModel,
                onPlayAgain: {
                    showingVictory = false
                    gameViewModel.resetGame()
                },
                onMainMenu: {
                    showingVictory = false
                    gameViewModel.gameState = .menu
                }
            )
        }
        .onChange(of: gameViewModel.showVictory) { oldValue, newValue in
            showingVictory = newValue
            if newValue {
                HapticManager.shared.victoryCelebration()
            }
        }
        .withParticleSystem()
        .keyboardNavigation(onKeyPress: { key in
            switch key {
            case .leftArrow:
                let previousBoard = (gameViewModel.currentBoardIndex - 1 + 8) % 8
                gameViewModel.setActiveBoard(previousBoard)
                HapticManager.shared.boardNavigation()
            case .rightArrow:
                let nextBoard = (gameViewModel.currentBoardIndex + 1) % 8
                gameViewModel.setActiveBoard(nextBoard)
                HapticManager.shared.boardNavigation()
            case .space:
                // Toggle pause
                if gameViewModel.gameState == .playing {
                    gameViewModel.pauseGame()
                } else {
                    gameViewModel.resumeGame()
                }
            default:
                break
            }
        })
        .highContrastSupport(isHighContrast: isHighContrast)
        .dynamicTypeSupport()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("XO Arena Game Screen")
        .accessibilityAddTraits(.allowsDirectInteraction)
    }
}

// MARK: - Game Header

private struct GameHeader: View {
    let gameViewModel: GameViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var isHighContrast = false
    @State private var showingPauseMenu = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Header with controls and scores
            HStack(spacing: 16) {
                // Pause button
                Button("Pause") {
                    HapticManager.shared.impact(.medium)
                    gameViewModel.pauseGame()
                    showingPauseMenu = true
                }
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.xoTextMuted)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.xoDarkMetallic.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.xoTextMuted.opacity(0.2), lineWidth: 1)
                        )
                )
                .hoverEffect()
                .accessibilityLabel("Pause Game")
                .accessibilityHint("Pause the current game")
                
                // Separator
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.clear, Color.xoTextMuted.opacity(0.4), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 1, height: 32)
                
                // Player X Score
                ScoreDisplay(player: .x, score: gameViewModel.xScore, isLeading: gameViewModel.xScore > gameViewModel.oScore)
                
                // Player O Score
                ScoreDisplay(player: .o, score: gameViewModel.oScore, isLeading: gameViewModel.oScore > gameViewModel.xScore)
                
                // Separator
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.clear, Color.xoTextMuted.opacity(0.4), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 1, height: 32)
                
                // Reset button
                Button("Reset") {
                    HapticManager.shared.impact(.medium)
                    gameViewModel.resetGame()
                }
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.xoTextMuted)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.xoDarkMetallic.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.xoTextMuted.opacity(0.2), lineWidth: 1)
                        )
                )
                .hoverEffect()
                .accessibilityLabel("Reset Game")
                .accessibilityHint("Start a new game")
            }
            .frame(maxWidth: .infinity)
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: gameViewModel.xScore)
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: gameViewModel.oScore)
            

            
            // Timer (if timed mode)
            if gameViewModel.gameMode == .timed {
                TimerDisplay(gameViewModel: gameViewModel)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: gameViewModel.timeRemaining)
            }
            
            // Accessibility status bar (only visible when VoiceOver is active)
            if UIAccessibility.isVoiceOverRunning {
                AccessibilityStatusBar(
                    currentPlayer: gameViewModel.currentPlayer,
                    xScore: gameViewModel.xScore,
                    oScore: gameViewModel.oScore,
                    currentBoard: gameViewModel.currentBoardIndex,
                    gameMode: gameViewModel.gameMode,
                    timeRemaining: gameViewModel.gameMode == .timed ? gameViewModel.timeRemaining : nil
                )
            }
        }
        .padding(.horizontal, headerHorizontalPadding)
        .padding(.top, headerTopPadding)
        .sheet(isPresented: $showingPauseMenu) {
            PauseMenuView(gameViewModel: gameViewModel)
        }
    }
    
    private var headerHorizontalPadding: CGFloat {
        switch horizontalSizeClass {
        case .regular:
            return 20
        case .compact:
            return 12
        case .none:
            return 16
        @unknown default:
            return 16
        }
    }
    
    private var headerTopPadding: CGFloat {
        switch verticalSizeClass {
        case .regular:
            return 6
        case .compact:
            return 3
        case .none:
            return 4
        @unknown default:
            return 4
        }
    }
    

}

// MARK: - Game Content

private struct GameContent: View {
    let gameViewModel: GameViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var isHighContrast = false
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - (horizontalPadding * 2)
            let availableHeight = geometry.size.height - (verticalPadding * 2)
            
            // Calculate optimal board size and spacing
            let optimalBoardSize = min(availableWidth / 2, availableHeight / 4) // Show 2 boards per row
            let actualBoardSize = min(optimalBoardSize, boardSize)
            let actualSpacing = min(boardSpacing, max(6, (availableWidth - (actualBoardSize * 2)) / 1))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: actualSpacing), count: 2), spacing: 8) {
                ForEach(0..<gameViewModel.boards.count, id: \.self) { index in
                    VStack(spacing: 4) {
                        // Simple board indicator
                        Text("BOARD \(index + 1)")
                            .font(.system(size: boardLabelFontSize, weight: .bold))
                            .foregroundColor(gameViewModel.boards[safe: index]?.isActive == true ? Color.adaptiveGold(isHighContrast: isHighContrast) : .xoTextMuted)
                            .accessibilityLabel("Board \(index + 1)")
                            .accessibilityHint(gameViewModel.boards[safe: index]?.isActive == true ? "Currently active" : "Not active")
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                        
                        // Board
                        TicTacToeBoard(
                            board: gameViewModel.boards[safe: index] ?? Board(id: index),
                            isInteractive: gameViewModel.boards[safe: index]?.isActive == true
                        ) { cellIndex in
                            gameViewModel.makeMove(at: cellIndex)
                        }
                        .frame(width: actualBoardSize, height: actualBoardSize)
                        .opacity(gameViewModel.boards[safe: index]?.isActive == true ? 1.0 : 0.5)
                        .overlay(
                            // Simple active indicator
                            Group {
                                if gameViewModel.boards[safe: index]?.isActive == true {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.adaptiveGold(isHighContrast: isHighContrast), lineWidth: 2)
                                }
                            }
                        )
                        .overlay(
                            // Simple AI indicator
                            Group {
                                if gameViewModel.isAIMoving && gameViewModel.boards[safe: index]?.isActive == true {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color.adaptiveGold(isHighContrast: isHighContrast)))
                                        .scaleEffect(1.5)
                                        .background(
                                            Circle()
                                                .fill(Color.black.opacity(0.3))
                                                .frame(width: 40, height: 40)
                                        )
                                }
                            }
                        )
                    }
                    .id(index)
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
        }
    }
    
    // MARK: - Computed Properties
    
    private var boardSpacing: CGFloat {
        switch horizontalSizeClass {
        case .regular:
            return verticalSizeClass == .regular ? 16 : 12
        case .compact:
            return 10
        case .none:
            return 12
        @unknown default:
            return 12
        }
    }
    
    private var boardLabelFontSize: CGFloat {
        let baseSize: CGFloat = horizontalSizeClass == .regular ? 14 : 12
        
        switch dynamicTypeSize {
        case .xSmall, .small:
            return baseSize
        case .medium:
            return baseSize * 0.95
        case .large:
            return baseSize * 0.9
        case .xLarge:
            return baseSize * 0.85
        case .xxLarge:
            return baseSize * 0.8
        case .xxxLarge:
            return baseSize * 0.75
        case .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            return baseSize * 0.7
        @unknown default:
            return baseSize * 0.95
        }
    }
    
    private var boardSize: CGFloat {
        switch horizontalSizeClass {
        case .regular:
            return verticalSizeClass == .regular ? 200 : 180
        case .compact:
            return 160
        case .none:
            return 170
        @unknown default:
            return 170
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch horizontalSizeClass {
        case .regular:
            return 12
        case .compact:
            return 8
        case .none:
            return 10
        @unknown default:
            return 10
        }
    }
    
    private var verticalPadding: CGFloat {
        switch verticalSizeClass {
        case .regular:
            return 8
        case .compact:
            return 6
        case .none:
            return 7
        @unknown default:
            return 7
        }
    }
    

}

// MARK: - Game Footer

private struct GameFooter: View {
    let gameViewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            // Footer is now minimal since controls are in header
        }
        .padding(.horizontal)
        .padding(.bottom, 4)
    }
}

// MARK: - Supporting Views

private struct ScoreDisplay: View {
    let player: Player
    let score: Int
    let isLeading: Bool
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var body: some View {
        HStack(spacing: 6) {
            Text(player.displayName)
                .font(.system(size: labelFontSize, weight: .medium))
                .foregroundColor(.xoTextMuted)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            
            Text("\(score)")
                .font(.system(size: scoreFontSize, weight: .bold))
                .scoreDisplay(player: player, isLeading: isLeading)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .accessibilityLabel("\(player.displayName) score: \(score)")
        .accessibilityValue(AccessibilityEnhancements.scoreAccessibilityValue(
            player: player,
            score: score,
            isLeading: isLeading
        ))
        .accessibilityHint(isLeading ? "Currently leading" : "Not leading")
    }
    
    private var labelFontSize: CGFloat {
        let baseSize: CGFloat = 10
        
        switch dynamicTypeSize {
        case .xSmall, .small:
            return baseSize
        case .medium:
            return baseSize * 0.95
        case .large:
            return baseSize * 0.9
        case .xLarge:
            return baseSize * 0.85
        case .xxLarge:
            return baseSize * 0.8
        case .xxxLarge:
            return baseSize * 0.75
        case .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            return baseSize * 0.7
        @unknown default:
            return baseSize * 0.95
        }
    }
    
    private var scoreFontSize: CGFloat {
        let baseSize: CGFloat = 18
        
        switch dynamicTypeSize {
        case .xSmall, .small:
            return baseSize
        case .medium:
            return baseSize * 0.95
        case .large:
            return baseSize * 0.9
        case .xLarge:
            return baseSize * 0.85
        case .xxLarge:
            return baseSize * 0.8
        case .xxxLarge:
            return baseSize * 0.75
        case .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            return baseSize * 0.7
        @unknown default:
            return baseSize * 0.95
        }
    }
}

private struct TimerDisplay: View {
    let gameViewModel: GameViewModel
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(Color.adaptiveBlue())
                    .font(.system(size: iconFontSize))
                
                Text(timeString)
                    .font(.system(size: timerFontSize, weight: .bold))
                    .timerDisplay(timeRemaining: gameViewModel.timeRemaining, totalTime: TimeInterval(gameViewModel.timerDuration.rawValue))
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.xoDarkMetallic.opacity(0.3))
                        .frame(height: 6)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [Color.adaptiveBlue(), Color.xoCyanBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 6)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: 6)
        }
        .accessibilityLabel("Time remaining: \(timeString)")
        .accessibilityValue(AccessibilityEnhancements.timerAccessibilityLabel(
            timeRemaining: gameViewModel.timeRemaining,
            totalTime: TimeInterval(gameViewModel.timerDuration.rawValue)
        ))
    }
    
    private var timeString: String {
        let minutes = Int(gameViewModel.timeRemaining) / 60
        let seconds = Int(gameViewModel.timeRemaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private var progress: Double {
        let totalTime = Double(gameViewModel.timerDuration.rawValue)
        return max(0, min(1, gameViewModel.timeRemaining / totalTime))
    }
    
    private var iconFontSize: CGFloat {
        let baseSize: CGFloat = 20
        
        switch dynamicTypeSize {
        case .xSmall, .small:
            return baseSize
        case .medium:
            return baseSize * 0.95
        case .large:
            return baseSize * 0.9
        case .xLarge:
            return baseSize * 0.85
        case .xxLarge:
            return baseSize * 0.8
        case .xxxLarge:
            return baseSize * 0.75
        case .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            return baseSize * 0.7
        @unknown default:
            return baseSize * 0.95
        }
    }
    
    private var timerFontSize: CGFloat {
        let baseSize: CGFloat = 24
        
        switch dynamicTypeSize {
        case .xSmall, .small:
            return baseSize
        case .medium:
            return baseSize * 0.95
        case .large:
            return baseSize * 0.9
        case .xLarge:
            return baseSize * 0.85
        case .xxLarge:
            return baseSize * 0.8
        case .xxxLarge:
            return baseSize * 0.75
        case .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            return baseSize * 0.7
        @unknown default:
            return baseSize * 0.95
        }
    }
}





private struct BackgroundLightEffects: View {
    var body: some View {
        ZStack {
            // Stadium lights effect
            VStack {
                HStack(spacing: 40) {
                    ForEach(0..<5) { _ in
                        Circle()
                            .fill(RadialGradient.xoBlueGlowGradient)
                            .frame(width: 20, height: 20)
                            .blur(radius: 10)
                    }
                }
                Spacer()
            }
            .padding(.top, 50)
            
            // Light trails
            VStack {
                HStack {
                    Rectangle()
                        .fill(LinearGradient.xoBlueGradient)
                        .frame(width: 2, height: 100)
                        .blur(radius: 3)
                        .opacity(0.6)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(LinearGradient.xoOrangeGradient)
                        .frame(width: 2, height: 100)
                        .blur(radius: 3)
                        .opacity(0.6)
                }
                Spacer()
            }
            .padding(.top, 100)
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Preview

#Preview {
    let mockViewModel = GameViewModel()
    mockViewModel.xScore = 2
    mockViewModel.oScore = 1
    mockViewModel.gameMode = .classic
    
    return GameScreen(gameViewModel: mockViewModel)
} 