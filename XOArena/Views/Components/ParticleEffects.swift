import SwiftUI

// MARK: - Particle Manager

class ParticleManager: ObservableObject {
    @Published var particles: [Particle] = []
    
    func createMoveEffect(at position: CGPoint, player: Player) {
        let particleCount = 8
        let newParticles = (0..<particleCount).map { _ in
            Particle(
                id: UUID(),
                position: position,
                velocity: CGVector(
                    dx: CGFloat.random(in: -50...50),
                    dy: CGFloat.random(in: -50...50)
                ),
                color: player == .x ? Color.adaptiveBlue() : Color.adaptiveOrange(),
                size: CGFloat.random(in: 4...8),
                lifetime: Double.random(in: 0.5...1.0)
            )
        }
        
        DispatchQueue.main.async {
            self.particles.append(contentsOf: newParticles)
        }
        
        // Remove particles after their lifetime
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.particles.removeAll { particle in
                newParticles.contains { $0.id == particle.id }
            }
        }
    }
    
    func createBoardWinEffect(at position: CGPoint, player: Player) {
        let particleCount = 20
        let newParticles = (0..<particleCount).map { _ in
            Particle(
                id: UUID(),
                position: position,
                velocity: CGVector(
                    dx: CGFloat.random(in: -100...100),
                    dy: CGFloat.random(in: -100...100)
                ),
                color: player == .x ? Color.adaptiveBlue() : Color.adaptiveOrange(),
                size: CGFloat.random(in: 6...12),
                lifetime: Double.random(in: 1.0...2.0)
            )
        }
        
        DispatchQueue.main.async {
            self.particles.append(contentsOf: newParticles)
        }
        
        // Remove particles after their lifetime
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.particles.removeAll { particle in
                newParticles.contains { $0.id == particle.id }
            }
        }
    }
    
    func createVictoryEffect(at position: CGPoint) {
        let particleCount = 30
        let colors: [Color] = [.xoGold, .adaptiveBlue(), .adaptiveOrange(), .xoSuccess, .xoVibrantBlue]
        
        let newParticles = (0..<particleCount).map { _ in
            Particle(
                id: UUID(),
                position: position,
                velocity: CGVector(
                    dx: CGFloat.random(in: -150...150),
                    dy: CGFloat.random(in: -150...150)
                ),
                color: colors.randomElement() ?? .xoGold,
                size: CGFloat.random(in: 8...16),
                lifetime: Double.random(in: 2.0...3.0)
            )
        }
        
        DispatchQueue.main.async {
            self.particles.append(contentsOf: newParticles)
        }
        
        // Remove particles after their lifetime
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.particles.removeAll { particle in
                newParticles.contains { $0.id == particle.id }
            }
        }
    }
    
    func createGameStartEffect(at position: CGPoint) {
        let particleCount = 10
        let newParticles = (0..<particleCount).map { _ in
            Particle(
                id: UUID(),
                position: position,
                velocity: CGVector(
                    dx: CGFloat.random(in: -30...30),
                    dy: CGFloat.random(in: -30...30)
                ),
                color: .xoGold,
                size: CGFloat.random(in: 3...6),
                lifetime: Double.random(in: 0.5...1.0)
            )
        }
        
        DispatchQueue.main.async {
            self.particles.append(contentsOf: newParticles)
        }
        
        // Remove particles after their lifetime
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.particles.removeAll { particle in
                newParticles.contains { $0.id == particle.id }
            }
        }
    }
    
    func createDrawEffect(at position: CGPoint) {
        let particleCount = 12
        let newParticles = (0..<particleCount).map { _ in
            Particle(
                id: UUID(),
                position: position,
                velocity: CGVector(
                    dx: CGFloat.random(in: -60...60),
                    dy: CGFloat.random(in: -60...60)
                ),
                color: Color.xoGold,
                size: CGFloat.random(in: 5...9),
                lifetime: Double.random(in: 0.8...1.2)
            )
        }
        
        DispatchQueue.main.async {
            self.particles.append(contentsOf: newParticles)
        }
        
        // Remove particles after their lifetime
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.particles.removeAll { particle in
                newParticles.contains { $0.id == particle.id }
            }
        }
    }
    
    func createScoreUpdateEffect(at position: CGPoint, player: Player) {
        let particleCount = 4
        let colors: [Color] = player == .x ? [.xoVibrantOrange, .xoGold] : [.xoVibrantBlue, .xoGold]
        
        let newParticles = (0..<particleCount).map { _ in
            Particle(
                id: UUID(),
                position: position,
                velocity: CGVector(
                    dx: CGFloat.random(in: -20...20),
                    dy: CGFloat.random(in: -20...20)
                ),
                color: colors.randomElement() ?? .xoGold,
                size: CGFloat.random(in: 3...6),
                lifetime: Double.random(in: 0.4...0.8)
            )
        }
        
        DispatchQueue.main.async {
            self.particles.append(contentsOf: newParticles)
        }
    }
    
    func createTimerWarningEffect(at position: CGPoint) {
        let particleCount = 6
        let newParticles = (0..<particleCount).map { _ in
            Particle(
                id: UUID(),
                position: position,
                velocity: CGVector(
                    dx: CGFloat.random(in: -30...30),
                    dy: CGFloat.random(in: -30...30)
                ),
                color: .xoWarning,
                size: CGFloat.random(in: 2...4),
                lifetime: Double.random(in: 0.3...0.6)
            )
        }
        
        DispatchQueue.main.async {
            self.particles.append(contentsOf: newParticles)
        }
    }
    
    func createButtonPressEffect(at position: CGPoint) {
        let particleCount = 4
        let newParticles = (0..<particleCount).map { _ in
            Particle(
                id: UUID(),
                position: position,
                velocity: CGVector(
                    dx: CGFloat.random(in: -20...20),
                    dy: CGFloat.random(in: -20...20)
                ),
                color: Color.xoGold,
                size: CGFloat.random(in: 3...5),
                lifetime: Double.random(in: 0.3...0.5)
            )
        }
        
        DispatchQueue.main.async {
            self.particles.append(contentsOf: newParticles)
        }
        
        // Remove particles after their lifetime
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.particles.removeAll { particle in
                newParticles.contains { $0.id == particle.id }
            }
        }
    }
    
    func clearAllParticles() {
        DispatchQueue.main.async {
            self.particles.removeAll()
        }
    }
    
    func createBoardTransitionEffect(at position: CGPoint) {
        let particleCount = 8
        let newParticles = (0..<particleCount).map { _ in
            Particle(
                id: UUID(),
                position: position,
                velocity: CGVector(
                    dx: CGFloat.random(in: -40...40),
                    dy: CGFloat.random(in: -40...40)
                ),
                color: Color.xoVibrantBlue,
                size: CGFloat.random(in: 4...7),
                lifetime: Double.random(in: 0.6...1.0)
            )
        }
        
        DispatchQueue.main.async {
            self.particles.append(contentsOf: newParticles)
        }
    }
    
    func createVictorySparkleEffect(at position: CGPoint) {
        let sparkleCount = 12
        let newSparkles = (0..<sparkleCount).map { _ in
            Particle(
                id: UUID(),
                position: position,
                velocity: CGVector(
                    dx: CGFloat.random(in: -50...50),
                    dy: CGFloat.random(in: -50...50)
                ),
                color: [.xoGold, .xoVibrantBlue, .xoVibrantOrange].randomElement() ?? .xoGold,
                size: CGFloat.random(in: 2...5),
                lifetime: Double.random(in: 0.8...1.5)
            )
        }
        
        DispatchQueue.main.async {
            self.particles.append(contentsOf: newSparkles)
        }
    }
    
    func createMoveConfettiEffect(at position: CGPoint, player: Player) {
        let confettiCount = 6
        let colors: [Color] = player == .x ? [.xoVibrantOrange, .xoGold] : [.xoVibrantBlue, .xoGold]
        
        let newConfetti = (0..<confettiCount).map { _ in
            Particle(
                id: UUID(),
                position: position,
                velocity: CGVector(
                    dx: CGFloat.random(in: -30...30),
                    dy: CGFloat.random(in: -30...30)
                ),
                color: colors.randomElement() ?? .xoGold,
                size: CGFloat.random(in: 2...5),
                lifetime: Double.random(in: 0.5...1.0)
            )
        }
        
        DispatchQueue.main.async {
            self.particles.append(contentsOf: newConfetti)
        }
    }
    
    func createInvalidMoveEffect(at position: CGPoint) {
        let particleCount = 6
        let newParticles = (0..<particleCount).map { _ in
            Particle(
                id: UUID(),
                position: position,
                velocity: CGVector(
                    dx: CGFloat.random(in: -25...25),
                    dy: CGFloat.random(in: -25...25)
                ),
                color: Color.xoError,
                size: CGFloat.random(in: 3...5),
                lifetime: Double.random(in: 0.4...0.7)
            )
        }
        
        DispatchQueue.main.async {
            self.particles.append(contentsOf: newParticles)
        }
        
        // Remove particles after their lifetime
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.particles.removeAll { particle in
                newParticles.contains { $0.id == particle.id }
            }
        }
    }
}

