//
// ProfileSetupView.swift
// meshchat
//
// Modern profile setup screen for MeshChat
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import SwiftUI

struct ProfileSetupView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ChatViewModel
    
    @State private var displayName: String = ""
    @State private var email: String = ""
    @State private var bio: String = ""
    @State private var isEmailValid: Bool = true
    @FocusState private var focusedField: Field?
    
    enum Field {
        case displayName, email, bio
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: MeshChatDesignSystem.Spacing.xl) {
                    // Header
                    VStack(spacing: MeshChatDesignSystem.Spacing.md) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(MeshChatDesignSystem.Colors.primary)
                            .padding(.top, MeshChatDesignSystem.Spacing.xxl)
                        
                        Text("Create Your Profile")
                            .font(MeshChatDesignSystem.Typography.title1)
                            .foregroundColor(MeshChatDesignSystem.Colors.primaryText(colorScheme))
                        
                        Text("Set up your MeshChat profile to get started")
                            .font(MeshChatDesignSystem.Typography.body)
                            .foregroundColor(MeshChatDesignSystem.Colors.secondaryText(colorScheme))
                            .multilineTextAlignment(.center)
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
                        }
                        
                        // Email (Optional)
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
                        
                        // Bio (Optional)
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
                        }
                    }
                    .padding(.horizontal, MeshChatDesignSystem.Spacing.xl)
                    
                    // Continue Button
                    Button(action: {
                        saveProfile()
                    }) {
                        HStack {
                            Text("Continue")
                                .font(MeshChatDesignSystem.Typography.button)
                                .foregroundColor(.white)
                            
                            Image(systemName: "arrow.right")
                                .font(MeshChatDesignSystem.Typography.button)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, MeshChatDesignSystem.Spacing.md)
                        .background(
                            displayName.isEmpty ? 
                            MeshChatDesignSystem.Colors.primary.opacity(0.5) :
                            MeshChatDesignSystem.Colors.primary
                        )
                        .cornerRadius(MeshChatDesignSystem.CornerRadius.medium)
                    }
                    .disabled(displayName.isEmpty || !isEmailValid)
                    .padding(.horizontal, MeshChatDesignSystem.Spacing.xl)
                    .padding(.top, MeshChatDesignSystem.Spacing.md)
                    
                    // Privacy Note
                    HStack(spacing: MeshChatDesignSystem.Spacing.sm) {
                        Image(systemName: "lock.shield")
                            .font(.system(size: 14))
                            .foregroundColor(MeshChatDesignSystem.Colors.secondaryText(colorScheme))
                        
                        Text("Your profile is stored locally and never shared")
                            .font(MeshChatDesignSystem.Typography.smallCaption)
                            .foregroundColor(MeshChatDesignSystem.Colors.secondaryText(colorScheme))
                    }
                    .padding(.horizontal, MeshChatDesignSystem.Spacing.xl)
                    .padding(.bottom, MeshChatDesignSystem.Spacing.xl)
                }
            }
            .background(MeshChatDesignSystem.Colors.background(colorScheme))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") {
                        dismiss()
                    }
                    .foregroundColor(MeshChatDesignSystem.Colors.primary)
                }
            }
        }
        .onAppear {
            // Pre-fill with existing nickname if available
            if !viewModel.nickname.isEmpty {
                displayName = viewModel.nickname
            }
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
        
        // Save profile (you'll need to implement profile storage)
        let profile = UserProfile(
            displayName: displayName,
            email: email.isEmpty ? nil : email,
            bio: bio.isEmpty ? nil : bio
        )
        
        // Save profile
        ProfileManager.shared.saveProfile(profile)
        
        dismiss()
    }
}

#Preview {
    ProfileSetupView()
        .environmentObject(ChatViewModel(
            keychain: PreviewKeychainManager(),
            idBridge: NostrIdentityBridge(),
            identityManager: SecureIdentityStateManager(PreviewKeychainManager())
        ))
}
