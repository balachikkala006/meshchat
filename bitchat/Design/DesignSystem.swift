//
// DesignSystem.swift
// meshchat
//
// Modern design system for MeshChat
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import SwiftUI

// MARK: - Design System

/// Modern design system for MeshChat
struct MeshChatDesignSystem {
    
    // MARK: - Colors
    
    struct Colors {
        // Primary brand colors
        static let primary = Color(red: 0.2, green: 0.6, blue: 1.0) // Modern blue
        static let primaryDark = Color(red: 0.3, green: 0.7, blue: 1.0)
        static let primaryLight = Color(red: 0.15, green: 0.5, blue: 0.95)
        
        // Accent colors
        static let accent = Color(red: 0.5, green: 0.3, blue: 1.0) // Purple accent
        static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
        static let warning = Color(red: 1.0, green: 0.7, blue: 0.2)
        static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
        
        // Background colors
        static func background(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark 
                ? Color(red: 0.05, green: 0.05, blue: 0.08) // Deep dark blue-gray
                : Color(red: 0.98, green: 0.98, blue: 1.0) // Off-white with slight blue tint
        }
        
        static func secondaryBackground(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark
                ? Color(red: 0.1, green: 0.1, blue: 0.15)
                : Color.white
        }
        
        static func tertiaryBackground(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark
                ? Color(red: 0.15, green: 0.15, blue: 0.2)
                : Color(red: 0.95, green: 0.95, blue: 0.97)
        }
        
        // Text colors
        static func primaryText(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark
                ? Color(red: 0.95, green: 0.95, blue: 0.97)
                : Color(red: 0.1, green: 0.1, blue: 0.15)
        }
        
        static func secondaryText(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark
                ? Color(red: 0.7, green: 0.7, blue: 0.75)
                : Color(red: 0.4, green: 0.4, blue: 0.5)
        }
        
        static func tertiaryText(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark
                ? Color(red: 0.5, green: 0.5, blue: 0.55)
                : Color(red: 0.6, green: 0.6, blue: 0.65)
        }
        
        // Message bubble colors
        static func messageBubbleSelf(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark
                ? Color(red: 0.2, green: 0.5, blue: 1.0) // Bright blue for self
                : Color(red: 0.2, green: 0.6, blue: 1.0)
        }
        
        static func messageBubbleOther(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark
                ? Color(red: 0.2, green: 0.2, blue: 0.25) // Dark gray for others
                : Color(red: 0.95, green: 0.95, blue: 0.97)
        }
        
        // Border colors
        static func border(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark
                ? Color(red: 0.2, green: 0.2, blue: 0.25)
                : Color(red: 0.85, green: 0.85, blue: 0.9)
        }
        
        // Input field colors
        static func inputBackground(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark
                ? Color(red: 0.15, green: 0.15, blue: 0.2)
                : Color.white
        }
        
        static func inputBorder(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark
                ? Color(red: 0.25, green: 0.25, blue: 0.3)
                : Color(red: 0.9, green: 0.9, blue: 0.95)
        }
    }
    
    // MARK: - Typography
    
    struct Typography {
        // Headers
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
        
        // Body text
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let bodyBold = Font.system(size: 17, weight: .semibold, design: .default)
        static let bodyMonospaced = Font.system(size: 17, weight: .regular, design: .monospaced)
        
        // Message text
        static let messageText = Font.system(size: 16, weight: .regular, design: .default)
        static let messageTextBold = Font.system(size: 16, weight: .semibold, design: .default)
        static let messageSender = Font.system(size: 14, weight: .semibold, design: .rounded)
        static let messageTimestamp = Font.system(size: 12, weight: .regular, design: .monospaced)
        
        // UI elements
        static let button = Font.system(size: 16, weight: .semibold, design: .rounded)
        static let caption = Font.system(size: 14, weight: .regular, design: .default)
        static let captionBold = Font.system(size: 14, weight: .semibold, design: .default)
        static let smallCaption = Font.system(size: 12, weight: .regular, design: .default)
        
        // Code/technical (monospaced)
        static let code = Font.system(size: 14, weight: .regular, design: .monospaced)
        static let codeSmall = Font.system(size: 12, weight: .regular, design: .monospaced)
    }
    
    // MARK: - Spacing
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 20
        static let messageBubble: CGFloat = 18
    }
    
    // MARK: - Shadows
    
    struct Shadow {
        static func small(_ colorScheme: ColorScheme) -> (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
            colorScheme == .dark
                ? (Color.black.opacity(0.5), 4, 0, 2)
                : (Color.black.opacity(0.1), 4, 0, 2)
        }
        
        static func medium(_ colorScheme: ColorScheme) -> (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
            colorScheme == .dark
                ? (Color.black.opacity(0.6), 8, 0, 4)
                : (Color.black.opacity(0.15), 8, 0, 4)
        }
    }
}

// MARK: - View Modifiers

extension View {
    /// Applies modern card styling
    func modernCard(_ colorScheme: ColorScheme) -> some View {
        self
            .background(MeshChatDesignSystem.Colors.secondaryBackground(colorScheme))
            .cornerRadius(MeshChatDesignSystem.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: MeshChatDesignSystem.CornerRadius.medium)
                    .stroke(MeshChatDesignSystem.Colors.border(colorScheme), lineWidth: 1)
            )
    }
    
    /// Applies modern button styling
    func modernButton(_ colorScheme: ColorScheme, isPrimary: Bool = true) -> some View {
        self
            .font(MeshChatDesignSystem.Typography.button)
            .foregroundColor(isPrimary ? .white : MeshChatDesignSystem.Colors.primaryText(colorScheme))
            .padding(.horizontal, MeshChatDesignSystem.Spacing.lg)
            .padding(.vertical, MeshChatDesignSystem.Spacing.md)
            .background(isPrimary ? MeshChatDesignSystem.Colors.primary : MeshChatDesignSystem.Colors.secondaryBackground(colorScheme))
            .cornerRadius(MeshChatDesignSystem.CornerRadius.medium)
    }
}
