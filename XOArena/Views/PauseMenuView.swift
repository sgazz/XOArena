import SwiftUI

struct PauseMenuView: View {
    let gameViewModel: GameViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedButton: String?
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        ZStack {
            // Blurred background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            // Menu content
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "pause.circle.fill")
                        .font(.system(size: 48, weight: .light))
                        .foregroundColor(.xoGold)
                        .glow(color: Color.xoGold, radius: 10)
                        .accessibilityLabel("Pause icon")
                    
                    Text("GAME PAUSED")
                        .font(.system(size: titleFontSize, weight: .black, design: .rounded))
                        .goldText()
                        .glow(color: Color.xoGold, radius: 15)
                        .accessibilityLabel("Game Paused")
                    
                    Text("Take a break or continue your battle")
                        .font(.system(size: subtitleFontSize, weight: .medium))
                        .foregroundColor(.xoTextSecondary)
                        .multilineTextAlignment(.center)
                        .accessibilityLabel("Take a break or continue your battle")
                }
                
                // Game info
                GameInfoCard(gameViewModel: gameViewModel)
                
                // Action buttons
                VStack(spacing: 16) {
                    SimpleActionButton(
                        title: "RESUME",
                        icon: "play.fill",
                        isSelected: selectedButton == "resume"
                    ) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            selectedButton = "resume"
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            gameViewModel.resumeGame()
                            dismiss()
                        }
                    }
                    
                    SimpleActionButton(
                        title: "RESTART",
                        icon: "arrow.clockwise",
                        isSelected: selectedButton == "restart"
                    ) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            selectedButton = "restart"
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            gameViewModel.resetGame()
                            dismiss()
                        }
                    }
                    
                    SimpleActionButton(
                        title: "MAIN MENU",
                        icon: "house.fill",
                        isSelected: selectedButton == "mainMenu"
                    ) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            selectedButton = "mainMenu"
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            gameViewModel.gameState = .menu
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(LinearGradient.xoMetallicGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.xoDarkMetallic, lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 20)
        }
        .highContrastSupport(isHighContrast: false)
        .dynamicTypeSupport()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Pause Menu")
    }
    
    private var titleFontSize: CGFloat {
        let baseSize: CGFloat = horizontalSizeClass == .regular ? 32 : 28
        
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
    
    private var subtitleFontSize: CGFloat {
        let baseSize: CGFloat = horizontalSizeClass == .regular ? 18 : 16
        
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

// MARK: - Game Info Card

struct GameInfoCard: View {
    let gameViewModel: GameViewModel
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var body: some View {
        VStack(spacing: 16) {
            Text("CURRENT GAME")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.xoTextPrimary)
                .accessibilityLabel("Current Game Information")
            
            HStack(spacing: 24) {
                // Score
                VStack(spacing: 8) {
                    Text("SCORE")
                        .font(.system(size: labelFontSize, weight: .medium))
                        .foregroundColor(.xoTextMuted)
                        .accessibilityLabel("Score")
                    
                    HStack(spacing: 12) {
                        VStack(spacing: 4) {
                            Text("X")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color.adaptiveBlue())
                            Text("\(gameViewModel.xScore)")
                                .font(.system(size: valueFontSize, weight: .bold))
                                .foregroundColor(Color.adaptiveBlue())
                        }
                        .accessibilityLabel("Player X score: \(gameViewModel.xScore)")
                        
                        VStack(spacing: 4) {
                            Text("O")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color.adaptiveOrange())
                            Text("\(gameViewModel.oScore)")
                                .font(.system(size: valueFontSize, weight: .bold))
                                .foregroundColor(Color.adaptiveOrange())
                        }
                        .accessibilityLabel("Player O score: \(gameViewModel.oScore)")
                    }
                }
                
                Divider()
                    .frame(height: 40)
                    .background(Color.xoDarkMetallic)
                
                // Game mode
                VStack(spacing: 8) {
                    Text("MODE")
                        .font(.system(size: labelFontSize, weight: .medium))
                        .foregroundColor(.xoTextMuted)
                        .accessibilityLabel("Game Mode")
                    
                    Text(gameViewModel.gameMode.displayName)
                        .font(.system(size: valueFontSize, weight: .bold))
                        .foregroundColor(.xoTextPrimary)
                        .accessibilityLabel("Game mode: \(gameViewModel.gameMode.displayName)")
                }
                
                // Timer (if timed mode)
                if gameViewModel.gameMode == .timed {
                    Divider()
                        .frame(height: 40)
                        .background(Color.xoDarkMetallic)
                    
                    VStack(spacing: 8) {
                        Text("TIME")
                            .font(.system(size: labelFontSize, weight: .medium))
                            .foregroundColor(.xoTextMuted)
                            .accessibilityLabel("Time Remaining")
                        
                        Text(timeString)
                            .font(.system(size: valueFontSize, weight: .bold))
                            .foregroundColor(Color.adaptiveBlue())
                            .accessibilityLabel("Time remaining: \(timeString)")
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.xoDarkerBackground.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.xoDarkMetallic, lineWidth: 1)
                )
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Game Information: X score \(gameViewModel.xScore), O score \(gameViewModel.oScore), Mode \(gameViewModel.gameMode.displayName)")
    }
    
    private var timeString: String {
        let minutes = Int(gameViewModel.timeRemaining) / 60
        let seconds = Int(gameViewModel.timeRemaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private var labelFontSize: CGFloat {
        let baseSize: CGFloat = 12
        
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
    
    private var valueFontSize: CGFloat {
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
}

#Preview {
    let mockViewModel = GameViewModel()
    mockViewModel.xScore = 2
    mockViewModel.oScore = 1
    mockViewModel.gameMode = .timed
    mockViewModel.timeRemaining = 120
    
    return PauseMenuView(gameViewModel: mockViewModel)
} 