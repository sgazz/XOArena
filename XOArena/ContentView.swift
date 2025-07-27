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
    
    var body: some View {
        ZStack {
            LinearGradient.xoBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Title
                Text("GAME SETUP")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .goldText()
                    .glow(color: Color.xoGold, radius: 15)
                    .accessibilityLabel("Game Setup Title")
                
                // Game mode selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Game Mode")
                        .font(.headline)
                        .foregroundColor(.xoTextPrimary)
                        .accessibilityLabel("Game Mode Selection")
                    
                    HStack(spacing: 16) {
                        ForEach(GameMode.allCases, id: \.self) { mode in
                            Button(mode.displayName) {
                                selectedGameMode = mode
                            }
                            .metallicButton(isPressed: selectedGameMode == mode, isHighContrast: false)
                            .foregroundColor(selectedGameMode == mode ? .xoDarkerBackground : .xoTextPrimary)
                            .accessibilityLabel("\(mode.displayName) mode")
                            .accessibilityHint(selectedGameMode == mode ? "Currently selected" : "Select \(mode.displayName) mode")
                        }
                    }
                }
                
                // Timer duration (if timed mode)
                if selectedGameMode == .timed {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Timer Duration")
                            .font(.headline)
                            .foregroundColor(.xoTextPrimary)
                            .accessibilityLabel("Timer Duration Selection")
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(TimerDuration.allCases, id: \.self) { duration in
                                Button(duration.displayName) {
                                    selectedTimerDuration = duration
                                }
                                .metallicButton(isPressed: selectedTimerDuration == duration, isHighContrast: false)
                                .foregroundColor(selectedTimerDuration == duration ? .xoDarkerBackground : .xoTextPrimary)
                                .accessibilityLabel("\(duration.displayName) timer")
                                .accessibilityHint(selectedTimerDuration == duration ? "Currently selected" : "Select \(duration.displayName) timer")
                            }
                        }
                    }
                }
                
                // AI opponent selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Opponent")
                        .font(.headline)
                        .foregroundColor(.xoTextPrimary)
                        .accessibilityLabel("Opponent Selection")
                    
                    HStack(spacing: 16) {
                        Button("Human") {
                            isAIGame = false
                        }
                        .metallicButton(isPressed: !isAIGame, isHighContrast: false)
                        .foregroundColor(!isAIGame ? .xoDarkerBackground : .xoTextPrimary)
                        .accessibilityLabel("Human opponent")
                        .accessibilityHint(!isAIGame ? "Currently selected" : "Play against another human")
                        
                        Button("AI") {
                            isAIGame = true
                        }
                        .metallicButton(isPressed: isAIGame, isHighContrast: false)
                        .foregroundColor(isAIGame ? .xoDarkerBackground : .xoTextPrimary)
                        .accessibilityLabel("AI opponent")
                        .accessibilityHint(isAIGame ? "Currently selected" : "Play against computer")
                    }
                }
                
                // AI difficulty (if AI game)
                if isAIGame {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("AI Difficulty")
                            .font(.headline)
                            .foregroundColor(.xoTextPrimary)
                            .accessibilityLabel("AI Difficulty Selection")
                        
                        HStack(spacing: 12) {
                            ForEach(AIDifficulty.allCases, id: \.self) { difficulty in
                                Button(difficulty.displayName) {
                                    selectedAIDifficulty = difficulty
                                }
                                .metallicButton(isPressed: selectedAIDifficulty == difficulty, isHighContrast: false)
                                .foregroundColor(selectedAIDifficulty == difficulty ? .xoDarkerBackground : .xoTextPrimary)
                                .accessibilityLabel("\(difficulty.displayName) difficulty")
                                .accessibilityHint(selectedAIDifficulty == difficulty ? "Currently selected" : "Select \(difficulty.displayName) difficulty")
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 20) {
                    Button("BACK") {
                        onBack()
                    }
                    .metallicButton(isHighContrast: false)
                    .accessibilityLabel("Back to main menu")
                    
                    Button("START") {
                        gameViewModel.startNewGame(
                            aiGame: isAIGame,
                            aiDifficulty: selectedAIDifficulty,
                            gameMode: selectedGameMode,
                            timerDuration: selectedTimerDuration
                        )
                        onStartGame()
                    }
                    .metallicButton(isHighContrast: false)
                    .accessibilityLabel("Start game")
                    .accessibilityHint("Begin the game with selected settings")
                }
            }
            .padding()
        }
        .highContrastSupport(isHighContrast: false)
        .dynamicTypeSupport()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Game Setup Screen")
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
    
    init(gameViewModel: GameViewModel, onBack: @escaping () -> Void) {
        self.gameViewModel = gameViewModel
        self.onBack = onBack
        self._settings = State(initialValue: gameViewModel.settings)
    }
    
    var body: some View {
        ZStack {
            LinearGradient.xoBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("SETTINGS")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .goldText()
                    .glow(color: Color.xoGold, radius: 15)
                    .accessibilityLabel("Settings Title")
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsSection(title: "AI Difficulty") {
                            ForEach(AIDifficulty.allCases, id: \.self) { difficulty in
                                Button(difficulty.displayName) {
                                    settings.aiDifficulty = difficulty
                                }
                                .metallicButton(isPressed: settings.aiDifficulty == difficulty, isHighContrast: false)
                                .foregroundColor(settings.aiDifficulty == difficulty ? .xoDarkerBackground : .xoTextPrimary)
                                .accessibilityLabel("\(difficulty.displayName) AI difficulty")
                                .accessibilityHint(settings.aiDifficulty == difficulty ? "Currently selected" : "Select \(difficulty.displayName) difficulty")
                            }
                        }
                        
                        SettingsSection(title: "Game Mode") {
                            ForEach(GameMode.allCases, id: \.self) { mode in
                                Button(mode.displayName) {
                                    settings.gameMode = mode
                                }
                                .metallicButton(isPressed: settings.gameMode == mode, isHighContrast: false)
                                .foregroundColor(settings.gameMode == mode ? .xoDarkerBackground : .xoTextPrimary)
                                .accessibilityLabel("\(mode.displayName) game mode")
                                .accessibilityHint(settings.gameMode == mode ? "Currently selected" : "Select \(mode.displayName) mode")
                            }
                        }
                        
                        SettingsSection(title: "Timer Duration") {
                            ForEach(TimerDuration.allCases, id: \.self) { duration in
                                Button(duration.displayName) {
                                    settings.timerDuration = duration
                                }
                                .metallicButton(isPressed: settings.timerDuration == duration, isHighContrast: false)
                                .foregroundColor(settings.timerDuration == duration ? .xoDarkerBackground : .xoTextPrimary)
                                .accessibilityLabel("\(duration.displayName) timer")
                                .accessibilityHint(settings.timerDuration == duration ? "Currently selected" : "Select \(duration.displayName) timer")
                            }
                        }
                        
                        SettingsSection(title: "Sound & Haptics") {
                            Toggle("Sound Effects", isOn: $settings.soundEnabled)
                                .toggleStyle(MetallicToggleStyle())
                                .accessibilityLabel("Sound Effects")
                                .accessibilityHint("Enable or disable sound effects")
                            
                            Toggle("Haptic Feedback", isOn: $settings.hapticEnabled)
                                .toggleStyle(MetallicToggleStyle())
                                .accessibilityLabel("Haptic Feedback")
                                .accessibilityHint("Enable or disable haptic feedback")
                        }
                    }
                    .padding()
                }
                
                Button("SAVE") {
                    gameViewModel.updateSettings(settings)
                    onBack()
                }
                .metallicButton(isHighContrast: false)
                .accessibilityLabel("Save settings")
                .accessibilityHint("Save changes and return to main menu")
            }
            .padding()
        }
        .highContrastSupport(isHighContrast: false)
        .dynamicTypeSupport()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Settings Screen")
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
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.xoTextPrimary)
                .accessibilityLabel("\(title) section")
            
            content
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

// MARK: - Metallic Toggle Style

struct MetallicToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .foregroundColor(.xoTextPrimary)
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? LinearGradient.xoGoldGradient : LinearGradient.xoMetallicGradient)
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 26, height: 26)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
                .accessibilityLabel("Toggle")
                .accessibilityValue(configuration.isOn ? "On" : "Off")
                .accessibilityHint("Double tap to toggle")
        }
    }
}

#Preview("Metallic Toggle Style") {
    VStack(spacing: 20) {
        Toggle("Sound Effects", isOn: .constant(true))
            .toggleStyle(MetallicToggleStyle())
        
        Toggle("Haptic Feedback", isOn: .constant(false))
            .toggleStyle(MetallicToggleStyle())
    }
    .padding()
    .background(LinearGradient.xoBackgroundGradient)
}

#Preview {
    ContentView()
}
