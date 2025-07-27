import SwiftUI

// MARK: - Color Theme based on XOArena icon

extension Color {
    
    // MARK: - Primary Colors (from icon)
    
    /// Gold/Metallic color for main elements (like XO letters)
    static let xoGold = Color(red: 0.85, green: 0.65, blue: 0.13)
    
    /// Dark gold for gradients
    static let xoDarkGold = Color(red: 0.65, green: 0.45, blue: 0.05)
    
    /// Light gold for highlights
    static let xoLightGold = Color(red: 0.95, green: 0.75, blue: 0.25)
    
    /// Dark background (from icon)
    static let xoDarkBackground = Color(red: 0.08, green: 0.08, blue: 0.12)
    
    /// Darker background for depth
    static let xoDarkerBackground = Color(red: 0.04, green: 0.04, blue: 0.08)
    
    // MARK: - Accent Colors (from icon)
    
    /// Vibrant blue (from light trails)
    static let xoVibrantBlue = Color(red: 0.0, green: 0.8, blue: 1.0)
    
    /// Cyan blue for effects
    static let xoCyanBlue = Color(red: 0.0, green: 0.9, blue: 0.9)
    
    /// Vibrant orange-red (from light trails)
    static let xoVibrantOrange = Color(red: 1.0, green: 0.4, blue: 0.0)
    
    /// Orange-red for effects
    static let xoOrangeRed = Color(red: 0.9, green: 0.3, blue: 0.0)
    
    // MARK: - Metallic Colors
    
    /// Metallic silver for UI elements
    static let xoMetallicSilver = Color(red: 0.75, green: 0.75, blue: 0.8)
    
    /// Dark metallic for borders
    static let xoDarkMetallic = Color(red: 0.3, green: 0.3, blue: 0.35)
    
    // MARK: - Status Colors
    
    /// Success green
    static let xoSuccess = Color(red: 0.2, green: 0.8, blue: 0.4)
    
    /// Warning orange
    static let xoWarning = Color(red: 1.0, green: 0.6, blue: 0.0)
    
    /// Error red
    static let xoError = Color(red: 0.9, green: 0.2, blue: 0.2)
    
    // MARK: - Text Colors
    
    /// Primary text color (gold)
    static let xoTextPrimary = xoGold
    
    /// Secondary text color (light gold)
    static let xoTextSecondary = xoLightGold
    
    /// Muted text color (metallic silver)
    static let xoTextMuted = xoMetallicSilver
    
    // MARK: - High Contrast Colors for Accessibility
    
    /// High contrast gold for accessibility
    static let xoGoldHighContrast = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    /// High contrast blue for accessibility
    static let xoBlueHighContrast = Color(red: 0.0, green: 0.9, blue: 1.0)
    
    /// High contrast orange for accessibility
    static let xoOrangeHighContrast = Color(red: 1.0, green: 0.5, blue: 0.0)
    
    /// High contrast background for accessibility
    static let xoBackgroundHighContrast = Color(red: 0.02, green: 0.02, blue: 0.06)
    
    /// High contrast text for accessibility
    static let xoTextHighContrast = Color.white
}

// MARK: - Gradient Definitions

extension LinearGradient {
    
    /// Gold gradient (from icon XO letters)
    static let xoGoldGradient = LinearGradient(
        colors: [.xoDarkGold, .xoGold, .xoLightGold],
        startPoint: .bottomLeading,
        endPoint: .topTrailing
    )
    
    /// Background gradient (from icon)
    static let xoBackgroundGradient = LinearGradient(
        colors: [.xoDarkerBackground, .xoDarkBackground],
        startPoint: .top,
        endPoint: .bottom
    )
    
