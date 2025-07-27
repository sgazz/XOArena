import SwiftUI

struct VictoryScreen: View {
    let gameViewModel: GameViewModel
    let onPlayAgain: () -> Void
    let onMainMenu: () -> Void
    
    @State private var isAnimating = false
    @State private var showStats = false
    @State private var selectedButton: String?
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var winner: Player? {
        gameViewModel.winner
    }
    
    private var isDraw: Bool {
        winner == nil
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient.xoBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Victory content
                VStack(spacing: 24) {
                    // Trophy or result icon
                    VictoryIcon(isDraw: isDraw, winner: winner)
                    
                    // Victory message
                    VictoryMessage(isDraw: isDraw, winner: winner)
                    
                    // Game stats
                    if showStats {
                        GameStatsView(gameViewModel: gameViewModel)
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .move(edge: .bottom).combined(with: .opacity)
                            ))
                    }
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 12) {
                    ActionButton(
                        title: "PLAY AGAIN",
                        icon: "arrow.clockwise",
                        isSelected: selectedButton == "playAgain",
                        action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                selectedButton = "playAgain"
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                onPlayAgain()
                            }
                        }
                    )
                    
                    ActionButton(
                        title: "MAIN MENU",
                        icon: "house.fill",
                        isSelected: selectedButton == "mainMenu",
                        action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                selectedButton = "mainMenu"
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                onMainMenu()
                            }
                        }
                    )
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                isAnimating = true
            }
            
            // Show stats after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    showStats = true
                }
            }
        }
        .highContrastSupport(isHighContrast: false)
        .dynamicTypeSupport()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Victory Screen")
    }
}

// MARK: - Victory Icon

struct VictoryIcon: View {
    let isDraw: Bool
    let winner: Player?
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Icon container
            Circle()
                .fill(Color.xoDarkBackground.opacity(0.8))
                .frame(width: 120, height: 120)
                .overlay(
                    Circle()
                        .stroke(iconBorderColor, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            
            // Icon
            Image(systemName: iconName)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(iconColor)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.3), value: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
        .accessibilityLabel(accessibilityLabel)
    }
    
    private var iconName: String {
        if isDraw {
            return "handshake.fill"
        } else {
            return "trophy.fill"
        }
    }
    
    private var iconColor: Color {
        if isDraw {
            return Color.xoGold
        } else {
            return winner == .x ? Color.adaptiveBlue() : Color.adaptiveOrange()
        }
    }
    
    private var iconBorderColor: Color {
        if isDraw {
            return Color.xoGold.opacity(0.6)
        } else {
            return winner == .x ? Color.adaptiveBlue().opacity(0.6) : Color.adaptiveOrange().opacity(0.6)
        }
    }
    
    private var accessibilityLabel: String {
        if isDraw {
            return "Draw result"
        } else {
            return "\(winner?.displayName ?? "") victory"
        }
    }
}

// MARK: - Victory Message

struct VictoryMessage: View {
    let isDraw: Bool
    let winner: Player?
    @State private var isAnimating = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 12) {
            Text(mainTitle)
                .font(.system(size: titleFontSize, weight: .bold))
                .foregroundColor(titleColor)
                .scaleEffect(isAnimating ? 1.02 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                .accessibilityLabel(mainTitle)
            
            Text(subtitle)
                .font(.system(size: subtitleFontSize, weight: .medium))
                .foregroundColor(.xoTextSecondary)
                .multilineTextAlignment(.center)
                .opacity(isAnimating ? 0.8 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(0.5), value: isAnimating)
                .accessibilityLabel(subtitle)
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    private var mainTitle: String {
        if isDraw {
            return "IT'S A DRAW!"
        } else {
            return "\(winner?.displayName.uppercased() ?? "") WINS!"
        }
    }
    
    private var subtitle: String {
        if isDraw {
            return "Both players fought valiantly"
        } else {
            return "Champion of XO Arena"
        }
    }
    
    private var titleColor: Color {
        if isDraw {
            return Color.xoGold
        } else {
            return winner == .x ? Color.adaptiveBlue() : Color.adaptiveOrange()
        }
    }
    
    private var titleFontSize: CGFloat {
        let baseSize: CGFloat = horizontalSizeClass == .regular ? 28 : 24
        
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
        let baseSize: CGFloat = horizontalSizeClass == .regular ? 16 : 14
        
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

// MARK: - Game Stats View

struct GameStatsView: View {
    let gameViewModel: GameViewModel
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var body: some View {
        VStack(spacing: 16) {
            Text("GAME STATS")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.xoTextPrimary)
                .accessibilityLabel("Game Statistics")
            
            HStack(spacing: 20) {
                StatCard(
                    title: "X WINS",
                    value: "\(gameViewModel.xScore)",
                    color: Color.adaptiveBlue()
                )
                
                StatCard(
                    title: "DRAWS",
                    value: "\(gameViewModel.draws)",
                    color: Color.xoGold
                )
                
                StatCard(
                    title: "O WINS", 
                    value: "\(gameViewModel.oScore)",
                    color: Color.adaptiveOrange()
                )
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
        .accessibilityLabel("Game Statistics: X wins \(gameViewModel.xScore), O wins \(gameViewModel.oScore), Draws \(gameViewModel.draws)")
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: labelFontSize, weight: .medium))
                .foregroundColor(.xoTextMuted)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            
            Text(value)
                .font(.system(size: valueFontSize, weight: .bold))
                .foregroundColor(color)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .accessibilityLabel("\(title): \(value)")
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

#Preview {
    let mockViewModel = GameViewModel()
    mockViewModel.xScore = 3
    mockViewModel.oScore = 2
    mockViewModel.draws = 1
    mockViewModel.winner = .x
    
    return VictoryScreen(
        gameViewModel: mockViewModel,
        onPlayAgain: {},
        onMainMenu: {}
    )
} 