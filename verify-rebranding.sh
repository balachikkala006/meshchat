#!/bin/bash
# Rebranding Verification Script
# Run this to verify all rebranding changes are complete

cd "$(dirname "$0")"

echo "============================================"
echo "REBRANDING VERIFICATION"
echo "============================================"
echo ""

# 1. Git Status
echo "=== 1. Git Status ==="
git status --short | head -20
echo ""

# 2. Check for old class names (should be 0)
echo "=== 2. Old Class Names Remaining ==="
OLD_COUNT=$(grep -r "BitchatMessage\|BitchatPeer\|BitchatPacket\|BitchatDelegate\|BitchatApp" --include="*.swift" bitchat/ 2>/dev/null | wc -l | tr -d ' ')
if [ "$OLD_COUNT" -eq 0 ]; then
    echo "✅ PASS: No old class names found ($OLD_COUNT)"
else
    echo "❌ FAIL: Found $OLD_COUNT old class name references"
    grep -r "BitchatMessage\|BitchatPeer\|BitchatPacket\|BitchatDelegate\|BitchatApp" --include="*.swift" bitchat/ 2>/dev/null | head -5
fi
echo ""

# 3. Check for new class names (should be many)
echo "=== 3. New Class Names Present ==="
NEW_COUNT=$(grep -r "MeshChatMessage\|MeshChatPeer\|MeshChatPacket\|MeshChatDelegate\|MeshChatApp" --include="*.swift" bitchat/ 2>/dev/null | wc -l | tr -d ' ')
if [ "$NEW_COUNT" -gt 0 ]; then
    echo "✅ PASS: Found $NEW_COUNT new class name references"
else
    echo "❌ FAIL: No new class names found"
fi
echo ""

# 4. Verify bundle IDs
echo "=== 4. Bundle IDs Updated ==="
if grep -q "chat.meshchat" Configs/Release.xcconfig 2>/dev/null; then
    echo "✅ PASS: Bundle IDs updated to chat.meshchat"
    grep "PRODUCT_BUNDLE_IDENTIFIER.*chat.meshchat" Configs/Release.xcconfig Configs/Local.xcconfig.example 2>/dev/null | head -2
else
    echo "❌ FAIL: Bundle IDs not properly updated"
fi
echo ""

# 5. Verify app groups
echo "=== 5. App Groups Updated ==="
if grep -q "group.chat.meshchat" bitchat/bitchat.entitlements 2>/dev/null; then
    echo "✅ PASS: App groups updated to group.chat.meshchat"
    grep "group.chat.meshchat" bitchat/bitchat.entitlements 2>/dev/null | head -1
else
    echo "❌ FAIL: App groups not properly updated"
fi
echo ""

# 6. Verify URL schemes
echo "=== 6. URL Schemes Updated ==="
if grep -A 2 "CFBundleURLSchemes" bitchat/Info.plist 2>/dev/null | grep -q "meshchat"; then
    echo "✅ PASS: URL scheme updated to meshchat"
    grep -A 2 "CFBundleURLSchemes" bitchat/Info.plist 2>/dev/null | grep meshchat
else
    echo "❌ FAIL: URL scheme not properly updated"
fi
echo ""

# 7. Verify display name
echo "=== 7. Display Name Updated ==="
if grep -q "MeshChat" bitchat/Info.plist 2>/dev/null; then
    echo "✅ PASS: Display name updated to MeshChat"
    grep "CFBundleDisplayName" bitchat/Info.plist 2>/dev/null | head -1
else
    echo "❌ FAIL: Display name not properly updated"
fi
echo ""

# 8. Summary
echo "=== 8. Summary ==="
echo "Files changed: $(git diff --name-only | wc -l | tr -d ' ')"
echo "Swift files: $(git diff --name-only | grep -E '\.swift$' | wc -l | tr -d ' ')"
echo "Config files: $(git diff --name-only | grep -E '\.(plist|xcconfig|entitlements)$' | wc -l | tr -d ' ')"
echo "Documentation: $(git diff --name-only | grep -E '\.md$' | wc -l | tr -d ' ')"
echo "Localization: $(git diff --name-only | grep -E '\.xcstrings$' | wc -l | tr -d ' ')"
echo ""
echo "Total changes: $(git diff --shortstat | awk '{print $4 "+" $6}')"
echo ""

# 9. Compilation check (optional - may require Xcode)
echo "=== 9. Compilation Check (Optional) ==="
echo "To test compilation, run:"
echo "  xcodebuild -project bitchat.xcodeproj -scheme 'bitchat (macOS)' -configuration Debug CODE_SIGNING_ALLOWED=NO clean build"
echo ""

echo "============================================"
echo "Verification complete!"
echo "============================================"
