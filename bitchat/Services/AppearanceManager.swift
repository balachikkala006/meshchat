//
// AppearanceManager.swift
// meshchat
//
// Appearance/theme management service
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

enum AppAppearance: String, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

class AppearanceManager: ObservableObject {
    static let shared = AppearanceManager()
    
    @Published var appearance: AppAppearance {
        didSet {
            UserDefaults.standard.set(appearance.rawValue, forKey: "meshchat.appearance")
            applyAppearance()
        }
    }
    
    private init() {
        let saved = UserDefaults.standard.string(forKey: "meshchat.appearance") ?? "system"
        self.appearance = AppAppearance(rawValue: saved) ?? .system
        applyAppearance()
    }
    
    private func applyAppearance() {
        #if os(iOS)
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    switch self.appearance {
                    case .system:
                        window.overrideUserInterfaceStyle = .unspecified
                    case .light:
                        window.overrideUserInterfaceStyle = .light
                    case .dark:
                        window.overrideUserInterfaceStyle = .dark
                    }
                }
            }
        }
        #elseif os(macOS)
        DispatchQueue.main.async {
            NSApplication.shared.windows.forEach { window in
                switch self.appearance {
                case .system:
                    window.appearance = nil
                case .light:
                    window.appearance = NSAppearance(named: .aqua)
                case .dark:
                    window.appearance = NSAppearance(named: .darkAqua)
                }
            }
        }
        #endif
    }
}
