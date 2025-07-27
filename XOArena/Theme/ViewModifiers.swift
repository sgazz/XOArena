import SwiftUI

// MARK: - Text Modifiers

extension View {
    /// Apply gold text styling with gradient
    func goldText() -> some View {
        self.foregroundStyle(LinearGradient.xoGoldGradient)
    }
    
    /// Apply glow effect to text
    func glow(color: Color, radius: CGFloat) -> some View {
        self.shadow(color: color, radius: radius, x: 0, y: 0)
    }
    
    /// Apply score display styling
    func scoreDisplay(player: Player, isLeading: Bool) -> some View {
        self.foregroundColor(player == .x ? Color.adaptiveBlue() : Color.adaptiveOrange())
            .glow(color: isLeading ? (player == .x ? Color.adaptiveBlue() : Color.adaptiveOrange()) : Color.clear, radius: isLeading ? 8 : 0)
    }
    
    /// Apply timer display styling
    func timerDisplay(timeRemaining: TimeInterval, totalTime: TimeInterval) -> some View {
        let progress = timeRemaining / totalTime
        let color: Color = progress > 0.5 ? Color.adaptiveBlue() : progress > 0.2 ? Color.xoWarning : Color.xoError
        return self.foregroundColor(color)
            .glow(color: color, radius: progress < 0.3 ? 5 : 0)
    }
}

// MARK: - Button Modifiers

extension View {
    /// Apply metallic button styling
    func metallicButton(isPressed: Bool = false, isHighContrast: Bool = false) -> some View {
        self
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundColor(isPressed ? .xoDarkerBackground : .xoTextPrimary)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isPressed ? LinearGradient.xoGoldGradient : LinearGradient.xoMetallicGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isHighContrast ? Color.xoGold : Color.xoDarkMetallic, lineWidth: 1)
                    )
                    .shadow(
                        color: isPressed ? Color.xoGold.opacity(0.3) : Color.black.opacity(0.3),
                        radius: isPressed ? 8 : 4,
                        x: 0,
                        y: isPressed ? 2 : 1
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
            .accessibilityAddTraits(.isButton)
            .accessibilityHint("Double tap to activate")
    }
    
    /// Apply hover effect
    func hoverEffect() -> some View {
        self.scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.2), value: true)
    }
}

// MARK: - Metallic Button Style

struct MetallicButtonStyle: ButtonStyle {
    let isPressed: Bool
    let isHighContrast: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundColor(isPressed ? .xoDarkerBackground : .xoTextPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isPressed ? LinearGradient.xoGoldGradient : LinearGradient.xoMetallicGradient
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isPressed ? Color.xoGold : Color.xoDarkMetallic,
                                lineWidth: 2
                            )
                    )
                    .shadow(
                        color: isPressed ? Color.xoGold.opacity(0.4) : Color.black.opacity(0.3),
                        radius: configuration.isPressed ? 4 : 8,
                        x: 0,
                        y: configuration.isPressed ? 2 : 4
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Accessibility Modifiers

extension View {
    /// Apply high contrast support
    func highContrastSupport(isHighContrast: Bool) -> some View {
        self.environment(\.legibilityWeight, isHighContrast ? .bold : .regular)
    }
    
    /// Apply dynamic type support
    func dynamicTypeSupport() -> some View {
        self.environment(\.sizeCategory, .large)
    }
}

// MARK: - Animation Modifiers

extension View {
    /// Apply entrance animation
    func entranceAnimation(delay: Double = 0.0) -> some View {
        self.opacity(0)
            .offset(y: 20)
            .onAppear {
                withAnimation(.easeOut(duration: 0.6).delay(delay)) {
                    // Animation will be handled by state changes
                }
            }
    }
    
    /// Apply pulse animation
    func pulseAnimation() -> some View {
        self.scaleEffect(1.0)
            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: true)
    }
    
    /// Apply shake animation
    func shakeAnimation() -> some View {
        self.offset(x: 0)
            .animation(.easeInOut(duration: 0.1).repeatCount(3), value: true)
    }
}

// MARK: - Background Modifiers

