#!/bin/bash
# fix_xcframeworks.sh
# Run this script after generating the xcframeworks to fix module compatibility issues

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORKS_DIR="${SCRIPT_DIR}/TestConnectSDK"

echo "🔧 Fixing xcframeworks in ${FRAMEWORKS_DIR}..."

# =============================================================================
# 1. Fix ConnectSdkFramework - Add modulemap and headers
# =============================================================================
fix_connect_sdk_framework() {
    local XCFRAMEWORK="${FRAMEWORKS_DIR}/ConnectSdkFramework.xcframework"
    
    if [ ! -d "$XCFRAMEWORK" ]; then
        echo "❌ ConnectSdkFramework.xcframework not found"
        return 1
    fi
    
    echo "📦 Fixing ConnectSdkFramework.xcframework..."
    
    # Find all slices (ios-arm64, ios-arm64_x86_64-simulator, etc.)
    for SLICE_DIR in "$XCFRAMEWORK"/*/; do
        local FRAMEWORK_DIR="${SLICE_DIR}ConnectSdkFramework.framework"
        
        if [ ! -d "$FRAMEWORK_DIR" ]; then
            continue
        fi
        
        echo "  → Processing slice: $(basename "$SLICE_DIR")"
        
        # Create Headers directory if it doesn't exist
        mkdir -p "${FRAMEWORK_DIR}/Headers"
        
        # Create umbrella header with Obj-C declarations for @objc Swift types
        cat > "${FRAMEWORK_DIR}/Headers/ConnectSdkFramework.h" << 'HEADER_EOF'
#import <Foundation/Foundation.h>

//! Project version number for ConnectSdkFramework.
FOUNDATION_EXPORT double ConnectSdkFrameworkVersionNumber;

//! Project version string for ConnectSdkFramework.
FOUNDATION_EXPORT const unsigned char ConnectSdkFrameworkVersionString[];

@protocol NativeCommunicationDelegate <NSObject>
- (NSString * _Nullable)requestDataSync;
- (void)handleEventFromReactNative:(NSString * _Nonnull)data;
@end

@interface NativeCommunicationService : NSObject
@property (class, nonatomic, readonly, strong) NativeCommunicationService * _Nonnull shared;
@property (nonatomic, weak, nullable) id<NativeCommunicationDelegate> delegate;
- (NSString * _Nullable)requestDataSync;
- (void)handleEventFromReactNative:(NSString * _Nonnull)data;
- (void)sendEventToReactNative:(NSDictionary<NSString *, id> * _Nonnull)eventData;
- (void)sendEventWithType:(NSString * _Nonnull)type payload:(NSDictionary<NSString *, id> * _Nullable)payload;
@end
HEADER_EOF
        
        # Create Modules directory if it doesn't exist
        mkdir -p "${FRAMEWORK_DIR}/Modules"
        
        # Create module.modulemap
        cat > "${FRAMEWORK_DIR}/Modules/module.modulemap" << 'MODULEMAP_EOF'
framework module ConnectSdkFramework {
  umbrella header "ConnectSdkFramework.h"
  export *
  module * { export * }
}
MODULEMAP_EOF
        
        echo "    ✓ Added Headers and modulemap"
    done
}

# =============================================================================
# 2. Fix hermes.xcframework - Rename to hermesvm.xcframework
# =============================================================================
fix_hermes_framework() {
    local HERMES_XCFRAMEWORK="${FRAMEWORKS_DIR}/hermes.xcframework"
    local HERMESVM_XCFRAMEWORK="${FRAMEWORKS_DIR}/hermesvm.xcframework"
    
    if [ -d "$HERMESVM_XCFRAMEWORK" ]; then
        echo "📦 hermesvm.xcframework already exists, skipping rename"
        return 0
    fi
    
    if [ ! -d "$HERMES_XCFRAMEWORK" ]; then
        echo "⚠️  hermes.xcframework not found (might already be renamed)"
        return 0
    fi
    
    echo "📦 Renaming hermes.xcframework to hermesvm.xcframework..."
    mv "$HERMES_XCFRAMEWORK" "$HERMESVM_XCFRAMEWORK"
    echo "    ✓ Renamed successfully"
}

# =============================================================================
# Main
# =============================================================================
echo ""
fix_connect_sdk_framework
echo ""
fix_hermes_framework
echo ""
echo "✅ XCFrameworks fixed successfully!"
echo ""
echo "Next steps:"
echo "  1. Run 'pod install' in your consuming project"
echo "  2. Build your project"
