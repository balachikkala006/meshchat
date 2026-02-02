//
// ProfileWorkflowTests.swift
// bitchatTests
//
// Integration tests for the complete profile workflow
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import Testing
import Foundation
@testable import bitchat

struct ProfileWorkflowTests {
    
    // MARK: - Complete Workflow Tests
    
    @Test @MainActor
    func completeWorkflow_firstLaunch_showsSetup() {
        // Clear profile to simulate first launch
        ProfileManager.shared.clearProfile()
        defer { ProfileManager.shared.clearProfile() }
        
        let hasCompleted = ProfileManager.shared.hasCompletedSetup()
        #expect(hasCompleted == false)
        
        // Simulate user completing setup
        let profile = UserProfile(
            displayName: "NewUser",
            email: "newuser@example.com",
            bio: "Hello, I'm new here!"
        )
        
        ProfileManager.shared.saveProfile(profile)
        
        #expect(ProfileManager.shared.hasCompletedSetup() == true)
        
        let loaded = ProfileManager.shared.loadProfile()
        #expect(loaded?.displayName == "NewUser")
        #expect(loaded?.email == "newuser@example.com")
    }
    
    @Test @MainActor
    func completeWorkflow_profileUpdate_updatesNickname() {
        ProfileManager.shared.clearProfile()
        defer { ProfileManager.shared.clearProfile() }
        
        // Create initial profile
        let initialProfile = UserProfile(displayName: "InitialName")
        ProfileManager.shared.saveProfile(initialProfile)
        
        // Update profile
        var updatedProfile = initialProfile
        updatedProfile.update(displayName: "UpdatedName", email: "updated@example.com")
        ProfileManager.shared.saveProfile(updatedProfile)
        
        let loaded = ProfileManager.shared.loadProfile()
        #expect(loaded?.displayName == "UpdatedName")
        #expect(loaded?.email == "updated@example.com")
        #expect(loaded?.createdAt == initialProfile.createdAt)
    }
    
    @Test @MainActor
    func completeWorkflow_themeSwitching_persistsCorrectly() {
        // Test theme switching workflow
        AppearanceManager.shared.appearance = .light
        #expect(AppearanceManager.shared.appearance == .light)
        
        AppearanceManager.shared.appearance = .dark
        #expect(AppearanceManager.shared.appearance == .dark)
        
        AppearanceManager.shared.appearance = .system
        #expect(AppearanceManager.shared.appearance == .system)
        
        // Verify persistence
        let saved = UserDefaults.standard.string(forKey: "meshchat.appearance")
        #expect(saved == "system")
    }
    
    @Test @MainActor
    func completeWorkflow_profileAndTheme_workTogether() {
        ProfileManager.shared.clearProfile()
        defer { 
            ProfileManager.shared.clearProfile()
            AppearanceManager.shared.appearance = .system
        }
        
        // Create profile
        let profile = UserProfile(displayName: "TestUser")
        ProfileManager.shared.saveProfile(profile)
        
        // Switch theme
        AppearanceManager.shared.appearance = .dark
        
        // Verify both are persisted
        #expect(ProfileManager.shared.hasCompletedSetup() == true)
        #expect(AppearanceManager.shared.appearance == .dark)
        
        let loadedProfile = ProfileManager.shared.loadProfile()
        #expect(loadedProfile?.displayName == "TestUser")
    }
    
    // MARK: - Edge Cases
    
    @Test
    func edgeCase_emptyDisplayName_handled() {
        ProfileManager.shared.clearProfile()
        defer { ProfileManager.shared.clearProfile() }
        
        // Profile with empty name should still save (validation happens in UI)
        let profile = UserProfile(displayName: "")
        ProfileManager.shared.saveProfile(profile)
        
        let loaded = ProfileManager.shared.loadProfile()
        #expect(loaded?.displayName == "")
    }
    
    @Test
    func edgeCase_longBio_handled() {
        ProfileManager.shared.clearProfile()
        defer { ProfileManager.shared.clearProfile() }
        
        let longBio = String(repeating: "A", count: 1000)
        let profile = UserProfile(
            displayName: "TestUser",
            email: nil,
            bio: longBio
        )
        
        ProfileManager.shared.saveProfile(profile)
        
        let loaded = ProfileManager.shared.loadProfile()
        #expect(loaded?.bio == longBio)
    }
    
    @Test
    func edgeCase_specialCharactersInName_handled() {
        ProfileManager.shared.clearProfile()
        defer { ProfileManager.shared.clearProfile() }
        
        let profile = UserProfile(
            displayName: "User@123 #test",
            email: "test+tag@example.com",
            bio: "Bio with emoji 🚀 and symbols @#$"
        )
        
        ProfileManager.shared.saveProfile(profile)
        
        let loaded = ProfileManager.shared.loadProfile()
        #expect(loaded?.displayName == "User@123 #test")
        #expect(loaded?.email == "test+tag@example.com")
        #expect(loaded?.bio == "Bio with emoji 🚀 and symbols @#$")
    }
}
