//
// ProfileSettingsView.swift
// meshchat
//
// Profile settings and management view
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import SwiftUI

struct ProfileSettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ChatViewModel
    
    @State private var displayName: String = ""
    @State private var email: String = ""
    @State private var bio: String = ""
    @State private var isEmailValid: Bool = true
    @State private var hasChanges: Bool = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case displayName, email, bio
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: MeshChatDesignSystem.Spacing.xl) {
                    // Profile Header
                    VStack(spacing: MeshChatDesignSystem.Spacing.md) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [MeshChatDesignSystem.Colors.primary, MeshChatDesignSystem.Colors.accent],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                            
                            Text(displayName.prefix(1).uppercased())
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.top, MeshChatDesignSystem.Spacing.lg)
                        
                        Text("Edit Profile")
                            .font(MeshChatDesignSystem.Typography.title2)
                            .foregroundColor(MeshChatDesignSystem.Colors.primaryText(colorScheme))
                    }
                    .padding(.horizontal, MeshChatDesignSystem.Spacing.xl)
                    
                    // Form
                    VStack(spacing: MeshChatDesignSystem.Spacing.lg) {
                        // Display Name
                        VStack(alignment: .leading, spacing: MeshChatDesignSystem.Spacing.sm) {
                            Text("Display Name")
                                .font(MeshChatDesignSystem.Typography.captionBold)
                                .foregroundColor(MeshChatDesignSystem.Colors.primaryText(colorScheme))
                            
                            TextField("Enter your name", text: $displayName)
                                .textFieldStyle(.plain)
                                .font(MeshChatDesignSystem.Typography.body)
                                .padding(MeshChatDesignSystem.Spacing.md)
                                .background(MeshChatDesignSystem.Colors.inputBackground(colorScheme))
                                .cornerRadius(MeshChatDesignSystem.CornerRadius.medium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: MeshChatDesignSystem.CornerRadius.medium)
                                        .stroke(focusedField == .displayName ? MeshChatDesignSystem.Colors.primary : MeshChatDesignSystem.Colors.inputBorder(colorScheme), lineWidth: focusedField == .displayName ? 2 : 1)
                                )
                                .focused($focusedField, equals: .displayName)
                                .onChange(of: displayName) { _ in hasChanges = true }
                        }
                        
                        // Email
                        VStack(alignment: .leading, spacing: MeshChatDesignSystem.Spacing.sm) {
                            HStack {
                                Text("Email")
                                    .font(MeshChatDesignSystem.Typography.captionBold)
                                    .foregroundColor(MeshChatDesignSystem.Colors.primaryText(colorScheme))
                                
                                Text("(Optional)")
                                    .font(MeshChatDesignSystem.Typography.smallCaption)
                                    .foregroundColor(MeshChatDesignSystem.Colors.tertiaryText(colorScheme))
                            }
                            
                            TextField("your@email.com", text: $email)
                                .textFieldStyle(.plain)
                                .font(MeshChatDesignSystem.Typography.body)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .autocorrectionDisabled(true)
                                .padding(MeshChatDesignSystem.Spacing.md)
                                .background(MeshChatDesignSystem.Colors.inputBackground(colorScheme))
                                .cornerRadius(MeshChatDesignSystem.CornerRadius.medium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: MeshChatDesignSystem.CornerRadius.medium)
                                        .stroke(
                                            !isEmailValid ? MeshChatDesignSystem.Colors.error : 
                                            (focusedField == .email ? MeshChatDesignSystem.Colors.primary : MeshChatDesignSystem.Colors.inputBorder(colorScheme)),
                                            lineWidth: focusedField == .email || !isEmailValid ? 2 : 1
                                        )
                                )
                                .focused($focusedField, equals: .email)
                                .onChange(of: email) { newValue in
                                    hasChanges = true
                                    if !newValue.isEmpty {
                                        isEmailValid = isValidEmail(newValue)
                                    } else {
                                        isEmailValid = true
                                    }
                                }
                            
                            if !isEmailValid && !email.isEmpty {
                                Text("Please enter a valid email address")
                                    .font(MeshChatDesignSystem.Typography.smallCaption)
                                    .foregroundColor(MeshChatDesignSystem.Colors.error)
                            }
                        }
                        
                        // Bio
                        VStack(alignment: .leading, spacing: MeshChatDesignSystem.Spacing.sm) {
                            HStack {
                                Text("Bio")
                                    .font(MeshChatDesignSystem.Typography.captionBold)
                                    .foregroundColor(MeshChatDesignSystem.Colors.primaryText(colorScheme))
                                
                                Text("(Optional)")
                                    .font(MeshChatDesignSystem.Typography.smallCaption)
                                    .foregroundColor(MeshChatDesignSystem.Colors.tertiaryText(colorScheme))
                            }
                            
                            TextEditor(text: $bio)
                                .font(MeshChatDesignSystem.Typography.body)
                                .frame(minHeight: 100)
                                .padding(MeshChatDesignSystem.Spacing.sm)
                                .background(MeshChatDesignSystem.Colors.inputBackground(colorScheme))
                                .cornerRadius(MeshChatDesignSystem.CornerRadius.medium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: MeshChatDesignSystem.CornerRadius.medium)
                                        .stroke(focusedField == .bio ? MeshChatDesignSystem.Colors.primary : MeshChatDesignSystem.Colors.inputBorder(colorScheme), lineWidth: focusedField == .bio ? 2 : 1)
                                )
                                .focused($focusedField, equals: .bio)
                                .onChange(of: bio) { _ in hasChanges = true }
                        }
                    }
                    .padding(.horizontal, MeshChatDesignSystem.Spacing.xl)
                    
                    // Save Button
                    if hasChanges {
                        Button(action: {
                            saveProfile()
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Save Changes")
                                    .font(MeshChatDesignSystem.Typography.button)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, MeshChatDesignSystem.Spacing.md)
                            .background(
                                displayName.isEmpty || !isEmailValid ? 
                                MeshChatDesignSystem.Colors.primary.opacity(0.5) :
                                MeshChatDesignSystem.Colors.primary
                            )
                            .cornerRadius(MeshChatDesignSystem.CornerRadius.medium)
                        }
                        .disabled(displayName.isEmpty || !isEmailValid)
                        .padding(.horizontal, MeshChatDesignSystem.Spacing.xl)
                        .padding(.top, MeshChatDesignSystem.Spacing.md)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .background(MeshChatDesignSystem.Colors.background(colorScheme))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(MeshChatDesignSystem.Colors.primaryText(colorScheme))
                }
            }
        }
        .onAppear {
            loadProfile()
        }
    }
    
    private func loadProfile() {
        if let profile = ProfileManager.shared.loadProfile() {
            displayName = profile.displayName
            email = profile.email ?? ""
            bio = profile.bio ?? ""
        } else {
            // Fallback to nickname
            displayName = viewModel.nickname
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func saveProfile() {
        // Update nickname in view model
        if !displayName.isEmpty {
            viewModel.nickname = displayName
            viewModel.validateAndSaveNickname()
        }
        
        // Save profile
        var profile = UserProfile(
            displayName: displayName,
            email: email.isEmpty ? nil : email,
            bio: bio.isEmpty ? nil : bio
        )
        
        // Preserve creation date if updating existing profile
        if let existing = ProfileManager.shared.loadProfile() {
            profile.createdAt = existing.createdAt
        }
        
        ProfileManager.shared.saveProfile(profile)
        hasChanges = false
        dismiss()
    }
}

#Preview {
    ProfileSettingsView()
        .environmentObject(ChatViewModel(
            keychain: PreviewKeychainManager(),
            idBridge: NostrIdentityBridge(),
            identityManager: SecureIdentityStateManager(PreviewKeychainManager())
        ))
}
