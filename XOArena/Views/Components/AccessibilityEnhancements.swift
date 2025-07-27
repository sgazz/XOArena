import SwiftUI

// MARK: - Accessibility Enhancements

struct AccessibilityEnhancements {
    
    // MARK: - Board Accessibility
    
    static func boardAccessibilityLabel(boardIndex: Int, isActive: Bool, winner: Player?, isCompleted: Bool) -> String {
        var label = "Board \(boardIndex + 1)"
        
        if isActive {
            label += ", currently active"
        }
        
        if let winner = winner {
            label += ", won by \(winner.displayName)"
        } else if isCompleted {
            label += ", draw"
        }
        
        return label
    }
    
    static func boardAccessibilityHint(isActive: Bool, isCompleted: Bool) -> String {
        if isCompleted {
            return "This board is completed and cannot be played on"
        } else if isActive {
            return "This is the current active board. Tap cells to make moves"
        } else {
            return "This board is not currently active"
        }
    }
    
    // MARK: - Cell Accessibility
    
    static func cellAccessibilityLabel(row: Int, column: Int, cell: Cell, isInteractive: Bool) -> String {
        let position = "Row \(row + 1), Column \(column + 1)"
        
        switch cell {
        case .empty:
            return isInteractive ? "\(position), empty cell, tap to place mark" : "\(position), empty cell"
        case .x:
            return "\(position), marked by Player X"
        case .o:
            return "\(position), marked by Player O"
        }
    }
    
    static func cellAccessibilityHint(cell: Cell, isInteractive: Bool) -> String {
        if !isInteractive {
            return "This cell cannot be played on"
        }
        
        switch cell {
        case .empty:
            return "Double tap to place your mark"
        case .x, .o:
            return "This cell is already marked"
        }
    }
    
    // MARK: - Score Accessibility
    
    static func scoreAccessibilityValue(player: Player, score: Int, isLeading: Bool) -> String {
        var value = "\(player.displayName) has \(score) wins"
        
        if isLeading {
            value += ", currently leading"
        }
        
        return value
    }
    
    // MARK: - Timer Accessibility
    
    static func timerAccessibilityLabel(timeRemaining: TimeInterval, totalTime: TimeInterval) -> String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        let timeString = String(format: "%d minutes and %d seconds", minutes, seconds)
        
        let progress = timeRemaining / totalTime
        let percentage = Int(progress * 100)
        
        var status = ""
        if progress <= 0.2 {
            status = ", critical time remaining"
        } else if progress <= 0.5 {
            status = ", time is running low"
        }
        
