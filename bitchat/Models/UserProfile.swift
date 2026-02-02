//
// UserProfile.swift
// meshchat
//
// User profile model for MeshChat
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import Foundation

/// User profile information (stored locally, optional)
struct UserProfile: Codable {
    var displayName: String
    var email: String?
    var bio: String?
    var avatarColor: String? // Hex color for avatar generation
    var createdAt: Date
    var lastUpdated: Date
    
    init(displayName: String, email: String? = nil, bio: String? = nil) {
        self.displayName = displayName
        self.email = email
        self.bio = bio
        self.avatarColor = nil
        self.createdAt = Date()
        self.lastUpdated = Date()
    }
    
    mutating func update(displayName: String? = nil, email: String? = nil, bio: String? = nil) {
        if let displayName = displayName {
            self.displayName = displayName
        }
        if let email = email {
            self.email = email
        }
        if let bio = bio {
            self.bio = bio
        }
        self.lastUpdated = Date()
    }
}
