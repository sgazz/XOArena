//
//  ContentView.swift
//  XOArena
//
//  Created by Gazza on 26. 7. 2025..
//

import SwiftUI
import Observation

struct ContentView: View {
    let gameViewModel = GameViewModel()
    @State private var currentScreen: GameScreenType = .intro
    @State private var slideOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            switch currentScreen {
            case .intro:
                IntroScreen(
                    onStartGame: {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            slideOffset = -UIScreen.main.bounds.width
                            currentScreen = .gameSetup
                        }
                    },
                    onShowTutorial: {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            slideOffset = UIScreen.main.bounds.width
                            currentScreen = .tutorial
                        }
                    },
                    onShowSettings: {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            slideOffset = UIScreen.main.bounds.width
                            currentScreen = .settings
                        }
                    }
                )
                .offset(x: slideOffset)
                .onAppear {
                    slideOffset = 0
                }
                
            case .gameSetup:
                GameSetupScreen(
                    gameViewModel: gameViewModel,
                    onStartGame: {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            slideOffset = -UIScreen.main.bounds.width
                            currentScreen = .game
                        }
                    },
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            slideOffset = UIScreen.main.bounds.width
                            currentScreen = .intro
                        }
                    }
                )
                .offset(x: slideOffset)
                .onAppear {
                    slideOffset = 0
                }
                
            case .game:
                GameScreen(gameViewModel: gameViewModel)
                    .offset(x: slideOffset)
                    .onAppear {
                        slideOffset = 0
                    }
                    .onChange(of: gameViewModel.gameState) { _, newState in
                        if newState == .menu {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                slideOffset = UIScreen.main.bounds.width
                                currentScreen = .intro
                            }
                        }
                    }
                
            case .tutorial:
                TutorialScreen(
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            slideOffset = -UIScreen.main.bounds.width
                            currentScreen = .intro
                        }
                    }
                )
                .offset(x: slideOffset)
                .onAppear {
                    slideOffset = 0
                }
                
            case .settings:
                SettingsScreen(
                    gameViewModel: gameViewModel,
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            slideOffset = -UIScreen.main.bounds.width
                            currentScreen = .intro
                        }
                    }
                )
                .offset(x: slideOffset)
                .onAppear {
                    slideOffset = 0
                }
            }
        }
        .highContrastSupport(isHighContrast: false)
        .dynamicTypeSupport()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("XO Arena Content View")
    }
}

// MARK: - Game Screen Enum

enum GameScreenType {
    case intro
    case gameSetup
    case game
    case tutorial
    case settings
}

// MARK: - Game Setup Screen

struct GameSetupScreen: View {
    let gameViewModel: GameViewModel
    let onStartGame: () -> Void
    let onBack: () -> Void
    
    @State private var selectedGameMode: GameMode = .classic
    @State private var selectedTimerDuration: TimerDuration = .threeMinutes
    @State private var selectedAIDifficulty: AIDifficulty = .normal
    @State private var isAIGame: Bool = false
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        ZStack {
            LinearGradient.xoBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.xoGold)
                        .accessibilityLabel("Game Setup icon")
                    