        return "\(timeString) remaining, \(percentage) percent left\(status)"
    }
    
    // MARK: - Game State Accessibility
    
    static func gameStateAccessibilityLabel(gameState: GameState, currentPlayer: Player) -> String {
        switch gameState {
        case .menu:
            return "Main menu"
        case .playing:
            return "Game in progress, \(currentPlayer.displayName)'s turn"
        case .paused:
            return "Game paused"
        case .finished:
            return "Game finished"
        }
    }
    
    // MARK: - AI Accessibility
    
    static func aiAccessibilityLabel(isAIGame: Bool, aiDifficulty: AIDifficulty, aiPlayer: Player) -> String {
        if !isAIGame {
            return "Playing against another human"
        }
        
        return "Playing against \(aiDifficulty.displayName) AI as \(aiPlayer.displayName)"
    }
    
    static func aiThinkingAccessibilityLabel() -> String {
        return "AI is thinking, please wait"
    }
    
    // MARK: - Move Announcements
    
    static func moveAccessibilityLabel(player: Player, boardIndex: Int, cellPosition: String) -> String {
        return "\(player.displayName) placed mark on board \(boardIndex + 1), \(cellPosition)"
    }
    
    static func boardWinAccessibilityLabel(player: Player, boardIndex: Int) -> String {
        return "\(player.displayName) wins board \(boardIndex + 1)"
    }
    
    static func boardDrawAccessibilityLabel(boardIndex: Int) -> String {
        return "Board \(boardIndex + 1) is a draw"
    }
    
    static func boardTransitionAccessibilityLabel(to boardIndex: Int) -> String {
        return "Moving to board \(boardIndex + 1)"
    }
    
    static func gameWinAccessibilityLabel(player: Player) -> String {
        return "\(player.displayName) wins the game! Congratulations!"
    }
    
    static func gameDrawAccessibilityLabel() -> String {
        return "The game is a draw. Well played by both players!"
    }
    
    // MARK: - Timer Warnings
    
    static func timerWarningAccessibilityLabel(timeRemaining: TimeInterval) -> String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        
        if timeRemaining <= 10 {
            return "Critical warning: Only \(minutes) minutes and \(seconds) seconds remaining!"
        } else if timeRemaining <= 30 {
            return "Warning: \(minutes) minutes and \(seconds) seconds remaining"
        } else {
            return "\(minutes) minutes and \(seconds) seconds remaining"
        }
    }
    
    // MARK: - Button Accessibility
    
    static func buttonAccessibilityLabel(title: String, action: String) -> String {
        return "\(title) button"
    }
    
    static func buttonAccessibilityHint(action: String) -> String {
        return "Double tap to \(action)"
    }
    
    // MARK: - Settings Accessibility
    
    static func settingAccessibilityLabel(setting: String, value: String) -> String {
        return "\(setting): \(value)"
    }
    
    static func settingAccessibilityHint(setting: String, isSelected: Bool) -> String {
        if isSelected {
            return "\(setting) is currently selected"
        } else {
            return "Double tap to select \(setting)"
        }
    }
    
    // MARK: - Navigation Accessibility
    
    static func navigationAccessibilityLabel(direction: String, target: String) -> String {
        return "Navigate \(direction) to \(target)"
    }
    
    static func navigationAccessibilityHint(direction: String) -> String {
        return "Double tap to go \(direction)"
    }
    
    // MARK: - Victory Accessibility
    
    static func victoryAccessibilityLabel(winner: Player?, isDraw: Bool) -> String {
        if isDraw {
            return "Game ended in a draw"
        } else if let winner = winner {
            return "\(winner.displayName) wins the game!"
        } else {
            return "Game finished"
        }
    }
    
    static func victoryAccessibilityHint(winner: Player?, isDraw: Bool) -> String {
        if isDraw {
            return "Both players fought valiantly to a draw"
        } else if let winner = winner {
            return "\(winner.displayName) is the champion of XO Arena!"
        } else {
            return "The game has concluded"
        }
    }
    
    // MARK: - Statistics Accessibility
    
    static func statisticsAccessibilityLabel(xWins: Int, oWins: Int, draws: Int) -> String {
        return "Game statistics: Player X has \(xWins) wins, Player O has \(oWins) wins, and there are \(draws) draws"
    }
    
    // MARK: - Tutorial Accessibility
    
    static func tutorialStepAccessibilityLabel(step: Int, title: String, description: String) -> String {
        return "Step \(step): \(title). \(description)"
    }
    
    // MARK: - Error Accessibility
    
    static func errorAccessibilityLabel(error: String) -> String {
        return "Error: \(error)"
    }
    
    static func errorAccessibilityHint(error: String) -> String {
        return "An error occurred: \(error). Please try again."
    }
    
    // MARK: - Loading Accessibility
    
    static func loadingAccessibilityLabel(operation: String) -> String {
        return "Loading \(operation), please wait"
    }
    
    // MARK: - Success Accessibility
    
    static func successAccessibilityLabel(action: String) -> String {
        return "\(action) completed successfully"
    }
}

// MARK: - Accessibility Announcer

class AccessibilityAnnouncer: ObservableObject {
    static let shared = AccessibilityAnnouncer()
    
    private init() {}
    
    func announceMove(player: Player, boardIndex: Int, cellPosition: String) {
        let message = AccessibilityEnhancements.moveAccessibilityLabel(
            player: player,
            boardIndex: boardIndex,
            cellPosition: cellPosition
        )
        UIAccessibility.post(notification: .announcement, argument: message)
    }
    
    func announceBoardWin(player: Player, boardIndex: Int) {
        let message = AccessibilityEnhancements.boardWinAccessibilityLabel(
            player: player,
            boardIndex: boardIndex
        )
        UIAccessibility.post(notification: .announcement, argument: message)
    }
    
    func announceBoardDraw(boardIndex: Int) {
        let message = AccessibilityEnhancements.boardDrawAccessibilityLabel(boardIndex: boardIndex)
        UIAccessibility.post(notification: .announcement, argument: message)
    }
    
