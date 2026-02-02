//
// ThemeToggleView.swift
// meshchat
//
// Theme/appearance toggle component
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import SwiftUI

struct ThemeToggleView: View {
    @ObservedObject private var appearanceManager = AppearanceManager.shared
    @Environment(\.colorScheme) var systemColorScheme
    
    var body: some View {
        Menu {
            ForEach(AppAppearance.allCases, id: \.self) { appearance in
                Button(action: {
                    appearanceManager.appearance = appearance
                }) {
                    HStack {
                        Text(appearance.displayName)
                        if appearanceManager.appearance == appearance {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: appearanceManager.appearance.iconName)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(MeshChatDesignSystem.Colors.primaryText(systemColorScheme))
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(MeshChatDesignSystem.Colors.secondaryBackground(systemColorScheme))
                )
        }
        .buttonStyle(.plain)
    }
}

extension AppAppearance {
    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
    
    var iconName: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
}