                    Text("GAME SETUP")
                        .font(.system(size: titleFontSize, weight: .bold))
                        .foregroundColor(.xoGold)
                        .accessibilityLabel("Game Setup Title")
                }
                
                // Compact settings grid
                VStack(spacing: 16) {
                    // Game Mode Row
                    CompactSettingsRow(
                        title: "Game Mode",
                        options: GameMode.allCases.map { $0.displayName },
                        selectedIndex: GameMode.allCases.firstIndex(of: selectedGameMode) ?? 0
                    ) { index in
                        selectedGameMode = GameMode.allCases[index]
                    }
                    
                    // Timer Duration Row (if timed mode)
                    if selectedGameMode == .timed {
                        CompactSettingsRow(
                            title: "Timer",
                            options: TimerDuration.allCases.map { $0.displayName },
                            selectedIndex: TimerDuration.allCases.firstIndex(of: selectedTimerDuration) ?? 0
                        ) { index in
                            selectedTimerDuration = TimerDuration.allCases[index]
                        }
                    }
                    
                    // Opponent Row
                    CompactSettingsRow(
                        title: "Opponent",
                        options: ["Human", "AI"],
                        selectedIndex: isAIGame ? 1 : 0
                    ) { index in
                        isAIGame = index == 1
                    }
                    
                    // AI Difficulty Row (if AI game)
                    if isAIGame {
                        CompactSettingsRow(
                            title: "AI Level",
                            options: AIDifficulty.allCases.map { $0.displayName },
                            selectedIndex: AIDifficulty.allCases.firstIndex(of: selectedAIDifficulty) ?? 0
                        ) { index in
                            selectedAIDifficulty = AIDifficulty.allCases[index]
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 12) {
                    ActionButton(
                        title: "START GAME",
                        icon: "play.fill",
                        isSelected: false,
                        action: {
                            gameViewModel.startNewGame(
                                aiGame: isAIGame,
                                aiDifficulty: selectedAIDifficulty,
                                gameMode: selectedGameMode,
                                timerDuration: selectedTimerDuration
                            )
                            onStartGame()
                        }
                    )
                    
                    ActionButton(
                        title: "BACK",
                        icon: "arrow.left",
                        isSelected: false,
                        action: onBack
                    )
                }
                .padding(.horizontal, 32)
            }
            .padding(.vertical, 20)
        }
        .onAppear {
            // Initialize with default values (these will be set per game)
            selectedGameMode = .classic
            selectedTimerDuration = .threeMinutes
            selectedAIDifficulty = .normal
            isAIGame = false
        }
        .highContrastSupport(isHighContrast: false)
        .dynamicTypeSupport()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Game Setup Screen")
    }
    
    private var titleFontSize: CGFloat {
        let baseSize: CGFloat = horizontalSizeClass == .regular ? 24 : 20
        
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

// MARK: - Compact Settings Row

struct CompactSettingsRow: View {
    let title: String
    let options: [String]
    let selectedIndex: Int
    let onSelectionChanged: (Int) -> Void
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: labelFontSize, weight: .semibold))
                .foregroundColor(.xoTextPrimary)
                .accessibilityLabel("\(title) selection")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: options.count), spacing: 8) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    CompactOptionButton(
                        title: option,
                        isSelected: selectedIndex == index,
                        action: {
                            onSelectionChanged(index)
                        }
                    )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.xoDarkerBackground.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.xoDarkMetallic, lineWidth: 1)
                )
        )
    }
    
    private var labelFontSize: CGFloat {
        let baseSize: CGFloat = 16
        
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

// MARK: - Compact Option Button

struct CompactOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: buttonFontSize, weight: .medium))
                .foregroundColor(isSelected ? .xoDarkBackground : .xoGold)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.xoGold : Color.xoDarkBackground.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.xoGold.opacity(0.5), lineWidth: 1)
                        )
                )
                .scaleEffect(isSelected ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(title)
        .accessibilityHint(isSelected ? "Currently selected" : "Select \(title)")
    }
    
    private var buttonFontSize: CGFloat {
        let baseSize: CGFloat = 14
        
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

#Preview("Game Setup Screen") {
    let mockViewModel = GameViewModel()
    return GameSetupScreen(
        gameViewModel: mockViewModel,
        onStartGame: {},
        onBack: {}
    )
}

// MARK: - Tutorial Screen

struct TutorialScreen: View {
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient.xoBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("HOW TO PLAY")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .goldText()
                    .glow(color: Color.xoGold, radius: 15)
                    .accessibilityLabel("How to Play Title")
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        TutorialStep(
                            number: 1,
                            title: "8 Boards",
                            description: "Play on 8 different TicTacToe boards simultaneously. Each board follows standard TicTacToe rules."
                        )
                        
                        TutorialStep(
                            number: 2,
                            title: "Player X Goes First",
                            description: "Player X always makes the first move on any board. Players take turns placing their marks."
                        )
                        
                        TutorialStep(
                            number: 3,
                            title: "Board Transition",
                            description: "After Player O makes a move, the game automatically moves to the next board in sequence."
                        )
                        
                        TutorialStep(
                            number: 4,
                            title: "Winning",
                            description: "The first player to win 5 out of 8 boards becomes the champion of XO Arena!"
                        )
                        
                        TutorialStep(
                            number: 5,
                            title: "Timer Mode",
                            description: "In timed mode, players race against the clock. The player with the most wins when time runs out wins!"
                        )
                    }
                    .padding()
                }
                
                Button("GOT IT!") {
                    onBack()
                }
                .metallicButton()
                .accessibilityLabel("Got it")
                .accessibilityHint("Return to main menu")
            }
            .padding()
        }
        .highContrastSupport(isHighContrast: false)
        .dynamicTypeSupport()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Tutorial Screen")
    }
}

#Preview("Tutorial Screen") {
    TutorialScreen(onBack: {})
}

// MARK: - Tutorial Step

struct TutorialStep: View {
    let number: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("\(number)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.xoGold)
                .frame(width: 30, height: 30)
                .background(
                    Circle()
                        .fill(Color.xoDarkMetallic)
                        .overlay(
                            Circle()
                                .stroke(Color.xoGold, lineWidth: 2)
                        )
                )
                .accessibilityLabel("Step \(number)")
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.xoTextPrimary)
                    .accessibilityLabel("Step \(number): \(title)")
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.xoTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityLabel(description)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Step \(number): \(title). \(description)")
    }
}

