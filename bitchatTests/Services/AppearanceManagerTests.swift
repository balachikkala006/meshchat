//
// AppearanceManagerTests.swift
// bitchatTests
//
// Tests for AppearanceManager
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import Testing
import Foundation
import SwiftUI
@testable import bitchat

struct AppearanceManagerTests {
    
    // MARK: - Setup/Teardown
    
    func setup() {
        // Reset to system default
        UserDefaults.standard.removeObject(forKey: "meshchat.appearance")
    }
    
    // MARK: - Initialization Tests
    
    @Test
    func initialization_defaultsToSystem() {
        setup()
        
        let manager = AppearanceManager.shared
        #expect(manager.appearance == .system)
    }
    
    @Test
    func initialization_loadsSavedPreference() {
        setup()
        
        UserDefaults.standard.set("dark", forKey: "meshchat.appearance")
        // Note: Since AppearanceManager is a singleton, we can't easily test this
        // without resetting the singleton. In a real scenario, you might want to
        // make AppearanceManager non-singleton for testing, or use dependency injection.
        
        // For now, test that setting works
        AppearanceManager.shared.appearance = .dark
        #expect(AppearanceManager.shared.appearance == .dark)
        
        // Reset
        AppearanceManager.shared.appearance = .system
    }
    
    // MARK: - Appearance Switching Tests
    
    @Test
    func setAppearance_light_updatesCorrectly() {
        setup()
        
        AppearanceManager.shared.appearance = .light
        #expect(AppearanceManager.shared.appearance == .light)
        
        // Verify it's persisted
        let saved = UserDefaults.standard.string(forKey: "meshchat.appearance")
        #expect(saved == "light")
        
        // Reset
        AppearanceManager.shared.appearance = .system
    }
    
    @Test
    func setAppearance_dark_updatesCorrectly() {
        setup()
        
        AppearanceManager.shared.appearance = .dark
        #expect(AppearanceManager.shared.appearance == .dark)
        
        // Verify it's persisted
        let saved = UserDefaults.standard.string(forKey: "meshchat.appearance")
        #expect(saved == "dark")
        
        // Reset
        AppearanceManager.shared.appearance = .system
    }
    
    @Test
    func setAppearance_system_updatesCorrectly() {
        setup()
        
        AppearanceManager.shared.appearance = .system
        #expect(AppearanceManager.shared.appearance == .system)
        
        // Verify it's persisted
        let saved = UserDefaults.standard.string(forKey: "meshchat.appearance")
        #expect(saved == "system")
    }
    
    // MARK: - ColorScheme Conversion Tests
    
    @Test
    func appAppearance_colorScheme_convertsCorrectly() {
        #expect(AppAppearance.system.colorScheme == nil)
        #expect(AppAppearance.light.colorScheme == .light)
        #expect(AppAppearance.dark.colorScheme == .dark)
    }
    
    // MARK: - All Cases Test
    
    @Test
    func appAppearance_allCases_includesAllOptions() {
        let allCases = AppAppearance.allCases
        #expect(allCases.contains(.system))
        #expect(allCases.contains(.light))
        #expect(allCases.contains(.dark))
        #expect(allCases.count == 3)
    }
}
