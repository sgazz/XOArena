# XO Arena - Multi-Board Tic-Tac-Toe iOS Game

A modern, elegant iOS game built with SwiftUI that takes the classic Tic-Tac-Toe to the next level with multiple simultaneous boards and AI opponent.

## 🎮 Features

### Core Gameplay
- **Multi-Board Experience**: Play on 8 simultaneous Tic-Tac-Toe boards
- **Strategic Depth**: Each move affects the overall game state across all boards
- **AI Opponent**: Challenge yourself against an intelligent computer player
- **Win Detection**: Advanced algorithms to detect winning patterns across multiple boards

### User Interface
- **Modern SwiftUI Design**: Clean, responsive interface optimized for iOS
- **Adaptive Layout**: Supports different device orientations and screen sizes
- **Accessibility**: Full VoiceOver support and accessibility features
- **Dynamic Type**: Supports system font scaling for better readability

### Game Features
- **Real-time Scoring**: Track wins, losses, and draws
- **Game State Management**: Pause, resume, and reset functionality
- **Visual Feedback**: Clear indicators for active boards and current player
- **Haptic Feedback**: Tactile responses for better user experience

## 🛠 Technical Stack

- **Framework**: SwiftUI
- **Language**: Swift 5.9+
- **Platform**: iOS 17.6+
- **Architecture**: MVVM with Observation framework
- **State Management**: @Observable, @State, @Environment

## 📱 Screenshots

*Screenshots will be added here*

## 🚀 Getting Started

### Prerequisites
- Xcode 16.0+
- iOS 17.6+ Simulator or Device
- macOS 14.0+

### Installation
1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd XOArena
   ```

2. Open the project in Xcode:
   ```bash
   open XOArena.xcodeproj
   ```

3. Select your target device or simulator

4. Build and run the project (⌘+R)

## 🎯 How to Play

1. **Start a Game**: Launch the app and tap "Start Game"
2. **Choose Mode**: Select between Player vs AI or Player vs Player
3. **Make Moves**: Tap on any cell in the active board to place your mark (X or O)
4. **Strategy**: Plan your moves across all 8 boards to achieve victory
5. **Win Conditions**: Complete winning patterns on individual boards to score points

## 🏗 Project Structure

```
XOArena/
├── XOArena/
│   ├── XOArenaApp.swift              # App entry point
│   ├── ContentView.swift             # Main content view
│   ├── Models/
│   │   ├── GameLogic.swift           # Core game logic
│   │   └── GameModels.swift          # Data models
│   ├── ViewModels/
│   │   └── GameViewModel.swift       # Game state management
│   ├── Views/
│   │   ├── GameScreen.swift          # Main game interface
│   │   ├── IntroScreen.swift         # Welcome screen
│   │   ├── PauseMenuView.swift       # Pause menu
│   │   ├── VictoryScreen.swift       # Game over screen
│   │   └── Components/
│   │       ├── TicTacToeBoard.swift  # Individual board component
│   │       ├── AccessibilityEnhancements.swift
│   │       └── ParticleEffects.swift
│   ├── Theme/
│   │   ├── ColorTheme.swift          # Color definitions
│   │   └── ViewModifiers.swift       # Custom view modifiers
│   └── Utilities/
│       └── HapticManager.swift       # Haptic feedback
└── Assets.xcassets/                  # App icons and assets
```

## 🎨 Design System

### Colors
- **Primary**: Dark metallic theme with gold accents
- **Adaptive**: Supports light/dark mode and high contrast
- **Accessibility**: WCAG compliant color combinations

### Typography
- **System Fonts**: Uses SF Pro for optimal readability
- **Dynamic Type**: Scales with user preferences
- **Hierarchy**: Clear visual hierarchy for game elements

## 🔧 Customization

### Adding New Features
1. Follow MVVM architecture patterns
2. Use @Observable for view models
3. Implement proper accessibility features
4. Test on multiple device sizes

### Styling
- Modify `ColorTheme.swift` for color changes
- Update `ViewModifiers.swift` for component styling
- Use custom modifiers for consistent design

## 🧪 Testing

### Unit Tests
- Game logic testing in `GameLogic.swift`
- View model testing for state management
- Model validation tests

### UI Tests
- Critical user flows
- Accessibility testing
- Cross-device compatibility

## 📋 Requirements

### Minimum Requirements
- iOS 17.6+
- iPhone/iPad with 2GB RAM
- 50MB available storage

### Recommended
- iOS 18.0+
- iPhone 12 or newer
- iPad Air (4th generation) or newer

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- SwiftUI team for the amazing framework
- Apple for iOS development tools
- The open-source community for inspiration and resources

## 📞 Support

For support, please open an issue in the GitHub repository or contact the development team.

---

**Made with ❤️ using SwiftUI** 