import SwiftUI

// MARK: - Enhanced Intro Screen

struct IntroScreen: View {
    let onStartGame: () -> Void
    let onShowTutorial: () -> Void
    let onShowSettings: () -> Void
    
    @State private var isAnimating = false
    @State private var titleScale: CGFloat = 0.8
    @State private var subtitleOpacity: Double = 0
    @State private var buttonsOffset: CGFloat = 50
    @State private var buttonsOpacity: Double = 0
    @State private var selectedButton: String?
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject private var particleManager: ParticleManager
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient.xoBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Title section
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("XO")
                            .font(.system(size: titleFontSize, weight: .black, design: .rounded))
                            .goldText()
                            .glow(color: Color.xoGold, radius: 25)
                            .scaleEffect(titleScale)
                            .rotation3DEffect(
                                .degrees(isAnimating ? 5 : 0),
                                axis: (x: 1, y: 0, z: 0)
                            )
                            .animation(.spring(response: 0.8, dampingFraction: 0.6), value: titleScale)
                            .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: isAnimating)
                        
                        Text("ARENA")
                            .font(.system(size: subtitleFontSize, weight: .black, design: .rounded))
                            .foregroundStyle(LinearGradient.xoGoldGradient)
                            .glow(color: Color.xoGold, radius: 15)
                            .opacity(subtitleOpacity)
                            .scaleEffect(isAnimating ? 1.02 : 1.0)
                            .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true).delay(0.3), value: isAnimating)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("XO Arena")
                    
                    // Subtitle
                    VStack(spacing: 8) {
                        Text("8 Boards. 1 Champion.")
                            .font(.system(size: subtitleFontSize * 0.7, weight: .semibold))
                            .foregroundStyle(LinearGradient.xoGoldGradient)
                            .multilineTextAlignment(.center)
                            .opacity(subtitleOpacity)
                            .accessibilityLabel("8 Boards. 1 Champion.")
                        
                        Text("Master the ultimate Tic-Tac-Toe experience")
                            .font(.system(size: subtitleFontSize * 0.4, weight: .medium))
                            .foregroundColor(.xoTextMuted)
                            .multilineTextAlignment(.center)
                            .opacity(subtitleOpacity * 0.8)
                            .accessibilityLabel("Master the ultimate Tic-Tac-Toe experience")
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 24) {
                    SimpleActionButton(
                        title: "START GAME",
                        icon: "play.fill",
                        isSelected: selectedButton == "start"
                    ) {
                        triggerStartGame()
                    }
                    
                    SimpleActionButton(
                        title: "HOW TO PLAY",
                        icon: "questionmark.circle.fill",
                        isSelected: selectedButton == "tutorial"
                    ) {
                        triggerShowTutorial()
                    }
                    
                    SimpleActionButton(
                        title: "SETTINGS",
                        icon: "gearshape.fill",
                        isSelected: selectedButton == "settings"
                    ) {
                        triggerShowSettings()
                    }
                }
                .offset(y: buttonsOffset)
                .opacity(buttonsOpacity)
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Footer
                VStack(spacing: 12) {
                    // Stats
                    HStack(spacing: 30) {
                        SimpleStatBadge(icon: "trophy.fill", value: "1.2K", label: "Games Won")
                        SimpleStatBadge(icon: "clock.fill", value: "45s", label: "Best Time")
                        SimpleStatBadge(icon: "star.fill", value: "4.9", label: "Rating")
                    }
                    .opacity(buttonsOpacity * 0.8)
                    
                    // Version info
                    VStack(spacing: 6) {
                        Text("Version 1.0 • Premium Edition")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.xoTextMuted)
                            .accessibilityLabel("Version 1.0 Premium Edition")
                        
                        Text("© 2025 XO Arena • Crafted with ❤️")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(.xoTextMuted.opacity(0.7))
                            .accessibilityLabel("Copyright 2025 XO Arena")
                    }
                    .opacity(buttonsOpacity * 0.6)
                }
                .offset(y: buttonsOffset * 0.5)
                .opacity(buttonsOpacity * 0.8)
            }
            .padding()
        }
        .onAppear {
            animateIntroSequence()
        }
        .highContrastSupport(isHighContrast: false)
        .dynamicTypeSupport()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("XO Arena Main Menu")
    }
    
    // MARK: - Animation Methods
    
    private func animateIntroSequence() {
        // Phase 1: Title animation
        withAnimation(.spring(response: 1.2, dampingFraction: 0.7).delay(0.3)) {
            titleScale = 1.0
        }
        
        // Phase 2: Subtitle fade in
        withAnimation(.easeInOut(duration: 0.8).delay(0.8)) {
            subtitleOpacity = 1.0
        }
        
        // Phase 3: Buttons slide in
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(1.2)) {
            buttonsOffset = 0
            buttonsOpacity = 1.0
        }
        
        // Phase 4: Start continuous animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                isAnimating = true
            }
        }
    }
    
    private func triggerStartGame() {
        HapticManager.shared.impact(.heavy)
        
        let center = CGPoint(
            x: UIScreen.main.bounds.width * 0.5,
            y: UIScreen.main.bounds.height * 0.5
        )
        particleManager.createButtonPressEffect(at: center)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            selectedButton = "start"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            onStartGame()
        }
    }
    
    private func triggerShowTutorial() {
        HapticManager.shared.impact(.medium)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            selectedButton = "tutorial"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            onShowTutorial()
        }
    }
    
    private func triggerShowSettings() {
        HapticManager.shared.impact(.medium)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            selectedButton = "settings"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            onShowSettings()
        }
    }
    
    // MARK: - Computed Properties
    
    private var titleFontSize: CGFloat {
        let baseSize: CGFloat = horizontalSizeClass == .regular ? 90 : 70
        
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
        let baseSize: CGFloat = horizontalSizeClass == .regular ? 36 : 28
        
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

// MARK: - Simple Action Button Component

struct SimpleActionButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @EnvironmentObject private var particleManager: ParticleManager
    
    var body: some View {
        Button(action: {
            handleButtonPress()
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: iconFontSize, weight: .semibold))
                    .foregroundStyle(isSelected ? LinearGradient(
                        colors: [Color.xoDarkerBackground, Color.xoDarkBackground],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) : LinearGradient.xoGoldGradient)
                
                Text(title)
                    .font(.system(size: buttonFontSize, weight: .bold, design: .rounded))
                    .foregroundStyle(isSelected ? LinearGradient(
                        colors: [Color.xoDarkerBackground, Color.xoDarkBackground],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) : LinearGradient(
                        colors: [Color.xoTextPrimary, Color.xoTextSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? LinearGradient.xoGoldGradient : LinearGradient.xoMetallicGradient)
                    .shadow(
                        color: isSelected ? Color.xoGold.opacity(0.5) : Color.black.opacity(0.4),
                        radius: isPressed ? 4 : 8,
                        x: 0,
                        y: isPressed ? 2 : 4
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isPressed)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(title)
        .accessibilityHint("Double tap to \(title.lowercased())")
        .accessibilityAddTraits(.isButton)
    }
    
    private var buttonFontSize: CGFloat {
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
    
    private var iconFontSize: CGFloat {
        let baseSize: CGFloat = 22
        
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
    
    private var buttonHeight: CGFloat {
        let baseHeight: CGFloat = 60
        
        switch dynamicTypeSize {
        case .xSmall, .small:
            return baseHeight
        case .medium:
            return baseHeight * 0.95
        case .large:
            return baseHeight * 0.9
        case .xLarge:
            return baseHeight * 0.85
        case .xxLarge:
            return baseHeight * 0.8
        case .xxxLarge:
            return baseHeight * 0.75
        case .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            return baseHeight * 0.7
        @unknown default:
            return baseHeight * 0.95
        }
    }
    
    private func handleButtonPress() {
        HapticManager.shared.impact(.medium)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            isPressed = true
        }
        
        let center = CGPoint(
            x: UIScreen.main.bounds.width * 0.5,
            y: UIScreen.main.bounds.height * 0.5
        )
        particleManager.createButtonPressEffect(at: center)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                action()
            }
        }
    }
}

// MARK: - Simple Stat Badge Component

struct SimpleStatBadge: View {
    let icon: String
    let value: String
    let label: String
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(LinearGradient.xoGoldGradient)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.xoTextPrimary)
            
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.xoTextMuted)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.xoDarkerBackground.opacity(0.6))
                .stroke(Color.xoGold.opacity(0.3), lineWidth: 1)
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(Double.random(in: 0...1))) {
                isAnimating = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}

// MARK: - Enhanced Preview

#Preview("Enhanced Intro Screen") {
    IntroScreen(
        onStartGame: {},
        onShowTutorial: {},
        onShowSettings: {}
    )
    .environmentObject(ParticleManager())
} 