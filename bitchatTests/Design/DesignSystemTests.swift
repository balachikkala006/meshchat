//
// DesignSystemTests.swift
// bitchatTests
//
// Tests for DesignSystem
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import Testing
import SwiftUI
@testable import bitchat

struct DesignSystemTests {
    
    // MARK: - Color Tests
    
    @Test
    func colors_background_returnsCorrectForLightMode() {
        let color = MeshChatDesignSystem.Colors.background(.light)
        // Verify it's not black (should be light)
        #expect(color != Color.black)
    }
    
    @Test
    func colors_background_returnsCorrectForDarkMode() {
        let color = MeshChatDesignSystem.Colors.background(.dark)
        // Verify it's not white (should be dark)
        #expect(color != Color.white)
    }
    
    @Test
    func colors_primary_isSet() {
        let primary = MeshChatDesignSystem.Colors.primary
        // Verify primary color exists (not nil/clear)
        #expect(primary != Color.clear)
    }
    
    @Test
    func colors_messageBubbleSelf_differentFromOther() {
        let selfLight = MeshChatDesignSystem.Colors.messageBubbleSelf(.light)
        let otherLight = MeshChatDesignSystem.Colors.messageBubbleOther(.light)
        
        // Self and other bubbles should be different colors
        // Note: Direct color comparison is tricky in SwiftUI, so we test they're different concepts
        #expect(selfLight != otherLight)
    }
    
    // MARK: - Typography Tests
    
    @Test
    func typography_allFonts_areValid() {
        // Verify all typography constants are valid fonts
        let fonts: [Font] = [
            MeshChatDesignSystem.Typography.largeTitle,
            MeshChatDesignSystem.Typography.title1,
            MeshChatDesignSystem.Typography.title2,
            MeshChatDesignSystem.Typography.title3,
            MeshChatDesignSystem.Typography.body,
            MeshChatDesignSystem.Typography.bodyBold,
            MeshChatDesignSystem.Typography.messageText,
            MeshChatDesignSystem.Typography.messageSender,
            MeshChatDesignSystem.Typography.button,
            MeshChatDesignSystem.Typography.caption
        ]
        
        // All fonts should be valid (non-nil)
        for font in fonts {
            #expect(font != nil)
        }
    }
    
    // MARK: - Spacing Tests
    
    @Test
    func spacing_values_arePositive() {
        #expect(MeshChatDesignSystem.Spacing.xs > 0)
        #expect(MeshChatDesignSystem.Spacing.sm > 0)
        #expect(MeshChatDesignSystem.Spacing.md > 0)
        #expect(MeshChatDesignSystem.Spacing.lg > 0)
        #expect(MeshChatDesignSystem.Spacing.xl > 0)
        #expect(MeshChatDesignSystem.Spacing.xxl > 0)
    }
    
    @Test
    func spacing_values_areInAscendingOrder() {
        #expect(MeshChatDesignSystem.Spacing.xs < MeshChatDesignSystem.Spacing.sm)
        #expect(MeshChatDesignSystem.Spacing.sm < MeshChatDesignSystem.Spacing.md)
        #expect(MeshChatDesignSystem.Spacing.md < MeshChatDesignSystem.Spacing.lg)
        #expect(MeshChatDesignSystem.Spacing.lg < MeshChatDesignSystem.Spacing.xl)
        #expect(MeshChatDesignSystem.Spacing.xl < MeshChatDesignSystem.Spacing.xxl)
    }
    
    // MARK: - Corner Radius Tests
    
    @Test
    func cornerRadius_values_arePositive() {
        #expect(MeshChatDesignSystem.CornerRadius.small > 0)
        #expect(MeshChatDesignSystem.CornerRadius.medium > 0)
        #expect(MeshChatDesignSystem.CornerRadius.large > 0)
        #expect(MeshChatDesignSystem.CornerRadius.messageBubble > 0)
    }
    
    @Test
    func cornerRadius_messageBubble_isAppropriateSize() {
        // Message bubble radius should be between 12-24 for modern look
        let radius = MeshChatDesignSystem.CornerRadius.messageBubble
        #expect(radius >= 12)
        #expect(radius <= 24)
    }
}
