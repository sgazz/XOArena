import Foundation

// MARK: - Game Logic

/// Winning combinations for TicTacToe (indices 0-8)
struct WinningCombinations {
    static let combinations: [[Int]] = [
        // Rows
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        // Columns
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        // Diagonals
        [0, 4, 8], [2, 4, 6]
    ]
}

/// Game logic utilities
struct GameLogic {
    
    /// Check if a board has a winner
    static func checkWinner(for board: Board) -> Player? {
        for combination in WinningCombinations.combinations {
            let cells = combination.map { board.cells[$0] }
            
            if cells.allSatisfy({ $0 == .x }) {
                return .x
            } else if cells.allSatisfy({ $0 == .o }) {
                return .o
            }
        }
        return nil
    }
    
    /// Get available moves for a board
    static func availableMoves(for board: Board) -> [Int] {
        return board.cells.enumerated()
            .filter { $0.element == .empty }
            .map { $0.offset }
    }
    
    /// Check if a move is valid
    static func isValidMove(_ index: Int, on board: Board) -> Bool {
        return index >= 0 && index < 9 && board.cells[index] == .empty
    }
    
    /// Make a move on a board
    static func makeMove(_ index: Int, player: Player, on board: inout Board) -> Bool {
        guard isValidMove(index, on: board) else { return false }
        
        board.cells[index] = player == .x ? .x : .o
        board.winner = checkWinner(for: board)
        
        return true
    }
}

// MARK: - AI Logic

/// AI player implementation
struct AIPlayer {
    let difficulty: AIDifficulty
    
    /// Get AI move based on difficulty
    func getMove(for board: Board) -> Int? {
        let availableMoves = GameLogic.availableMoves(for: board)
        guard !availableMoves.isEmpty else { return nil }
        
        switch difficulty {
        case .normal:
            return getRandomMove(from: availableMoves)
        case .hard:
            return getHardMove(for: board, availableMoves: availableMoves)
        case .expert:
            return getExpertMove(for: board, availableMoves: availableMoves)
        }
    }
    
    /// Random move for normal difficulty
    private func getRandomMove(from moves: [Int]) -> Int? {
        return moves.randomElement()
    }
    
    /// Hard difficulty - tries to win and block opponent
    private func getHardMove(for board: Board, availableMoves: [Int]) -> Int? {
        // Try to win
        if let winningMove = findWinningMove(for: board, player: .o, availableMoves: availableMoves) {
            return winningMove
        }
        
        // Block opponent from winning
        if let blockingMove = findWinningMove(for: board, player: .x, availableMoves: availableMoves) {
            return blockingMove
        }
        
        // Take center if available
        if availableMoves.contains(4) {
            return 4
        }
        
        // Take corners if available
        let corners = [0, 2, 6, 8]
        let availableCorners = availableMoves.filter { corners.contains($0) }
        if let corner = availableCorners.randomElement() {
            return corner
        }
        
        // Random move
        return availableMoves.randomElement()
    }
    
    /// Expert difficulty - uses minimax algorithm
    private func getExpertMove(for board: Board, availableMoves: [Int]) -> Int? {
        var bestScore = -Double.infinity
        var bestMove: Int?
        
        for move in availableMoves {
            var newBoard = board
            guard GameLogic.makeMove(move, player: .o, on: &newBoard) else { continue }
            
            let score = minimax(board: newBoard, depth: 0, alpha: -Double.infinity, beta: Double.infinity, isMaximizing: false)
            
            if score > bestScore {
                bestScore = score
                bestMove = move
            }
        }
        
        return bestMove
    }
    
    /// Find winning move for a player
    private func findWinningMove(for board: Board, player: Player, availableMoves: [Int]) -> Int? {
        for move in availableMoves {
            var testBoard = board
            guard GameLogic.makeMove(move, player: player, on: &testBoard) else { continue }
            if testBoard.winner == player {
                return move
            }
        }
        return nil
    }
    
    /// Minimax algorithm with alpha-beta pruning
    private func minimax(board: Board, depth: Int, alpha: Double, beta: Double, isMaximizing: Bool) -> Double {
        // Terminal states
        if board.winner == .o {
            return 10.0 - Double(depth)
        } else if board.winner == .x {
            return Double(depth) - 10.0
        } else if board.isFull {
            return 0.0
        }
        
        // Depth limit for performance
        if depth > 6 {
            return evaluateBoard(board)
        }
        
        let availableMoves = GameLogic.availableMoves(for: board)
        var alpha = alpha
        var beta = beta
        
        if isMaximizing {
            var maxScore = -Double.infinity
            for move in availableMoves {
                var newBoard = board
                guard GameLogic.makeMove(move, player: .o, on: &newBoard) else { continue }
                let score = minimax(board: newBoard, depth: depth + 1, alpha: alpha, beta: beta, isMaximizing: false)
                maxScore = max(maxScore, score)
                alpha = max(alpha, score)
                if beta <= alpha {
                    break // Beta cutoff
                }
            }
            return maxScore
        } else {
            var minScore = Double.infinity
            for move in availableMoves {
                var newBoard = board
                guard GameLogic.makeMove(move, player: .x, on: &newBoard) else { continue }
                let score = minimax(board: newBoard, depth: depth + 1, alpha: alpha, beta: beta, isMaximizing: true)
                minScore = min(minScore, score)
                beta = min(beta, score)
                if beta <= alpha {
                    break // Alpha cutoff
                }
            }
            return minScore
        }
    }
    
    /// Evaluate board position for non-terminal states
    private func evaluateBoard(_ board: Board) -> Double {
        var score = 0.0
        
        // Evaluate each winning combination
        for combination in WinningCombinations.combinations {
            let cells = combination.map { board.cells[$0] }
            let xCount = cells.filter { $0 == .x }.count
            let oCount = cells.filter { $0 == .o }.count
            let emptyCount = cells.filter { $0 == .empty }.count
            
            if xCount == 2 && emptyCount == 1 {
                score -= 3.0 // X is close to winning
            } else if oCount == 2 && emptyCount == 1 {
                score += 3.0 // O is close to winning
            } else if xCount == 1 && emptyCount == 2 {
                score -= 1.0 // X has potential
            } else if oCount == 1 && emptyCount == 2 {
                score += 1.0 // O has potential
            }
        }
        
        return score
    }
} 