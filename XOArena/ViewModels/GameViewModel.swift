import Foundation
import SwiftUI

@Observable final class GameViewModel {
    
    // MARK: - Game State
    var boards: [Board] = []
    var currentBoardIndex: Int = 0
    var currentPlayer: Player = .x
    var gameState: GameState = .menu
    var isPaused: Bool = false
    
    // MARK: - Scores
    var xScore: Int = 0
    var oScore: Int = 0
    var draws: Int = 0
    
    // MARK: - Timer
    var timeRemaining: TimeInterval = 0
    var timer: Timer?
    var gameMode: GameMode = .classic
    var timerDuration: TimerDuration = .threeMinutes
    
    // MARK: - AI
    var isAIGame: Bool = false
    var aiDifficulty: AIDifficulty = .normal
    var aiPlayer: Player = .o
    var humanPlayer: Player = .x
    
    // MARK: - Settings
    var settings: GameSettings = GameSettings()
    var stats: GameStats = GameStats()
    
    // MARK: - UI State
    var showTutorial: Bool = false
    var showSettings: Bool = false
    var showVictory: Bool = false
    var winner: Player?
    var isAIMoving: Bool = false
    
    // MARK: - Particle Manager
    weak var particleManager: ParticleManager?
    
    // MARK: - Computed Properties
    
    /// Get indices of completed boards
    var completedBoardIndices: [Int] {
        return boards.enumerated().compactMap { index, board in
            return board.winner != nil || board.isFull ? index : nil
        }
    }
    
    // MARK: - Initialization
    init() {
        loadSettings()
        loadStats()
        resetGame()
    }
    
    deinit {
        stopTimer()
        // Ensure any pending AI moves are cancelled
        // This prevents potential crashes when the view model is deallocated
    }
    
    // MARK: - Game Management
    