    /// Blue light trail gradient (from icon)
    static let xoBlueGradient = LinearGradient(
        colors: [.xoVibrantBlue, .xoCyanBlue],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    /// Orange light trail gradient (from icon)
    static let xoOrangeGradient = LinearGradient(
        colors: [.xoVibrantOrange, .xoOrangeRed],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    /// Metallic gradient for UI elements
    static let xoMetallicGradient = LinearGradient(
        colors: [.xoDarkMetallic, .xoMetallicSilver],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - High Contrast Gradients
    
    /// High contrast gold gradient
    static let xoGoldGradientHighContrast = LinearGradient(
        colors: [.xoGoldHighContrast, .xoGold],
        startPoint: .bottomLeading,
        endPoint: .topTrailing
    )
    
    /// High contrast background gradient
    static let xoBackgroundGradientHighContrast = LinearGradient(
        colors: [.xoBackgroundHighContrast, .xoDarkBackground],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Radial Gradient Definitions

extension RadialGradient {
    
    /// Glow effect gradient (from icon light effects)
    static let xoGlowGradient = RadialGradient(
        colors: [.xoGold.opacity(0.8), .clear],
        center: .center,
        startRadius: 0,
        endRadius: 100
    )
    
    /// Blue glow gradient
    static let xoBlueGlowGradient = RadialGradient(
        colors: [.xoVibrantBlue.opacity(0.6), .clear],
        center: .center,
        startRadius: 0,
        endRadius: 80
    )
    
    /// Orange glow gradient
    static let xoOrangeGlowGradient = RadialGradient(
        colors: [.xoVibrantOrange.opacity(0.6), .clear],
        center: .center,
        startRadius: 0,
        endRadius: 80
    )
    
    // MARK: - High Contrast Glow Gradients
    
    /// High contrast glow gradient
    static let xoGlowGradientHighContrast = RadialGradient(
        colors: [.xoGoldHighContrast.opacity(0.9), .clear],
        center: .center,
        startRadius: 0,
        endRadius: 100
    )
}

// MARK: - Color Scheme for Dark Mode

struct XOColorScheme {
    static let primary = Color.xoGold
    static let secondary = Color.xoVibrantBlue
    static let accent = Color.xoVibrantOrange
    static let background = Color.xoDarkBackground
    static let surface = Color.xoDarkerBackground
    static let text = Color.xoTextPrimary
    static let textSecondary = Color.xoTextSecondary
    static let border = Color.xoDarkMetallic
    static let success = Color.xoSuccess
    static let warning = Color.xoWarning
    static let error = Color.xoError
}

// MARK: - High Contrast Color Scheme

struct XOColorSchemeHighContrast {
    static let primary = Color.xoGoldHighContrast
    static let secondary = Color.xoBlueHighContrast
    static let accent = Color.xoOrangeHighContrast
    static let background = Color.xoBackgroundHighContrast
    static let surface = Color.xoDarkBackground
    static let text = Color.xoTextHighContrast
    static let textSecondary = Color.xoGoldHighContrast
    static let border = Color.xoGoldHighContrast
    static let success = Color.xoSuccess
    static let warning = Color.xoWarning
    static let error = Color.xoError
}

// MARK: - Accessibility Color Extensions

extension Color {
    
    /// Get appropriate color based on accessibility settings
    static func adaptiveColor(standard: Color, highContrast: Color, isHighContrast: Bool) -> Color {
        return isHighContrast ? highContrast : standard
    }
    
    /// Adaptive gold color
    static func adaptiveGold(isHighContrast: Bool) -> Color {
        adaptiveColor(standard: .xoGold, highContrast: .xoGoldHighContrast, isHighContrast: isHighContrast)
    }
    
    /// Adaptive gold color (auto-detect)
    static func adaptiveGold() -> Color {
        adaptiveColor(standard: .xoGold, highContrast: .xoGoldHighContrast, isHighContrast: false)
    }
    
    /// Adaptive blue color
    static func adaptiveBlue(isHighContrast: Bool) -> Color {
        adaptiveColor(standard: .xoVibrantBlue, highContrast: .xoBlueHighContrast, isHighContrast: isHighContrast)
    }
    
    /// Adaptive blue color (auto-detect)
    static func adaptiveBlue() -> Color {
        adaptiveColor(standard: .xoVibrantBlue, highContrast: .xoBlueHighContrast, isHighContrast: false)
    }
    
    /// Adaptive orange color
    static func adaptiveOrange(isHighContrast: Bool) -> Color {
        adaptiveColor(standard: .xoVibrantOrange, highContrast: .xoOrangeHighContrast, isHighContrast: isHighContrast)
    }
    
    /// Adaptive orange color (auto-detect)
    static func adaptiveOrange() -> Color {
        adaptiveColor(standard: .xoVibrantOrange, highContrast: .xoOrangeHighContrast, isHighContrast: false)
    }
    
    /// Adaptive text color
    static func adaptiveText(isHighContrast: Bool) -> Color {
        adaptiveColor(standard: .xoTextPrimary, highContrast: .xoTextHighContrast, isHighContrast: isHighContrast)
    }
    
    /// Adaptive text color (auto-detect)
    static func adaptiveText() -> Color {
        adaptiveColor(standard: .xoTextPrimary, highContrast: .xoTextHighContrast, isHighContrast: false)
    }
    
    /// Adaptive background color
    static func adaptiveBackground(isHighContrast: Bool) -> Color {
        adaptiveColor(standard: .xoDarkBackground, highContrast: .xoBackgroundHighContrast, isHighContrast: isHighContrast)
    }
    
    /// Adaptive background color (auto-detect)
    static func adaptiveBackground() -> Color {
        adaptiveColor(standard: .xoDarkBackground, highContrast: .xoBackgroundHighContrast, isHighContrast: false)
    }
} 