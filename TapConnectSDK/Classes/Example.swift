//
//  Example.swift
//  TapConnectSDK
//
//  Example implementation showing how to use TapConnectSDK
//  This file is for reference only and should not be included in production
//

/*

// MARK: - AppDelegate Example

import UIKit
import TapConnectSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initialize TapConnectSDK - Required!
        TapConnectSDK.setup(launchOptions: launchOptions)
        
        return true
    }
}

// MARK: - ViewController Example

import UIKit
import TapConnectSDK

class ExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Setup your UI with a button to trigger Connect
        let connectButton = UIButton(type: .system)
        connectButton.setTitle("Connect Account", for: .normal)
        connectButton.addTarget(self, action: #selector(openConnect), for: .touchUpInside)
        // Add button to view...
    }
    
    @objc private func openConnect() {
        // Option 1: Minimal configuration
        let config = TapConnectSDKConfig()
        
        // Option 2: With language and theme
        // let config = TapConnectSDKConfig(language: .arabic, theme: .dark)
        
        // Option 3: With token
        // let config = TapConnectSDKConfig(
        //     language: .english,
        //     theme: .light,
        //     token: "user_authentication_token"
        // )
        
        // Option 4: With additional parameters
        // let config = TapConnectSDKConfig(
        //     language: .english,
        //     theme: .light,
        //     token: "token",
        //     additionalParams: [
        //         "userId": "12345",
        //         "customField": "value"
        //     ]
        // )
        
        TapConnectSDK.shared.present(
            from: self,
            config: config,
            delegate: self
        )
    }
    
    private func navigateToNextScreen(authId: String, bi: String) {
        // Navigate to success screen or next step
        print("Navigating with authId: \(authId)")
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Connection Failed",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.openConnect()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - TapConnectSDKDelegate

extension ExampleViewController: TapConnectSDKDelegate {
    
    func tapConnectDidComplete(authId: String, bi: String) {
        print("✅ Success! AuthID: \(authId), BI: \(bi)")
        
        // Option 1: Save data and navigate
        UserDefaults.standard.set(authId, forKey: "connectAuthId")
        navigateToNextScreen(authId: authId, bi: bi)
        
        // Option 2: Make API call with the data
        // sendToBackend(authId: authId, bi: bi)
        
        // Option 3: Show success message
        // showSuccessMessage()
    }
    
    func tapConnectDidError(message: String) {
        print("❌ Error: \(message)")
        showErrorAlert(message: message)
    }
    
    func tapConnectDidNotFindAccount() {
        print("⚠️ No account found")
        
        // Option 1: Show onboarding
        // showOnboardingScreen()
        
        // Option 2: Show account creation flow
        // navigateToAccountCreation()
        
        // Option 3: Show informative message
        let alert = UIAlertController(
            title: "No Account Found",
            message: "We couldn't find an account associated with your details.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tapConnectDidClose() {
        print("🚪 User dismissed Connect")
        
        // Optional: Track analytics
        // Analytics.track("connect_dismissed")
        
        // Optional: Show message encouraging completion
        // showEncouragementMessage()
    }
}

// MARK: - SwiftUI Example

import SwiftUI
import TapConnectSDK

struct ContentView: View {
    @State private var isConnectPresented = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Button("Connect Account") {
                presentConnect()
            }
        }
        .alert("Message", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func presentConnect() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        let config = TapConnectSDKConfig(language: .english, theme: .light)
        
        let coordinator = ConnectCoordinator(
            onComplete: { authId, bi in
                alertMessage = "Success! Auth ID: \(authId)"
                showAlert = true
            },
            onError: { message in
                alertMessage = "Error: \(message)"
                showAlert = true
            },
            onNoAccount: {
                alertMessage = "No account found"
                showAlert = true
            },
            onClose: {
                print("Connect closed")
            }
        )
        
        TapConnectSDK.shared.present(
            from: rootViewController,
            config: config,
            delegate: coordinator
        )
    }
}

// Helper class for SwiftUI
class ConnectCoordinator: TapConnectSDKDelegate {
    let onComplete: (String, String) -> Void
    let onError: (String) -> Void
    let onNoAccount: () -> Void
    let onClose: () -> Void
    
    init(
        onComplete: @escaping (String, String) -> Void,
        onError: @escaping (String) -> Void,
        onNoAccount: @escaping () -> Void,
        onClose: @escaping () -> Void
    ) {
        self.onComplete = onComplete
        self.onError = onError
        self.onNoAccount = onNoAccount
        self.onClose = onClose
    }
    
    func tapConnectDidComplete(authId: String, bi: String) {
        onComplete(authId, bi)
    }
    
    func tapConnectDidError(message: String) {
        onError(message)
    }
    
    func tapConnectDidNotFindAccount() {
        onNoAccount()
    }
    
    func tapConnectDidClose() {
        onClose()
    }
}

*/
