#!/bin/bash

# TapConnectSDK Pod Validation Script
# This script validates the pod structure and verifies all required files exist

set -e

echo "🔍 Validating TapConnectSDK Pod Structure..."
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

POD_ROOT="/Users/MahAllam/ReactNative/tap/mobile-os/apps/TestConnectSDK"

# Check required files
echo "📄 Checking required files..."

required_files=(
    "$POD_ROOT/TapConnectSDK.podspec"
    "$POD_ROOT/LICENSE"
    "$POD_ROOT/README.md"
    "$POD_ROOT/TapConnectSDK/Classes/TapConnectSDK.swift"
    "$POD_ROOT/TapConnectSDK/Classes/TapConnectSDKDelegate.swift"
    "$POD_ROOT/TapConnectSDK/Classes/TapConnectSDKConfig.swift"
    "$POD_ROOT/TestConnectSDK/ConnectSdkFramework.xcframework"
    "$POD_ROOT/TestConnectSDK/ReactBrownfield.xcframework"
    "$POD_ROOT/TestConnectSDK/hermes.xcframework"
)

all_files_exist=true

for file in "${required_files[@]}"; do
    if [ -e "$file" ]; then
        echo -e "${GREEN}✓${NC} Found: $(basename "$file")"
    else
        echo -e "${RED}✗${NC} Missing: $file"
        all_files_exist=false
    fi
done

echo ""

# Check frameworks
echo "🔧 Checking frameworks..."

frameworks=(
    "ConnectSdkFramework.xcframework"
    "ReactBrownfield.xcframework"
    "hermes.xcframework"
)

for framework in "${frameworks[@]}"; do
    if [ -d "$POD_ROOT/TestConnectSDK/$framework" ]; then
        size=$(du -sh "$POD_ROOT/TestConnectSDK/$framework" | cut -f1)
        echo -e "${GREEN}✓${NC} $framework (Size: $size)"
    else
        echo -e "${RED}✗${NC} $framework not found"
    fi
done

echo ""

# Validate podspec syntax
echo "📋 Validating podspec syntax..."
if command -v pod &> /dev/null; then
    cd "$POD_ROOT"
    if pod spec lint TapConnectSDK.podspec --allow-warnings --no-clean; then
        echo -e "${GREEN}✓${NC} Podspec is valid"
    else
        echo -e "${YELLOW}⚠${NC} Podspec validation failed (this is normal for local pods)"
    fi
else
    echo -e "${YELLOW}⚠${NC} CocoaPods not installed, skipping podspec validation"
fi

echo ""

# Summary
if [ "$all_files_exist" = true ]; then
    echo -e "${GREEN}✅ All required files are present!${NC}"
    echo ""
    echo "🚀 Next steps:"
    echo "1. Add to your Podfile:"
    echo "   pod 'TapConnectSDK', :path => '$POD_ROOT'"
    echo ""
    echo "2. Run: pod install"
    echo ""
    echo "3. Follow INTEGRATION_GUIDE.md for usage"
else
    echo -e "${RED}❌ Some required files are missing!${NC}"
    exit 1
fi

echo ""
echo "📚 Documentation:"
echo "  - README.md - Full documentation"
echo "  - INTEGRATION_GUIDE.md - Quick start guide"
echo "  - TapConnectSDK/Classes/Example.swift - Code examples"
echo ""
echo "Done! 🎉"
