import Foundation

// MARK: - Game Models

/// Represents a single cell in the TicTacToe board
enum Cell: Equatable, Codable {
    case empty
    case x
    case o
    
    var displayValue: String {
        switch self {
        case .empty: return ""
        case .x: return "X"
        case .o: return "O"
        }
    }
}

/// Represents a single TicTacToe board
struct Board: Equatable, Identifiable, Codable {
    let id: Int
    var cells: [Cell]
    var isActive: Bool = false
    var winner: Player?
    
    init(id: Int) {
        self.id = id
        self.cells = Array(repeating: .empty, count: 9)
    }
    
    init(id: Int, winner: Player?) {
        self.id = id
        self.cells = Array(repeating: .empty, count: 9)
        self.winner = winner
    }
    
    /// Check if the board has a winner
    var hasWinner: Bool {
        winner != nil
    }
    
    /// Check if the board is full (draw)
    var isFull: Bool {
        !cells.contains(.empty)
    }
    
    /// Check if the board is complete (has winner or is full)
    var isComplete: Bool {
        hasWinner || isFull
    }
}

/// Represents a player in the game
enum Player: String, CaseIterable, Codable {
    case x = "X"
    case o = "O"
    
    var displayName: String {
        switch self {
        case .x: return "Player X"
        case .o: return "Player O"
        }
    }
    
    var displayValue: String {
        switch self {
        case .x: return "X"
        case .o: return "O"
        }
    }
    
    var opposite: Player {
        switch self {
        case .x: return .o
        case .o: return .x
        }
    }
}

/// AI difficulty levels
enum AIDifficulty: String, CaseIterable, Codable {
    case normal = "Normal"
    case hard = "Hard"
    case expert = "Expert"
    
    var displayName: String {
        rawValue
    }
}

/// Game mode (with or without timer)
enum GameMode: String, CaseIterable, Codable {
    case classic = "Classic"
    case timed = "Timed"
    
    var displayName: String {
        rawValue
    }
}

/// Timer duration options
enum TimerDuration: Int, CaseIterable, Codable {
    case oneMinute = 60
    case twoMinutes = 120
    case threeMinutes = 180
    case fiveMinutes = 300
    
    var displayName: String {
        switch self {
        case .oneMinute: return "1 Minute"
        case .twoMinutes: return "2 Minutes"
        case .threeMinutes: return "3 Minutes"
        case .fiveMinutes: return "5 Minutes"
        }
    }
}

/// Game settings
struct GameSettings: Codable {
    // Global settings only
    var soundEnabled: Bool = true
    var hapticEnabled: Bool = true
    var tutorialShown: Bool = false
    var highContrastMode: Bool = false
    var reduceMotion: Bool = false
    var autoSaveEnabled: Bool = true
}

/// Game state
enum GameState: Codable {
    case menu
    case playing
    case paused
    case finished
}

/// Game statistics
struct GameStats: Codable {
    var gamesPlayed: Int = 0
    var xWins: Int = 0
    var oWins: Int = 0
    var draws: Int = 0
    var bestTime: TimeInterval = 0
    var longestWinStreak: Int = 0
}

// MARK: - Array Extension for Safe Subscript

extension Array {
    /// Safe subscript that returns nil if index is out of bounds
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
} 