// MARK: - Particle Model

struct Particle: Identifiable {
    let id: UUID
    var position: CGPoint
    let velocity: CGVector
    let color: Color
    let size: CGFloat
    let lifetime: Double
    let createdAt: Date = Date()
    
    var age: Double {
        Date().timeIntervalSince(createdAt)
    }
    
    var progress: Double {
        min(age / lifetime, 1.0)
    }
    
    var isExpired: Bool {
        age >= lifetime
    }
    
    var currentPosition: CGPoint {
        CGPoint(
            x: position.x + velocity.dx * progress,
            y: position.y + velocity.dy * progress
        )
    }
    
    var opacity: Double {
        1.0 - progress
    }
    
    var scale: Double {
        1.0 - (progress * 0.5)
    }
}

// MARK: - Particle System View

struct ParticleSystemView: View {
    @ObservedObject var particleManager: ParticleManager
    
    var body: some View {
        ZStack {
            ForEach(particleManager.particles) { particle in
                ParticleView(particle: particle)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

// MARK: - Particle View

struct ParticleView: View {
    let particle: Particle
    @State private var animationProgress: Double = 0
    
    var body: some View {
        Circle()
            .fill(particle.color)
            .frame(width: particle.size, height: particle.size)
            .position(particle.currentPosition)
            .opacity(particle.opacity)
            .scaleEffect(particle.scale)
            .animation(.easeOut(duration: particle.lifetime), value: animationProgress)
            .onAppear {
                withAnimation(.easeOut(duration: particle.lifetime)) {
                    animationProgress = 1.0
                }
            }
    }
}

// MARK: - Particle Effects Modifier

extension View {
    func withParticleSystem() -> some View {
        self.overlay(
            ParticleSystemView(particleManager: ParticleManager())
                .environmentObject(ParticleManager())
        )
    }
}

// MARK: - Specialized Particle Effects

struct SparkleEffect: View {
    let color: Color
    let duration: Double
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                Rectangle()
                    .fill(color)
                    .frame(width: 2, height: 8)
                    .rotationEffect(.degrees(Double(index) * 45))
                    .scaleEffect(isAnimating ? 1.5 : 0.5)
                    .opacity(isAnimating ? 0 : 1)
                    .animation(
                        .easeInOut(duration: duration)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct PulseEffect: View {
    let color: Color
    let duration: Double
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .fill(color.opacity(0.3))
            .scaleEffect(isAnimating ? 2.0 : 0.5)
            .opacity(isAnimating ? 0 : 1)
            .animation(
                .easeInOut(duration: duration)
                    .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

struct WaveEffect: View {
    let color: Color
    let duration: Double
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .stroke(color, lineWidth: 2)
                    .scaleEffect(isAnimating ? 3.0 : 0.5)
                    .opacity(isAnimating ? 0 : 1)
                    .animation(
                        .easeInOut(duration: duration)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Particle Effect Presets

struct ParticleEffectPresets {
    static func victoryCelebration(at position: CGPoint, particleManager: ParticleManager) {
        // Create multiple effects for a grand celebration
        particleManager.createVictoryEffect(at: position)
        
        // Add sparkles
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            particleManager.createVictorySparkleEffect(at: position)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            particleManager.createVictorySparkleEffect(at: position)
        }
    }
    
    static func boardCompletion(at position: CGPoint, player: Player, particleManager: ParticleManager) {
        particleManager.createBoardWinEffect(at: position, player: player)
        
        // Add a small sparkle effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            particleManager.createMoveConfettiEffect(at: position, player: player)
        }
    }
    
    static func gameStart(at position: CGPoint, particleManager: ParticleManager) {
        particleManager.createGameStartEffect(at: position)
        
        // Add wave effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            particleManager.createMoveEffect(at: position, player: .x)
        }
    }
    
    static func scoreUpdate(at position: CGPoint, player: Player, particleManager: ParticleManager) {
        particleManager.createScoreUpdateEffect(at: position, player: player)
    }
    
    static func timerWarning(at position: CGPoint, particleManager: ParticleManager) {
        particleManager.createTimerWarningEffect(at: position)
        
        // Add pulse effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            particleManager.createButtonPressEffect(at: position)
        }
    }
    
    static func buttonPress(at position: CGPoint, particleManager: ParticleManager) {
        particleManager.createButtonPressEffect(at: position)
    }
    
    static func boardTransition(at position: CGPoint, particleManager: ParticleManager) {
        particleManager.createBoardTransitionEffect(at: position)
    }
    
    static func invalidMove(at position: CGPoint, particleManager: ParticleManager) {
        particleManager.createInvalidMoveEffect(at: position)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        LinearGradient.xoBackgroundGradient
            .ignoresSafeArea()
        
        VStack(spacing: 20) {
            Text("Particle Effects Demo")
                .font(.title)
                .foregroundColor(.xoGold)
            
            Button("Test Move Effect") {
                // This would be connected to a ParticleManager in real usage
            }
            .metallicButton()
            
            Button("Test Victory Effect") {
                // This would be connected to a ParticleManager in real usage
            }
            .metallicButton()
        }
    }
    .withParticleSystem()
} 