//
// ProfileManagerTests.swift
// bitchatTests
//
// Tests for ProfileManager
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import Testing
import Foundation
@testable import bitchat

struct ProfileManagerTests {
    
    // MARK: - Setup/Teardown
    
    func setup() {
        // Clear any existing profile before each test
        ProfileManager.shared.clearProfile()
    }
    
    func teardown() {
        // Clean up after each test
        ProfileManager.shared.clearProfile()
    }
    
    // MARK: - Profile Creation Tests
    
    @Test
    func createProfile_savesSuccessfully() {
        setup()
        defer { teardown() }
        
        let profile = UserProfile(
            displayName: "TestUser",
            email: "test@example.com",
            bio: "Test bio"
        )
        
        ProfileManager.shared.saveProfile(profile)
        
        let loaded = ProfileManager.shared.loadProfile()
        #expect(loaded != nil)
        #expect(loaded?.displayName == "TestUser")
        #expect(loaded?.email == "test@example.com")
        #expect(loaded?.bio == "Test bio")
    }
    
    @Test
    func createProfile_withoutEmail_savesSuccessfully() {
        setup()
        defer { teardown() }
        
        let profile = UserProfile(
            displayName: "TestUser",
            email: nil,
            bio: "Test bio"
        )
        
        ProfileManager.shared.saveProfile(profile)
        
        let loaded = ProfileManager.shared.loadProfile()
        #expect(loaded != nil)
        #expect(loaded?.displayName == "TestUser")
        #expect(loaded?.email == nil)
        #expect(loaded?.bio == "Test bio")
    }
    
    @Test
    func createProfile_withoutBio_savesSuccessfully() {
        setup()
        defer { teardown() }
        
        let profile = UserProfile(
            displayName: "TestUser",
            email: "test@example.com",
            bio: nil
        )
        
        ProfileManager.shared.saveProfile(profile)
        
        let loaded = ProfileManager.shared.loadProfile()
        #expect(loaded != nil)
        #expect(loaded?.displayName == "TestUser")
        #expect(loaded?.email == "test@example.com")
        #expect(loaded?.bio == nil)
    }
    
    // MARK: - Profile Update Tests
    
    @Test
    func updateProfile_preservesCreationDate() {
        setup()
        defer { teardown() }
        
        let originalProfile = UserProfile(
            displayName: "Original",
            email: "original@example.com",
            bio: "Original bio"
        )
        
        ProfileManager.shared.saveProfile(originalProfile)
        let originalLoaded = ProfileManager.shared.loadProfile()
        let originalDate = originalLoaded?.createdAt
        
        // Wait a bit to ensure different timestamps
        Thread.sleep(forTimeInterval: 0.1)
        
        var updatedProfile = originalProfile
        updatedProfile.update(displayName: "Updated", email: "updated@example.com", bio: "Updated bio")
        
        ProfileManager.shared.saveProfile(updatedProfile)
        let updatedLoaded = ProfileManager.shared.loadProfile()
        
        #expect(updatedLoaded?.displayName == "Updated")
        #expect(updatedLoaded?.email == "updated@example.com")
        #expect(updatedLoaded?.bio == "Updated bio")
        #expect(updatedLoaded?.createdAt == originalDate)
        #expect(updatedLoaded?.lastUpdated != originalDate)
    }
    
    // MARK: - Setup Completion Tests
    
    @Test
    func hasCompletedSetup_initiallyFalse() {
        setup()
        defer { teardown() }
        
        #expect(ProfileManager.shared.hasCompletedSetup() == false)
    }
    
    @Test
    func hasCompletedSetup_afterSavingProfile_true() {
        setup()
        defer { teardown() }
        
        let profile = UserProfile(displayName: "TestUser")
        ProfileManager.shared.saveProfile(profile)
        
        #expect(ProfileManager.shared.hasCompletedSetup() == true)
    }
    
    @Test
    func clearProfile_resetsSetupStatus() {
        setup()
        defer { teardown() }
        
        let profile = UserProfile(displayName: "TestUser")
        ProfileManager.shared.saveProfile(profile)
        #expect(ProfileManager.shared.hasCompletedSetup() == true)
        
        ProfileManager.shared.clearProfile()
        #expect(ProfileManager.shared.hasCompletedSetup() == false)
        #expect(ProfileManager.shared.loadProfile() == nil)
    }
    
    // MARK: - Profile Loading Tests
    
    @Test
    func loadProfile_whenNoneExists_returnsNil() {
        setup()
        defer { teardown() }
        
        let loaded = ProfileManager.shared.loadProfile()
        #expect(loaded == nil)
    }
    
    @Test
    func loadProfile_afterSaving_returnsCorrectProfile() {
        setup()
        defer { teardown() }
        
        let profile = UserProfile(
            displayName: "TestUser",
            email: "test@example.com",
            bio: "Test bio"
        )
        
        ProfileManager.shared.saveProfile(profile)
        let loaded = ProfileManager.shared.loadProfile()
        
        #expect(loaded?.displayName == "TestUser")
        #expect(loaded?.email == "test@example.com")
        #expect(loaded?.bio == "Test bio")
    }
}
