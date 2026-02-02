//
// UserProfileTests.swift
// bitchatTests
//
// Tests for UserProfile model
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import Testing
import Foundation
@testable import bitchat

struct UserProfileTests {
    
    // MARK: - Initialization Tests
    
    @Test
    func init_withAllFields_setsCorrectly() {
        let profile = UserProfile(
            displayName: "TestUser",
            email: "test@example.com",
            bio: "Test bio"
        )
        
        #expect(profile.displayName == "TestUser")
        #expect(profile.email == "test@example.com")
        #expect(profile.bio == "Test bio")
        #expect(profile.avatarColor == nil)
    }
    
    @Test
    func init_withoutOptionalFields_setsDefaults() {
        let profile = UserProfile(displayName: "TestUser")
        
        #expect(profile.displayName == "TestUser")
        #expect(profile.email == nil)
        #expect(profile.bio == nil)
        #expect(profile.avatarColor == nil)
    }
    
    // MARK: - Update Tests
    
    @Test
    func update_allFields_updatesCorrectly() {
        var profile = UserProfile(displayName: "Original")
        let originalDate = profile.createdAt
        
        Thread.sleep(forTimeInterval: 0.1)
        
        profile.update(
            displayName: "Updated",
            email: "updated@example.com",
            bio: "Updated bio"
        )
        
        #expect(profile.displayName == "Updated")
        #expect(profile.email == "updated@example.com")
        #expect(profile.bio == "Updated bio")
        #expect(profile.createdAt == originalDate)
        #expect(profile.lastUpdated > originalDate)
    }
    
    @Test
    func update_partialFields_updatesOnlySpecified() {
        var profile = UserProfile(
            displayName: "Original",
            email: "original@example.com",
            bio: "Original bio"
        )
        
        profile.update(displayName: "Updated")
        
        #expect(profile.displayName == "Updated")
        #expect(profile.email == "original@example.com")
        #expect(profile.bio == "Original bio")
    }
    
    @Test
    func update_nilValues_preservesExisting() {
        var profile = UserProfile(
            displayName: "Original",
            email: "original@example.com",
            bio: "Original bio"
        )
        
        // Updating with nil values should preserve existing values
        // (the update method only updates if non-nil is provided)
        profile.update(displayName: nil, email: nil, bio: nil)
        
        #expect(profile.displayName == "Original")
        #expect(profile.email == "original@example.com")
        #expect(profile.bio == "Original bio")
        // lastUpdated should still be updated even if no fields change
        #expect(profile.lastUpdated >= profile.createdAt)
    }
    
    // MARK: - Codable Tests
    
    @Test
    func encodeDecode_preservesAllFields() throws {
        let original = UserProfile(
            displayName: "TestUser",
            email: "test@example.com",
            bio: "Test bio"
        )
        
        // Use same encoder/decoder as ProfileManager
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(UserProfile.self, from: data)
        
        #expect(decoded.displayName == original.displayName)
        #expect(decoded.email == original.email)
        #expect(decoded.bio == original.bio)
        // Dates should be preserved (within reasonable precision)
        #expect(abs(decoded.createdAt.timeIntervalSince(original.createdAt)) < 1.0)
    }
    
    @Test
    func encodeDecode_withNilOptionalFields_preservesNil() throws {
        let original = UserProfile(displayName: "TestUser")
        
        // Use same encoder/decoder as ProfileManager
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(UserProfile.self, from: data)
        
        #expect(decoded.displayName == original.displayName)
        #expect(decoded.email == nil)
        #expect(decoded.bio == nil)
    }
}
