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
            // Animated background
            VictoryBackground()
            
            VStack(spacing: 40) {
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
                VStack(spacing: 16) {
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
                .padding(.horizontal, 40)
                
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
            // Background glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            iconGlowColor.opacity(0.3),
                            iconGlowColor.opacity(0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
            
            // Icon container
            Circle()
                .fill(LinearGradient.xoMetallicGradient)
                .frame(width: 120, height: 120)
                .overlay(
                    Circle()
                        .stroke(iconGlowColor, lineWidth: 3)
                        .glow(color: iconGlowColor, radius: 10)
                )
                .shadow(color: iconGlowColor.opacity(0.4), radius: 20, x: 0, y: 10)
            
            // Icon
            Image(systemName: iconName)
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(iconGradient)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
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
    
    private var iconGlowColor: Color {
        if isDraw {
            return Color.xoGold
        } else {
            return winner == .x ? Color.adaptiveBlue() : Color.adaptiveOrange()
        }
    }
    
    private var iconGradient: LinearGradient {
        if isDraw {
            return LinearGradient.xoGoldGradient
        } else {
            return winner == .x ? 
                LinearGradient(colors: [Color.adaptiveBlue(), Color.xoCyanBlue], startPoint: .topLeading, endPoint: .bottomTrailing) :
                LinearGradient(colors: [Color.adaptiveOrange(), Color.xoOrangeRed], startPoint: .topLeading, endPoint: .bottomTrailing)
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
    
    var body: some View {
        VStack(spacing: 12) {
            Text(mainTitle)
                .font(.system(size: titleFontSize, weight: .black, design: .rounded))
                .foregroundStyle(titleGradient)
                .glow(color: titleGlowColor, radius: 15)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
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
    
    private var titleFontSize: CGFloat {
        let baseSize: CGFloat = 32
        return baseSize
    }
    
    private var subtitleFontSize: CGFloat {
        let baseSize: CGFloat = 18
        return baseSize
    }
    
    private var titleGradient: LinearGradient {
        if isDraw {
            return LinearGradient.xoGoldGradient
        } else {
            return winner == .x ? 
                LinearGradient(colors: [Color.adaptiveBlue(), Color.xoCyanBlue], startPoint: .leading, endPoint: .trailing) :
                LinearGradient(colors: [Color.adaptiveOrange(), Color.xoOrangeRed], startPoint: .leading, endPoint: .trailing)
        }
    }
    
    private var titleGlowColor: Color {
        if isDraw {
            return Color.xoGold
        } else {
            return winner == .x ? Color.adaptiveBlue() : Color.adaptiveOrange()
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
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.xoTextPrimary)
                .accessibilityLabel("Game Statistics")
            
            HStack(spacing: 24) {
                StatCard(
                    title: "X WINS",
                    value: "\(gameViewModel.xScore)",
                    color: Color.adaptiveBlue()
                )
                
                StatCard(
                    title: "O WINS", 
                    value: "\(gameViewModel.oScore)",
                    color: Color.adaptiveOrange()
                )
                
                StatCard(
                    title: "DRAWS",
                    value: "\(gameViewModel.draws)",
                    color: Color.xoGold
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient.xoMetallicGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.xoDarkMetallic, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
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
                .glow(color: color, radius: 5)
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

// MARK: - Victory Background

struct VictoryBackground: View {
    @State private var animationPhase: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient.xoBackgroundGradient
                .ignoresSafeArea()
            
            // Animated celebration effects
            GeometryReader { geometry in
                ZStack {
                    // Confetti particles
                    ForEach(0..<30, id: \.self) { index in
                        Circle()
                            .fill(confettiColor(for: index))
                            .frame(width: CGFloat.random(in: 4...12))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .animation(
                                Animation.easeInOut(duration: Double.random(in: 2...4))
                                    .repeatForever(autoreverses: true)
                                    .delay(Double.random(in: 0...1)),
                                value: animationPhase
                            )
                    }
                    
                    // Victory light rays
                    VStack {
                        HStack(spacing: 40) {
                            ForEach(0..<5) { index in
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.xoGold.opacity(0.3), Color.clear],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 2, height: 200)
                                    .blur(radius: 2)
                                    .offset(x: sin(animationPhase + Double(index)) * 10)
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 50)
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                animationPhase = 1
            }
        }
        .accessibilityHidden(true)
    }
    
    private func confettiColor(for index: Int) -> Color {
        let colors: [Color] = [
            Color.xoGold,
            Color.adaptiveBlue(),
            Color.adaptiveOrange(),
            Color.xoSuccess,
            Color.xoVibrantBlue
        ]
        return colors[index % colors.count]
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