    /// Reset the game to initial state
    func resetGame() {
        // Stop any existing timer
        stopTimer()
        
        boards = (0..<8).map { Board(id: $0) }
        currentBoardIndex = 0
        currentPlayer = .x
        xScore = 0
        oScore = 0
        draws = 0
        winner = nil
        isPaused = false
        showVictory = false
        
        // Set active board
        updateActiveBoard()
        
        // Setup timer if needed
        if gameMode == .timed {
            timeRemaining = TimeInterval(timerDuration.rawValue)
            startTimer()
        }
        
        // Start AI turn if needed (only if game is already in playing state)
        if isAIGame && aiPlayer == .x && gameState == .playing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.makeAIMove()
            }
        }
        
        // Provide haptic feedback
        if settings.hapticEnabled {
            HapticManager.shared.playBoardTransition()
        }
        
        // Update game state if not already set
        if gameState != .playing {
            gameState = .playing
        }
        
        // Save stats with error handling
        do {
            try saveStats()
        } catch {
            print("Failed to save stats after reset: \(error)")
        }
    }
    
    /// Start a new game with specified settings
    func startNewGame(aiGame: Bool, aiDifficulty: AIDifficulty, gameMode: GameMode, timerDuration: TimerDuration) {
        // Stop any existing timer
        stopTimer()
        
        self.isAIGame = aiGame
        self.aiDifficulty = aiDifficulty
        self.gameMode = gameMode
        self.timerDuration = timerDuration
        
        if aiGame {
            // Randomly assign players
            if Bool.random() {
                humanPlayer = .x
                aiPlayer = .o
            } else {
                humanPlayer = .o
                aiPlayer = .x
            }
        }
        
        resetGame()
        
        // Update settings with new values
        settings.aiDifficulty = aiDifficulty
        settings.gameMode = gameMode
        settings.timerDuration = timerDuration
        
        // Save settings with error handling
        do {
            try saveSettings()
        } catch {
            print("Failed to save settings in startNewGame: \(error)")
        }
        
        // Provide haptic feedback
        if settings.hapticEnabled {
            HapticManager.shared.playGameStart()
        }
        
        // Create game start particle effect
        particleManager?.createGameStartEffect(at: CGPoint(x: 200, y: 200))
        
        // Update game state
        gameState = .playing
        
        // Start AI turn if needed
        if isAIGame && aiPlayer == .x {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.makeAIMove()
            }
        }
    }
    
    /// Make a move on the current board
    func makeMove(at index: Int) {
        guard let currentBoard = boards[safe: currentBoardIndex],
              currentBoard.isActive,
              currentBoard.cells[index] == .empty,
              gameState == .playing else {
            return
        }
        
        // Play haptic feedback for move
        if settings.hapticEnabled {
            HapticManager.shared.playMove()
        }
        
        // Make the move
        guard GameLogic.makeMove(index, player: currentPlayer, on: &boards[currentBoardIndex]) else {
            // Announce invalid move
            if settings.hapticEnabled {
                HapticManager.shared.playInvalidMove()
            }
            return
        }
        
        // Announce move for accessibility
        let cellPosition = "Row \(index / 3 + 1), Column \(index % 3 + 1)"
        AccessibilityAnnouncer.shared.announceMove(
            player: currentPlayer,
            boardIndex: currentBoardIndex,
            cellPosition: cellPosition
        )
        
        // Update game state
        handleBoardCompletion()
        checkGameWinner()
        
        // Switch players
        currentPlayer = currentPlayer == .x ? .o : .x
        
        // Move to next board if it's Player O's turn
        if currentPlayer == .o {
            moveToNextBoard()
        }
        
        // Make AI move if playing against AI
        if isAIGame && currentPlayer == .o {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.makeAIMove()
            }
        }
    }
    
    /// Handle board completion
    private func handleBoardCompletion() {
        guard let currentBoard = boards[safe: currentBoardIndex] else { return }
        
        if currentBoard.isComplete {
            // Play haptic feedback for board completion
            if settings.hapticEnabled {
                if currentBoard.winner != nil {
                    HapticManager.shared.playBoardWin()
                } else {
                    HapticManager.shared.playBoardDraw()
                }
            }
            
            // Announce board completion for accessibility
            if let winner = currentBoard.winner {
                AccessibilityAnnouncer.shared.announceBoardWin(
                    player: winner,
                    boardIndex: currentBoardIndex
                )
            } else {
                AccessibilityAnnouncer.shared.announceBoardDraw(boardIndex: currentBoardIndex)
                // Create draw particle effect
                particleManager?.createDrawEffect(at: CGPoint(x: 200, y: 200))
            }
            
            // Update scores
            if let winner = currentBoard.winner {
                if winner == .x {
                    xScore += 1
                } else {
                    oScore += 1
                }
            } else {
                draws += 1
            }
        }
    }
    
    /// Move to the next board
    private func moveToNextBoard() {
        guard !boards.isEmpty else { return }
        currentBoardIndex = (currentBoardIndex + 1) % boards.count
        updateActiveBoard()
        
        // Provide haptic feedback
        if settings.hapticEnabled {
            HapticManager.shared.playBoardTransition()
        }
        
        // Announce board transition for accessibility
        AccessibilityAnnouncer.shared.announceBoardTransition(to: currentBoardIndex)
        
        // Ensure current board index is valid
        guard currentBoardIndex >= 0 && currentBoardIndex < boards.count else {
            currentBoardIndex = 0
            return
        }
    }
    
    /// Update which board is active
    private func updateActiveBoard() {
        // Ensure current board index is valid
        if currentBoardIndex < 0 || currentBoardIndex >= boards.count {
            currentBoardIndex = 0
        }
        
        for i in 0..<boards.count {
            boards[i].isActive = (i == currentBoardIndex)
        }
    }
    
    /// Set active board (public method for UI)
    func setActiveBoard(_ index: Int) {
        guard index >= 0 && index < boards.count else { return }
        currentBoardIndex = index
        updateActiveBoard()
        
        // Play haptic feedback for board navigation
        if settings.hapticEnabled {
            HapticManager.shared.playBoardNavigation()
        }
    }
    
    /// Check if the game has a winner
    private func checkGameWinner() {
        let xWins = boards.filter { $0.winner == .x }.count
        let oWins = boards.filter { $0.winner == .o }.count
        
        if xWins >= 5 {
            winner = .x
            endGame()
            if settings.hapticEnabled {
                HapticManager.shared.playVictoryCelebration()
            }
            AccessibilityAnnouncer.shared.announceGameWin(player: .x)
        } else if oWins >= 5 {
            winner = .o
            endGame()
            if settings.hapticEnabled {
                HapticManager.shared.playVictoryCelebration()
            }
            AccessibilityAnnouncer.shared.announceGameWin(player: .o)
        } else if boards.allSatisfy({ $0.isComplete }) {
            // It's a draw
            endGame()
            HapticManager.shared.playGameEnd()
            // Create game draw particle effect
            particleManager?.createDrawEffect(at: CGPoint(x: 200, y: 200))
        }
    }
    
    /// End the game
    private func endGame() {
        guard gameState != .finished else { return } // Prevent multiple calls
        
        gameState = .finished
        stopTimer()
        
        // Update stats
        stats.gamesPlayed += 1
        if let winner = winner {
            if winner == .x {
                stats.xWins += 1
            } else {
                stats.oWins += 1
            }
        } else {
            stats.draws += 1
        }
        
        // Save stats with error handling
        do {
            try saveStats()
        } catch {
            print("Failed to save stats: \(error)")
        }
        
        // Show victory screen
        showVictory = true
        
        // Provide haptic feedback
        if settings.hapticEnabled {
            HapticManager.shared.playGameEnd()
        }
    }
    
    // MARK: - AI Logic
    
    /// Make AI move
    private func makeAIMove() {
        guard gameState == .playing && !isPaused else { return }
        guard let board = boards[safe: currentBoardIndex] else { return }
        guard board.isActive else { return }
        
        isAIMoving = true
        
        // Add a small delay to show loading animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }
            
            let aiPlayerInstance = AIPlayer(difficulty: self.aiDifficulty)
            
            if let move = aiPlayerInstance.getMove(for: board) {
                self.makeMove(at: move)
            } else {
                // Fallback: make a random move if AI fails
                let availableMoves = GameLogic.availableMoves(for: board)
                if let randomMove = availableMoves.randomElement() {
                    self.makeMove(at: randomMove)
                } else {
                    // If no moves are available, the game should be over
                    print("AI failed to find a move and no moves are available")
                }
            }
            
            self.isAIMoving = false
        }
    }
    
    // MARK: - Timer Management
    
    /// Start the game timer
    private func startTimer() {
        stopTimer()
        guard gameMode == .timed && gameState == .playing else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateTimer()
        }
        
        // Ensure timer is added to the main run loop
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    /// Stop the game timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Update timer countdown
    private func updateTimer() {
        guard gameMode == .timed && gameState == .playing else { return }
        
        timeRemaining -= 1
        
        // Announce timer warnings for accessibility
        if timeRemaining == 30 || timeRemaining == 10 {
            AccessibilityAnnouncer.shared.announceTimerWarning(timeRemaining: timeRemaining)
        }
        
        if timeRemaining <= 0 {
            timeRemaining = 0 // Ensure it doesn't go negative
            stopTimer() // Stop the timer when time runs out
            
            // Time's up - determine winner based on current score
            if xScore > oScore {
                winner = .x
            } else if oScore > xScore {
                winner = .o
            } else {
                winner = nil // Draw
            }
            endGame()
        }
    }
    
    // MARK: - Pause/Resume
    
    /// Pause the game
    func pauseGame() {
        guard gameState == .playing else { return }
        isPaused = true
        if gameMode == .timed {
            stopTimer()
        }
    }
    
    /// Resume the game
    func resumeGame() {
        guard gameState == .playing else { return }
        isPaused = false
        if gameMode == .timed {
            startTimer()
        }
    }
    
    // MARK: - Settings Management
    
    /// Save game settings
    private func saveSettings() throws {
        let data = try JSONEncoder().encode(settings)
        UserDefaults.standard.set(data, forKey: "GameSettings")
    }
    
    /// Load game settings
    private func loadSettings() {
        guard let data = UserDefaults.standard.data(forKey: "GameSettings") else { return }
        
        do {
            let loadedSettings = try JSONDecoder().decode(GameSettings.self, from: data)
            settings = loadedSettings
            aiDifficulty = settings.aiDifficulty
            gameMode = settings.gameMode
            timerDuration = settings.timerDuration
        } catch {
            print("Failed to load settings: \(error)")
            // Use default settings if loading fails
            settings = GameSettings()
            aiDifficulty = settings.aiDifficulty
            gameMode = settings.gameMode
            timerDuration = settings.timerDuration
        }
    }
    
    /// Save game statistics
    private func saveStats() throws {
        let data = try JSONEncoder().encode(stats)
        UserDefaults.standard.set(data, forKey: "GameStats")
    }
    
    /// Load game statistics
    private func loadStats() {
        guard let data = UserDefaults.standard.data(forKey: "GameStats") else { return }
        
        do {
            let loadedStats = try JSONDecoder().decode(GameStats.self, from: data)
            stats = loadedStats
        } catch {
            print("Failed to load stats: \(error)")
            // Use default stats if loading fails
            stats = GameStats()
        }
    }
    
    /// Update settings
    func updateSettings(_ newSettings: GameSettings) {
        settings = newSettings
        aiDifficulty = settings.aiDifficulty
        gameMode = settings.gameMode
        timerDuration = settings.timerDuration
        
        // Update timer if game is currently running
        if gameMode == .timed && gameState == .playing {
            timeRemaining = TimeInterval(timerDuration.rawValue)
        }
        
        // Save settings with error handling
        do {
            try saveSettings()
        } catch {
            print("Failed to save settings: \(error)")
        }
    }
}

 