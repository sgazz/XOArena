import SwiftUI

// MARK: - Intro Screen

struct IntroScreen: View {
    let onStartGame: () -> Void
    let onShowTutorial: () -> Void
    let onShowSettings: () -> Void
    
    @State private var isAnimating = false
    @State private var selectedButton: String?
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        ZStack {
            // Animated background
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Title with enhanced animations
                VStack(spacing: 16) {
                    Text("XO")
                        .font(.system(size: titleFontSize, weight: .black, design: .rounded))
                        .goldText()
                        .glow(color: Color.xoGold, radius: 20)
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                    Text("ARENA")
                        .font(.system(size: subtitleFontSize, weight: .black, design: .rounded))
                        .foregroundColor(.xoTextSecondary)
                        .glow(color: Color.xoTextSecondary, radius: 10)
                        .opacity(isAnimating ? 0.8 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(0.5), value: isAnimating)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("XO Arena")
                
                // Subtitle
                Text("8 Boards. 1 Champion.")
                    .font(.system(size: subtitleFontSize * 0.6, weight: .medium))
                    .foregroundColor(.xoTextMuted)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("8 Boards. 1 Champion.")
                
                Spacer()
                
                // Action buttons with enhanced styling
                VStack(spacing: 20) {
                    Button("START GAME") {
                        HapticManager.shared.impact(.medium)
                        onStartGame()
                    }
                    .metallicButton()
                    .accessibilityLabel("Start game")
                    .accessibilityHint("Begin a new game")
                    
                    Button("HOW TO PLAY") {
                        HapticManager.shared.impact(.light)
                        onShowTutorial()
                    }
                    .metallicButton()
                    .accessibilityLabel("How to play")
                    .accessibilityHint("Learn the game rules")
                    
                    Button("SETTINGS") {
                        HapticManager.shared.impact(.light)
                        onShowSettings()
                    }
                    .metallicButton()
                    .accessibilityLabel("Settings")
                    .accessibilityHint("Configure game options")
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Footer with version info
                VStack(spacing: 8) {
                    Text("Version 1.0")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.xoTextMuted)
                        .accessibilityLabel("Version 1.0")
                    
                    Text("© 2025 XO Arena")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.xoTextMuted.opacity(0.7))
                        .accessibilityLabel("Copyright 2025 XO Arena")
                }
            }
            .padding()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                isAnimating = true
            }
        }
        .highContrastSupport(isHighContrast: false)
        .dynamicTypeSupport()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("XO Arena Main Menu")
    }
    
    private var titleFontSize: CGFloat {
        let baseSize: CGFloat = horizontalSizeClass == .regular ? 80 : 60
        
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
        let baseSize: CGFloat = horizontalSizeClass == .regular ? 32 : 24
        
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

// MARK: - Action Button Component

struct ActionButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var body: some View {
        Button(action: {
            HapticManager.shared.impact(.light)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action()
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: iconFontSize, weight: .semibold))
                    .foregroundColor(isSelected ? .xoDarkerBackground : .xoGold)
                
                Text(title)
                    .font(.system(size: buttonFontSize, weight: .bold, design: .rounded))
                    .foregroundColor(isSelected ? .xoDarkerBackground : .xoTextPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected ? LinearGradient.xoGoldGradient : LinearGradient.xoMetallicGradient
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? Color.xoGold : Color.xoDarkMetallic,
                                lineWidth: 2
                            )
                    )
                    .shadow(
                        color: isSelected ? Color.xoGold.opacity(0.4) : Color.black.opacity(0.3),
                        radius: isPressed ? 4 : 8,
                        x: 0,
                        y: isPressed ? 2 : 4
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(title)
        .accessibilityHint("Double tap to \(title.lowercased())")
        .accessibilityAddTraits(.isButton)
    }
    
    private var buttonFontSize: CGFloat {
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
    
    private var buttonHeight: CGFloat {
        let baseHeight: CGFloat = 56
        
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
}

// MARK: - Animated Background

struct AnimatedBackground: View {
    @State private var animationPhase: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient.xoBackgroundGradient
                .ignoresSafeArea()
            
            // Animated light effects
            GeometryReader { geometry in
                ZStack {
                    // Floating particles
                    ForEach(0..<20, id: \.self) { index in
                        Circle()
                            .fill(Color.xoGold.opacity(0.1))
                            .frame(width: CGFloat.random(in: 2...6))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .animation(
                                Animation.easeInOut(duration: Double.random(in: 3...6))
                                    .repeatForever(autoreverses: true)
                                    .delay(Double.random(in: 0...2)),
                                value: animationPhase
                            )
                    }
                    
                    // Light trails
                    VStack {
                        HStack {
                            Rectangle()
                                .fill(LinearGradient.xoBlueGradient)
                                .frame(width: 2, height: 150)
                                .blur(radius: 3)
                                .opacity(0.4)
                                .offset(x: sin(animationPhase) * 20)
                            
                            Spacer()
                            
                            Rectangle()
                                .fill(LinearGradient.xoOrangeGradient)
                                .frame(width: 2, height: 150)
                                .blur(radius: 3)
                                .opacity(0.4)
                                .offset(x: cos(animationPhase) * 20)
                        }
                        Spacer()
                    }
                    .padding(.top, 100)
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                animationPhase = 1
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Preview

#Preview {
    IntroScreen(
        onStartGame: {},
        onShowTutorial: {},
        onShowSettings: {}
    )
} 