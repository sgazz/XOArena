//
//  XOArenaApp.swift
//  XOArena
//
//  Created by Gazza on 26. 7. 2025..
//

import SwiftUI

@main
struct XOArenaApp: App {
    @StateObject private var particleManager = ParticleManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Force dark mode for the metallic theme
                .environmentObject(particleManager)
        }
    }
}
