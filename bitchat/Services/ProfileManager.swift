//
// ProfileManager.swift
// meshchat
//
// Profile management service
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import Foundation

class ProfileManager {
    static let shared = ProfileManager()
    
    private let profileKey = "meshchat.userProfile"
    private let hasCompletedSetupKey = "meshchat.hasCompletedSetup"
    
    private init() {}
    
    func saveProfile(_ profile: UserProfile) {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
            UserDefaults.standard.set(true, forKey: hasCompletedSetupKey)
        }
    }
    
    func loadProfile() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: profileKey),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            return nil
        }
        return profile
    }
    
    func hasCompletedSetup() -> Bool {
        return UserDefaults.standard.bool(forKey: hasCompletedSetupKey)
    }
    
    func clearProfile() {
        UserDefaults.standard.removeObject(forKey: profileKey)
        UserDefaults.standard.removeObject(forKey: hasCompletedSetupKey)
    }
}