    func announceBoardTransition(to boardIndex: Int) {
        let message = AccessibilityEnhancements.boardTransitionAccessibilityLabel(to: boardIndex)
        UIAccessibility.post(notification: .announcement, argument: message)
    }
    
    func announceGameWin(player: Player) {
        let message = AccessibilityEnhancements.gameWinAccessibilityLabel(player: player)
        UIAccessibility.post(notification: .announcement, argument: message)
    }
    
    func announceGameDraw() {
        let message = AccessibilityEnhancements.gameDrawAccessibilityLabel()
        UIAccessibility.post(notification: .announcement, argument: message)
    }
    
    func announceTimerWarning(timeRemaining: TimeInterval) {
        let message = AccessibilityEnhancements.timerWarningAccessibilityLabel(timeRemaining: timeRemaining)
        UIAccessibility.post(notification: .announcement, argument: message)
    }
    
    func announceAIThinking() {
        let message = AccessibilityEnhancements.aiThinkingAccessibilityLabel()
        UIAccessibility.post(notification: .announcement, argument: message)
    }
    
    func announceError(_ error: String) {
        let message = AccessibilityEnhancements.errorAccessibilityLabel(error: error)
        UIAccessibility.post(notification: .announcement, argument: message)
    }
    
    func announceSuccess(_ action: String) {
        let message = AccessibilityEnhancements.successAccessibilityLabel(action: action)
        UIAccessibility.post(notification: .announcement, argument: message)
    }
}

// MARK: - Accessibility Focus Manager

class AccessibilityFocusManager: ObservableObject {
    static let shared = AccessibilityFocusManager()
    
    @Published var focusedElement: String?
    
    private init() {}
    
    func focusOn(_ element: String) {
        focusedElement = element
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
    
    func focusOnBoard(_ boardIndex: Int) {
        focusOn("board_\(boardIndex)")
    }
    
    func focusOnCell(_ boardIndex: Int, row: Int, column: Int) {
        focusOn("cell_\(boardIndex)_\(row)_\(column)")
    }
    
    func focusOnButton(_ buttonTitle: String) {
        focusOn("button_\(buttonTitle.lowercased().replacingOccurrences(of: " ", with: "_"))")
    }
    
    func clearFocus() {
        focusedElement = nil
    }
}

// MARK: - Accessibility Trait Extensions

extension AccessibilityTraits {
    static let gameBoard = AccessibilityTraits()
    static let gameCell = AccessibilityTraits()
    static let scoreDisplay = AccessibilityTraits()
    static let timerDisplay = AccessibilityTraits()
    static let playerIndicator = AccessibilityTraits()
}

// MARK: - Accessibility Action Extensions

extension View {
    func accessibilityAction(named name: String, action: @escaping () -> Void) -> some View {
        self.accessibilityAction(named: Text(name)) {
            action()
        }
    }
    
    func accessibilityAddAction(named name: String, action: @escaping () -> Void) -> some View {
        self.accessibilityAction(named: name, action: action)
    }
    
    func accessibilityRemoveAction(named name: String) -> some View {
        self.accessibilityAction(named: name) {
            // No action
        }
    }
}

// MARK: - Accessibility Custom Actions

struct AccessibilityCustomActions {
    static let playMove = "Play Move"
    static let selectBoard = "Select Board"
    static let pauseGame = "Pause Game"
    static let resumeGame = "Resume Game"
    static let restartGame = "Restart Game"
    static let mainMenu = "Main Menu"
    static let settings = "Settings"
    static let tutorial = "Tutorial"
    static let accessibilityHelp = "Accessibility Help"
}

// MARK: - Accessibility Help

struct AccessibilityHelp {
    static let gameDescription = """
    XO Arena is a strategic TicTacToe game played on 8 boards simultaneously. 
    Players take turns placing X and O marks on the active board. 
    After Player O makes a move, the game automatically moves to the next board. 
    The first player to win 5 out of 8 boards becomes the champion.
    """
    
    static let navigationHelp = """
    Use VoiceOver to navigate through the game. 
    Swipe left or right to move between boards. 
    Double tap to make moves on the active board. 
    Use the pause button to access game controls.
    """
    
