//
//  TapConnectSDK.swift
//  TapConnectSDK
//
//  Main SDK class for TapConnect integration
//

import UIKit
import ReactBrownfield
import ConnectSdkFramework

// MARK: - Event Models (Internal)

internal enum ConnectEventType: String {
    case onComplete
    case onError
    case onNoAccountFound
    case onClose
}

internal struct ConnectEvent: Decodable {
    let type: String
    let data: ConnectEventData?
}

internal enum ConnectEventData: Decodable {
    case complete(CompleteData)
    case error(ErrorData)
    case empty
    
    struct CompleteData: Decodable {
        let authId: String
        let bi: String
    }
    
    struct ErrorData: Decodable {
        let message: String
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let complete = try? container.decode(CompleteData.self) {
            self = .complete(complete)
            return
        }
        
        if let error = try? container.decode(ErrorData.self) {
            self = .error(error)
            return
        }
        
        self = .empty
    }
}

// MARK: - TapConnectSDK

/// Main class for TapConnect SDK integration
public final class TapConnectSDK: NSObject {
    
    // MARK: - Singleton
    
    /// Shared instance of TapConnectSDK
    public static let shared = TapConnectSDK()
    
    // MARK: - Properties
    
    private weak var delegate: TapConnectSDKDelegate?
    private var presentedViewController: UIViewController?
    private var isInitialized = false
    private var currentConfig: TapConnectSDKConfig?
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
    }
    
    // MARK: - Setup (AppDelegate Integration)
    
    /// Setup TapConnectSDK in your AppDelegate
    /// Call this method in application(_:didFinishLaunchingWithOptions:)
    ///
    /// - Parameters:
    ///   - launchOptions: Launch options from AppDelegate
    ///   - completion: Optional completion handler called when React Native is ready
    /// - Returns: true if initialization started successfully
    @discardableResult
    public static func setup(
        launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil,
        completion: (() -> Void)? = nil
    ) -> Bool {
        guard let frameworkBundle = Bundle(identifier: "tap.ConnectSdkFramework") else {
            print("❌ [TapConnectSDK] Failed to load ConnectSdkFramework bundle")
            return false
        }
        
        print("🚀 [TapConnectSDK] Starting initialization...")
        print("📦 [TapConnectSDK] Framework bundle: \(frameworkBundle.bundlePath)")
        
        // Set the bundle containing the JS and assets (same as original TestConnectSDK app)
        ReactNativeBrownfield.shared.bundle = frameworkBundle
        
        print("⏳ [TapConnectSDK] Starting React Native...")
        ReactNativeBrownfield.shared.startReactNative(
            onBundleLoaded: {
                print("✅ [TapConnectSDK] React Native bundle loaded successfully")
                DispatchQueue.main.async {
                    shared.isInitialized = true
                    completion?()
                }
            },
            launchOptions: launchOptions
        )
        
        shared.isInitialized = true
        print("✅ [TapConnectSDK] Setup initiated")
        
        return true
    }
    
    // MARK: - Public API
    
    /// Present the TapConnect UI
    ///
    /// - Parameters:
    ///   - viewController: The view controller to present from
    ///   - config: Configuration for language, theme, and additional parameters
    ///   - delegate: Delegate to receive callbacks
    public func present(
        from viewController: UIViewController,
        config: TapConnectSDKConfig,
        delegate: TapConnectSDKDelegate
    ) {
        guard isInitialized else {
            print("❌ [TapConnectSDK] SDK not initialized. Call TapConnectSDK.setup() in AppDelegate first.")
            delegate.tapConnectDidError(message: "SDK not initialized")
            return
        }
        
        self.delegate = delegate
        self.currentConfig = config
        
        // Setup communication delegate
        NativeCommunicationService.shared.delegate = self
        
        // Create and present React Native view controller
        let reactNativeVC = ReactNativeViewController(moduleName: "ConnectSdkApp")
        reactNativeVC.modalPresentationStyle = .overFullScreen
        reactNativeVC.view.backgroundColor = .clear
        
        presentedViewController = reactNativeVC
        viewController.present(reactNativeVC, animated: true)
    }
    
    /// Dismiss the TapConnect UI programmatically
    public func dismiss(animated: Bool = true) {
        DispatchQueue.main.async {
            self.presentedViewController?.dismiss(animated: animated) { [weak self] in
                self?.presentedViewController = nil
                self?.delegate = nil
            }
        }
    }
    
    // MARK: - Private Helpers
    
    private func handleConnectEvent(_ event: ConnectEvent) {
        guard let eventType = ConnectEventType(rawValue: event.type) else {
            print("⚠️ [TapConnectSDK] Unknown event type: \(event.type)")
            return
        }
        
        switch eventType {
        case .onComplete:
            if case .complete(let data) = event.data {
                delegate?.tapConnectDidComplete(authId: data.authId, bi: data.bi)
                dismiss(animated: true)
            }
            break
        case .onError:
            if case .error(let data) = event.data {
                delegate?.tapConnectDidError(message: data.message)
                dismiss(animated: true)
            }
            break
        case .onNoAccountFound:
            delegate?.tapConnectDidNotFindAccount()
            dismiss(animated: true)
            break
        case .onClose:
            delegate?.tapConnectDidClose()
            dismiss(animated: true)
            break
        }
    }
}

// MARK: - NativeCommunicationDelegate

extension TapConnectSDK: NativeCommunicationDelegate {
    
    public func requestDataSync() -> String? {
        guard let config = currentConfig else {
            return nil
        }
        
        // Build configuration JSON for React Native
        var configDict: [String: Any] = [
            "language": config.language.rawValue,
            "theme": config.theme.rawValue
        ]
        
        if let token = config.token {
            configDict["token"] = token
        }
        
        if let additionalParams = config.additionalParams {
            configDict.merge(additionalParams) { (_, new) in new }
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: configDict),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        
        return jsonString
    }
    
    public func handleEventFromReactNative(_ data: String) {
        print("📨 [TapConnectSDK] Event received: \(data)")
        
        guard let jsonData = data.data(using: .utf8) else {
            print("❌ [TapConnectSDK] Failed to convert string to data")
            return
        }
        
        do {
            let event = try JSONDecoder().decode(ConnectEvent.self, from: jsonData)
            handleConnectEvent(event)
        } catch {
            print("❌ [TapConnectSDK] Failed to decode event: \(error)")
        }
    }
}
