# TapConnectSDK - Quick Integration Guide

## 📦 What You Get

Your CocoaPod includes:

- **TapConnectSDK.swift** - Main SDK interface
- **TapConnectSDKDelegate.swift** - Delegate protocol for callbacks
- **TapConnectSDKConfig.swift** - Configuration model
- **3 Frameworks**: ConnectSdkFramework, ReactBrownfield, hermes

## 🚀 3-Step Integration

### Step 1: Install the Pod

Add to your `Podfile`:

```ruby
pod 'TapConnectSDK', :path => 'path/to/TapConnectSDK'
```

Run:

```bash
pod install
```

### Step 2: Setup in AppDelegate

```swift
import TapConnectSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Add this single line
        TapConnectSDK.setup(launchOptions: launchOptions)
        return true
    }
}
```

### Step 3: Use in Your ViewController

```swift
import TapConnectSDK

class MyViewController: UIViewController, TapConnectSDKDelegate {

    func showConnect() {
        let config = TapConnectSDKConfig(
            language: .english,
            theme: .light
        )

        TapConnectSDK.shared.present(
            from: self,
            config: config,
            delegate: self
        )
    }

    // Handle callbacks
    func tapConnectDidComplete(authId: String, bi: String) {
        print("Success: \(authId)")
    }

    func tapConnectDidError(message: String) {
        print("Error: \(message)")
    }

    func tapConnectDidNotFindAccount() {
        print("No account found")
    }

    func tapConnectDidClose() {
        print("User closed")
    }
}
```

## ✅ That's It!

You now have a fully functional Tap Connect integration.

## 🎨 Customization Options

### Language

```swift
let config = TapConnectSDKConfig(language: .arabic)  // or .english
```

### Theme

```swift
let config = TapConnectSDKConfig(theme: .dark)  // or .light
```

### With Authentication Token

```swift
let config = TapConnectSDKConfig(
    language: .english,
    theme: .light,
    token: "your_auth_token"
)
```

### With Additional Parameters

```swift
let config = TapConnectSDKConfig(
    language: .english,
    theme: .light,
    token: "token",
    additionalParams: [
        "userId": "12345",
        "customField": "value"
    ]
)
```

## 🔧 Troubleshooting

### Issue: "Module 'TapConnectSDK' not found"

**Solution**: Clean build folder (⌘⇧K) and rebuild

### Issue: "Failed to load ConnectSdkFramework bundle"

**Solution**: Make sure you called `TapConnectSDK.setup()` in AppDelegate

### Issue: Frameworks not found at runtime

**Solution**:

1. Go to your target settings
2. Navigate to "Frameworks, Libraries, and Embedded Content"
3. Set all three frameworks to "Embed & Sign"

## 📚 Need More Help?

- See `README.md` for full documentation
- Check `Example.swift` for code samples
- Contact: developer@tap.company

## 🎯 Key Points to Remember

1. ✅ Always call `TapConnectSDK.setup()` in AppDelegate
2. ✅ Implement all 4 delegate methods
3. ✅ Pass your ViewController when calling `present()`
4. ✅ Configure language and theme as needed
5. ✅ Handle all callback scenarios appropriately

## 📱 Minimum Requirements

- iOS 13.0+
- Swift 5.0+
- Xcode 12.0+

---

**Happy Coding! 🎉**
