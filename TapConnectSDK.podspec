Pod::Spec.new do |s|
  s.name             = 'TapConnectSDK'
  s.version          = '1.0.0'
  s.summary          = 'Tap Connect SDK for iOS - React Native based financial account connection'
  s.description      = <<-DESC
                       TapConnectSDK provides a seamless way to integrate Tap Connect functionality into your iOS application.
                       It wraps a React Native implementation with a simple Swift API.
                       DESC
  s.homepage         = 'https://github.com/yourusername/TapConnectSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tap Payments' => 'developer@tap.company' }
  s.source           = { :git => 'https://github.com/yourusername/TapConnectSDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.platform = :ios, '13.0'

  # Source files
  s.source_files = 'TapConnectSDK/Classes/**/*.{swift,h,m}'
  
  # Vendored frameworks
  s.vendored_frameworks = [
    'TestConnectSDK/ConnectSdkFramework.xcframework',
    'TestConnectSDK/ReactBrownfield.xcframework',
    'TestConnectSDK/hermesvm.xcframework'
  ]
  
  # Preserve paths for framework bundles
  s.preserve_paths = [
    'TestConnectSDK/**/*',
    'TapConnectSDK/**/*'
  ]
  
  # System frameworks
  s.frameworks = 'UIKit', 'Foundation'

  # Pod configuration
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_XCFRAMEWORKS_BUILD_DIR)/TapConnectSDK',
    'OTHER_LDFLAGS' => '$(inherited) -framework ConnectSdkFramework -framework hermesvm',
    'SWIFT_SUPPRESS_WARNINGS' => 'NO',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'
  }
  
  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_XCFRAMEWORKS_BUILD_DIR)/TapConnectSDK',
    'OTHER_LDFLAGS' => '$(inherited) -framework ConnectSdkFramework -framework hermesvm',
    'ENABLE_USER_SCRIPT_SANDBOXING' => 'NO'
  }
  
  s.requires_arc = true
end
