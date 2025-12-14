# TapConnectSDK

TapConnectSDK is an iOS SDK that provides seamless integration with Tap Connect for financial account connection. Built on React Native, it offers a native Swift API for easy integration into any iOS application.

## Features

- ✅ Simple Swift API
- ✅ Delegate-based callbacks
- ✅ Multi-language support (English, Arabic)
- ✅ Theme support (Light, Dark)
- ✅ Embedded React Native frameworks
- ✅ No external dependencies required

## Requirements

- iOS 13.0+
- Swift 5.0+
- Xcode 12.0+

## Installation

### CocoaPods

Add the following to your `Podfile`:

```ruby
pod 'TapConnectSDK', :path => 'path/to/TapConnectSDK'
```

Then run:

```bash
pod install
```

### Manual Installation

1. Copy the `TapConnectSDK` folder to your project
2. Drag and drop the three frameworks into your Xcode project:
   - `ConnectSdkFramework.xcframework`
   - `ReactBrownfield.xcframework`
   - `hermes.xcframework`
3. Add the SDK source files from `TapConnectSDK/Classes/` to your project

## Usage

### 1. Setup in AppDelegate

First, initialize the SDK in your `AppDelegate`:

```swift
import UIKit
import TapConnectSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initialize TapConnectSDK
        TapConnectSDK.setup(launchOptions: launchOptions)
        
        return true
    }
}
```

### 2. Implement the Delegate

Implement `TapConnectSDKDelegate` in your view controller:

```swift
import UIKit
import TapConnectSDK

class ViewController: UIViewController {
    
    @IBAction func openConnectTapped(_ sender: UIButton) {
        // Configure SDK
        let config = TapConnectSDKConfig(
            language: .english,
            theme: .light,
            token: "your_optional_token"
        )
        
        // Present SDK
        TapConnectSDK.shared.present(
            from: self,
            config: config,
            delegate: self
        )
    }
}

// MARK: - TapConnectSDKDelegate

extension ViewController: TapConnectSDKDelegate {
    
    func tapConnectDidComplete(authId: String, bi: String) {
        print("✅ Connection completed!")
        print("Auth ID: \(authId)")
        print("BI: \(bi)")
        
        // Handle successful connection
        // Navigate to next screen, save data, etc.
    }
    
    func tapConnectDidError(message: String) {
        print("❌ Error: \(message)")
        
        // Show error alert to user
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tapConnectDidNotFindAccount() {
        print("⚠️ No account found")
        
        // Handle no account scenario
        // Show onboarding, registration, etc.
    }
    
    func tapConnectDidClose() {
        print("🚪 User closed Connect")
        
        // Handle user dismissal
    }
}
```

### 3. Configuration Options

#### Language

```swift
let config = TapConnectSDKConfig(language: .english)  // or .arabic
```

#### Theme

```swift
let config = TapConnectSDKConfig(theme: .light)  // or .dark
```

#### With Token

```swift
let config = TapConnectSDKConfig(
    language: .arabic,
    theme: .dark,
    token: "user_auth_token_here"
)
```

#### With Additional Parameters

```swift
let config = TapConnectSDKConfig(
    language: .english,
    theme: .light,
    token: "token",
    additionalParams: [
        "customKey": "customValue",
        "userId": 12345
    ]
)
```

### 4. Programmatic Dismissal

You can dismiss the SDK programmatically if needed:

```swift
TapConnectSDK.shared.dismiss(animated: true)
```

## API Reference

### TapConnectSDK

#### Static Methods

- `setup(launchOptions:)` - Initialize the SDK (call in AppDelegate)
- `shared` - Singleton instance

#### Instance Methods

- `present(from:config:delegate:)` - Present the Connect UI
- `dismiss(animated:)` - Dismiss the Connect UI programmatically

### TapConnectSDKConfig

Configuration object for SDK initialization.

**Properties:**
- `language: TapConnectLanguage` - UI language (.english or .arabic)
- `theme: TapConnectTheme` - UI theme (.light or .dark)
- `token: String?` - Optional authentication token
- `additionalParams: [String: Any]?` - Additional configuration parameters

### TapConnectSDKDelegate

Protocol for receiving callbacks from the SDK.

**Methods:**
- `tapConnectDidComplete(authId:bi:)` - Called on successful completion
- `tapConnectDidError(message:)` - Called when an error occurs
- `tapConnectDidNotFindAccount()` - Called when no account is found
- `tapConnectDidClose()` - Called when user closes the UI

## Architecture

The SDK includes three main frameworks:

1. **ConnectSdkFramework.xcframework** - Core React Native bundle with Connect UI
2. **ReactBrownfield.xcframework** - React Native brownfield integration layer
3. **hermes.xcframework** - Hermes JavaScript engine for React Native

## Example Project

See the `TestConnectSDK` Xcode project for a complete working example.

## Troubleshooting

### Framework Not Found

Make sure all three frameworks are properly embedded in your app:
1. Select your target in Xcode
2. Go to "Frameworks, Libraries, and Embedded Content"
3. Ensure all three frameworks are set to "Embed & Sign"

### Bundle Not Loaded

If you see "Failed to load ConnectSdkFramework bundle", ensure:
- The framework bundle identifier is `tap.ConnectSdkFramework`
- The framework is properly copied to your app bundle
- You called `TapConnectSDK.setup()` in AppDelegate

### Module Not Found

Clean and rebuild your project:
```bash
# Clean build folder
cmd + shift + K

# Or via terminal
xcodebuild clean -workspace YourApp.xcworkspace -scheme YourScheme
```

## License

MIT License - See LICENSE file for details

## Support

For issues or questions, contact: developer@tap.company
