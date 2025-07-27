import Foundation
import UIKit
import AVFoundation

// MARK: - Sound Manager

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayers: [URL: AVAudioPlayer] = [:]
    private var isEnabled = true
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func playSound(_ soundName: String) {
        guard isEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            print("Sound file not found: \(soundName)")
            return
        }
        
        if let player = audioPlayers[url] {
            player.currentTime = 0
            player.play()
        } else {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                audioPlayers[url] = player
                player.play()
            } catch {
                print("Failed to play sound: \(error)")
            }
        }
    }
    
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
    
    func isSoundEnabled() -> Bool {
        return isEnabled
    }
}

// MARK: - Haptic Manager

class HapticManager {
    static let shared = HapticManager()
    
    private var isEnabled = true
    
    private init() {}
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard isEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func selection() {
        guard isEnabled else { return }
        
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func boardNavigation() {
        guard isEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func victoryCelebration() {
        guard isEnabled else { return }
        
        // Sequence of haptic feedback for victory
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    // Game-specific haptic functions
    func playBoardTransition() {
        impact(.light)
    }
    
    func playGameStart() {
        notification(.success)
    }
    
    func playMove() {
        impact(.light)
    }
    
    func playInvalidMove() {
        impact(.heavy)
    }
    
    func playBoardWin() {
        impact(.medium)
    }
    
    func playBoardDraw() {
        impact(.light)
    }
    
    func playBoardNavigation() {
        selection()
    }
    
    func playVictoryCelebration() {
        notification(.success)
    }
    
    func playGameEnd() {
        notification(.warning)
    }
    
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
    
    func isHapticEnabled() -> Bool {
        return isEnabled
    }
}

// MARK: - Combined Feedback Manager

class FeedbackManager {
    static let shared = FeedbackManager()
    
    private let hapticManager = HapticManager.shared
    private let soundManager = SoundManager.shared
    
    private init() {}
    
    // Game events
    func moveMade() {
        hapticManager.impact(.light)
        soundManager.playSound("move")
    }
    
    func boardWon() {
        hapticManager.impact(.medium)
        soundManager.playSound("board_win")
    }
    
    func gameWon() {
        hapticManager.notification(.success)
        soundManager.playSound("game_win")
    }
    
    func gameLost() {
        hapticManager.notification(.error)
        soundManager.playSound("game_lose")
    }
    
    func buttonPressed() {
        hapticManager.impact(.light)
        soundManager.playSound("button")
    }
    
    func timerWarning() {
        hapticManager.impact(.heavy)
        soundManager.playSound("timer_warning")
    }
    
    func timerExpired() {
        hapticManager.notification(.warning)
        soundManager.playSound("timer_expired")
    }
    
    // Settings
    func setHapticEnabled(_ enabled: Bool) {
        hapticManager.setEnabled(enabled)
    }
    
    func setSoundEnabled(_ enabled: Bool) {
        soundManager.setEnabled(enabled)
    }
    
    func isHapticEnabled() -> Bool {
        return hapticManager.isHapticEnabled()
    }
    
    func isSoundEnabled() -> Bool {
        return soundManager.isSoundEnabled()
    }
} 