#Preview("Tutorial Step") {
    TutorialStep(
        number: 1,
        title: "8 Boards",
        description: "Play on 8 different TicTacToe boards simultaneously. Each board follows standard TicTacToe rules."
    )
    .padding()
    .background(LinearGradient.xoBackgroundGradient)
}

// MARK: - Settings Screen

struct SettingsScreen: View {
    let gameViewModel: GameViewModel
    let onBack: () -> Void
    
    @State private var settings: GameSettings
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    init(gameViewModel: GameViewModel, onBack: @escaping () -> Void) {
        self.gameViewModel = gameViewModel
        self.onBack = onBack
        self._settings = State(initialValue: gameViewModel.settings)
    }
    
    var body: some View {
        ZStack {
            LinearGradient.xoBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 48, weight: .light))
                        .foregroundColor(.xoGold)
                        .accessibilityLabel("Settings icon")
                    
                    Text("SETTINGS")
                        .font(.system(size: titleFontSize, weight: .bold))
                        .foregroundColor(.xoGold)
                        .accessibilityLabel("Settings Title")
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsSection(title: "Sound & Haptics") {
                            VStack(spacing: 16) {
                                SettingsToggle(
                                    title: "Sound Effects",
                                    isOn: $settings.soundEnabled
                                )
                                
                                SettingsToggle(
                                    title: "Haptic Feedback",
                                    isOn: $settings.hapticEnabled
                                )
                            }
                        }
                        
                        SettingsSection(title: "Accessibility") {
                            VStack(spacing: 16) {
                                SettingsToggle(
                                    title: "High Contrast Mode",
                                    isOn: $settings.highContrastMode
                                )
                                
                                SettingsToggle(
                                    title: "Reduce Motion",
                                    isOn: $settings.reduceMotion
                                )
                            }
                        }
                        
                        SettingsSection(title: "Game Options") {
                            VStack(spacing: 16) {
                                SettingsToggle(
                                    title: "Auto Save",
                                    isOn: $settings.autoSaveEnabled
                                )
                                
                                SettingsToggle(
                                    title: "Show Tutorial",
                                    isOn: $settings.tutorialShown
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // Action buttons
                VStack(spacing: 12) {
                    ActionButton(
                        title: "SAVE",
                        icon: "checkmark",
                        isSelected: false,
                        action: {
                            gameViewModel.updateSettings(settings)
                            onBack()
                        }
                    )
                    
                    ActionButton(
                        title: "BACK",
                        icon: "arrow.left",
                        isSelected: false,
                        action: onBack
                    )
                }
                .padding(.horizontal, 32)
            }
            .padding(.vertical, 20)
        }
        .highContrastSupport(isHighContrast: false)
        .dynamicTypeSupport()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Settings Screen")
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
}

// MARK: - Settings Button

struct SettingsButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: buttonFontSize, weight: .medium))
                    .foregroundColor(isSelected ? .xoDarkBackground : .xoGold)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.xoDarkBackground)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.xoGold : Color.xoDarkBackground.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.xoGold.opacity(0.5), lineWidth: 1)
                    )
            )
            .scaleEffect(isSelected ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(title)
        .accessibilityHint(isSelected ? "Currently selected" : "Select \(title)")
    }
    
    private var buttonFontSize: CGFloat {
        let baseSize: CGFloat = 16
        
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

// MARK: - Settings Toggle

struct SettingsToggle: View {
    let title: String
    @Binding var isOn: Bool
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: toggleFontSize, weight: .medium))
                .foregroundColor(.xoTextPrimary)
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isOn.toggle()
                }
            }) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(isOn ? Color.xoGold : Color.xoDarkBackground.opacity(0.8))
                    .frame(width: 50, height: 30)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 26, height: 26)
                            .offset(x: isOn ? 10 : -10)
                            .animation(.easeInOut(duration: 0.2), value: isOn)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.xoGold.opacity(0.5), lineWidth: 1)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .accessibilityLabel(title)
        .accessibilityValue(isOn ? "On" : "Off")
        .accessibilityHint("Double tap to toggle")
    }
    
    private var toggleFontSize: CGFloat {
        let baseSize: CGFloat = 16
        
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

#Preview("Settings Screen") {
    let mockViewModel = GameViewModel()
    return SettingsScreen(
        gameViewModel: mockViewModel,
        onBack: {}
    )
}

// MARK: - Settings Section

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: sectionTitleFontSize, weight: .bold))
                .foregroundColor(.xoTextPrimary)
                .accessibilityLabel("\(title) section")
            
            content
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
    }
    
    private var sectionTitleFontSize: CGFloat {
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
}

#Preview("Settings Section") {
    SettingsSection(title: "Test Section") {
        Text("This is a test content for the settings section")
            .foregroundColor(.xoTextPrimary)
    }
    .padding()
    .background(LinearGradient.xoBackgroundGradient)
}

#Preview {
    ContentView()
}