extension View {
    /// Apply XO Arena background
    func xoBackground() -> some View {
        self.background(LinearGradient.xoBackgroundGradient.ignoresSafeArea())
    }
    
    /// Apply metallic background
    func metallicBackground() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient.xoMetallicGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.xoDarkMetallic, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Particle System Modifier

// Note: This function is already defined in ParticleEffects.swift
// Removing duplicate declaration

// MARK: - Keyboard Navigation Modifier

extension View {
    /// Apply keyboard navigation
    func keyboardNavigation(action: @escaping (KeyEquivalent) -> Void) -> some View {
        self.onKeyPress { key in
            action(key.key)
            return .handled
        }
    }
}

// MARK: - Accessibility Enhancement Modifiers

extension View {
    /// Apply enhanced accessibility
    func enhancedAccessibility(label: String, hint: String? = nil, traits: AccessibilityTraits = []) -> some View {
        self.accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits)
    }
    
    /// Apply board accessibility
    func boardAccessibility(boardIndex: Int, isActive: Bool, isCompleted: Bool) -> some View {
        let label = "Board \(boardIndex + 1)"
        let hint = isActive ? "Currently active board" : isCompleted ? "Completed board" : "Inactive board"
        return self.enhancedAccessibility(label: label, hint: hint)
    }
    
    /// Apply cell accessibility
    func cellAccessibility(row: Int, column: Int, cell: Cell, isInteractive: Bool) -> some View {
        let label = "Row \(row + 1), Column \(column + 1)"
        let hint = isInteractive ? "Tap to place mark" : cell == .empty ? "Empty cell" : "Marked by \(cell.displayValue)"
        return self.enhancedAccessibility(label: label, hint: hint)
    }
}

// MARK: - Game State Modifiers

extension View {
    /// Apply game state styling
    func gameStateStyle(_ state: GameState) -> some View {
        switch state {
        case .playing:
            return self.opacity(1.0)
        case .paused:
            return self.opacity(0.7)
        case .finished:
            return self.opacity(0.5)
        case .menu:
            return self.opacity(1.0)
        }
    }
    
    /// Apply player indicator styling
    func playerIndicatorStyle(_ player: Player) -> some View {
        self.foregroundColor(player == .x ? Color.adaptiveBlue() : Color.adaptiveOrange())
            .glow(color: player == .x ? Color.adaptiveBlue() : Color.adaptiveOrange(), radius: 8)
    }
}

// MARK: - Timer Modifiers

extension View {
    /// Apply timer warning styling
    func timerWarningStyle(timeRemaining: TimeInterval) -> some View {
        let isWarning = timeRemaining <= 30
        let isCritical = timeRemaining <= 10
        let color: Color = isCritical ? .xoError : isWarning ? .xoWarning : .adaptiveBlue()
        return self.foregroundColor(color)
            .glow(color: color, radius: isWarning ? 5 : 0)
    }
}

// MARK: - AI Modifiers

extension View {
    /// Apply AI thinking indicator
    func aiThinkingIndicator(isThinking: Bool) -> some View {
        self.overlay(
            Group {
                if isThinking {
                    ZStack {
                        Color.black.opacity(0.5)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .xoGold))
                            .scaleEffect(1.5)
                    }
                }
            }
        )
    }
}

// MARK: - Victory Modifiers

extension View {
    /// Apply victory celebration styling
    func victoryCelebrationStyle() -> some View {
        self.scaleEffect(1.05)
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: true)
    }
    
    /// Apply confetti effect
    func confettiEffect() -> some View {
        self.overlay(
            ConfettiView()
        )
    }
}

// MARK: - Confetti View

struct ConfettiView: View {
    @State private var animationPhase: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<50, id: \.self) { index in
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
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
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

// MARK: - Preview Modifiers

extension View {
    /// Apply preview styling
    func previewStyle() -> some View {
        self.xoBackground()
            .preferredColorScheme(.dark)
    }
}

// MARK: - Preview

#Preview("Confetti View") {
    ZStack {
        LinearGradient.xoBackgroundGradient
            .ignoresSafeArea()
        
        Text("Confetti Effect Demo")
            .font(.title)
            .foregroundColor(.xoGold)
    }
    .confettiEffect()
} 