    static let controlsHelp = """
    The game can be controlled using VoiceOver gestures or external keyboards. 
    Arrow keys navigate between boards. 
    Space bar pauses and resumes the game. 
    Enter key makes moves on the active board.
    """
    
    static let accessibilityFeatures = """
    XO Arena includes comprehensive accessibility features:
    - Full VoiceOver support with detailed announcements
    - High contrast mode for better visibility
    - Dynamic Type support for text scaling
    - Keyboard navigation support
    - Haptic feedback for important events
    - Audio cues for game state changes
    """
}

// MARK: - Keyboard Navigation Support

struct KeyboardNavigationModifier: ViewModifier {
    let onKeyPress: (KeyEquivalent) -> Void
    
    func body(content: Content) -> some View {
        content
            .onKeyPress(.space) {
                onKeyPress(.space)
                return .handled
            }
            .onKeyPress(.return) {
                onKeyPress(.return)
                return .handled
            }
            .onKeyPress(.leftArrow) {
                onKeyPress(.leftArrow)
                return .handled
            }
            .onKeyPress(.rightArrow) {
                onKeyPress(.rightArrow)
                return .handled
            }
            .onKeyPress(.upArrow) {
                onKeyPress(.upArrow)
                return .handled
            }
            .onKeyPress(.downArrow) {
                onKeyPress(.downArrow)
                return .handled
            }
    }
}

extension View {
    func keyboardNavigation(onKeyPress: @escaping (KeyEquivalent) -> Void) -> some View {
        modifier(KeyboardNavigationModifier(onKeyPress: onKeyPress))
    }
}

// MARK: - High Contrast Support

struct HighContrastModifier: ViewModifier {
    let isHighContrast: Bool
    
    func body(content: Content) -> some View {
        content
            // Note: accessibilityHighContrast environment is not available in this SwiftUI version
            // The isHighContrast parameter is passed down to child views that need it
    }
}

// Note: These functions are already defined in ViewModifiers.swift
// Removing duplicate declarations

// MARK: - Accessibility Status Bar

struct AccessibilityStatusBar: View {
    let currentPlayer: Player
    let xScore: Int
    let oScore: Int
    let currentBoard: Int
    let gameMode: GameMode
    let timeRemaining: TimeInterval?
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var body: some View {
        VStack(spacing: 8) {
            // Game status
            Text(gameStatusText)
                .font(.system(size: statusFontSize, weight: .medium))
                .foregroundColor(.xoTextPrimary)
                .multilineTextAlignment(.center)
                .accessibilityLabel("Game status: \(gameStatusText)")
            
            // Timer (if applicable)
            if let timeRemaining = timeRemaining {
                Text(timerText(timeRemaining: timeRemaining))
                    .font(.system(size: timerFontSize, weight: .bold))
                    .foregroundColor(timeRemaining < 30 ? .xoError : .xoTextSecondary)
                                    .accessibilityLabel("Time remaining: \(timerText(timeRemaining: timeRemaining))")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.xoDarkerBackground.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.xoGold, lineWidth: 1)
                )
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Game status information")
    }
    
    private var gameStatusText: String {
        return "\(currentPlayer.displayName)'s turn • X: \(xScore) • O: \(oScore) • Board \(currentBoard + 1)"
    }
    
    private func timerText(timeRemaining: TimeInterval) -> String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private var statusFontSize: CGFloat {
        switch dynamicTypeSize {
        case .xSmall, .small:
            return 14
        case .medium:
            return 13
        case .large:
            return 12
        case .xLarge:
            return 11
        case .xxLarge:
            return 10
        case .xxxLarge:
            return 9
        case .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            return 8
        @unknown default:
            return 13
        }
    }
    
    private var timerFontSize: CGFloat {
        switch dynamicTypeSize {
        case .xSmall, .small:
            return 16
        case .medium:
            return 15
        case .large:
            return 14
        case .xLarge:
            return 13
        case .xxLarge:
            return 12
        case .xxxLarge:
            return 11
        case .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            return 10
        @unknown default:
            return 15
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        AccessibilityStatusBar(
            currentPlayer: .x,
            xScore: 3,
            oScore: 2,
            currentBoard: 4,
            gameMode: .timed,
            timeRemaining: 120
        )
    }
    .padding()
    .background(LinearGradient.xoBackgroundGradient)
    .ignoresSafeArea()
} 