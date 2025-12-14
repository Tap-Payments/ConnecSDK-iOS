//
//  ViewController.swift
//  TestConnectSDK
//
//  Created by MahmoudShaabanAllam on 10/12/2025.
//

import UIKit
import ReactBrownfield
import ConnectSdkFramework

// MARK: - Event Models

enum ConnectEventType: String {
    case onComplete
    case onError
    case onNoAccountFound
    case onClose
}

struct ConnectEvent: Decodable {
    let type: String
    let data: ConnectEventData?
}

enum ConnectEventData: Decodable {
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
        
        // Try to decode as CompleteData first
        if let complete = try? container.decode(CompleteData.self) {
            self = .complete(complete)
            return
        }
        
        // Try to decode as ErrorData
        if let error = try? container.decode(ErrorData.self) {
            self = .error(error)
            return
        }
        
        // Default to empty
        self = .empty
    }
}

class ViewController: UIViewController, NativeCommunicationDelegate {
    
    private var presentedReactNativeVC: UIViewController?
    
    private let openButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open Connect", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Add button
        view.addSubview(openButton)
        openButton.addTarget(self, action: #selector(openReactNative), for: .touchUpInside)
        
        // Center button
        NSLayoutConstraint.activate([
            openButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            openButton.widthAnchor.constraint(equalToConstant: 200),
            openButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func openReactNative() {
        // Create React Native view controller
        NativeCommunicationService.shared.delegate = self
        let reactNativeVC = ReactNativeViewController(moduleName: "ConnectSdkApp")
        reactNativeVC.modalPresentationStyle = .overFullScreen
        reactNativeVC.view.backgroundColor = .clear
        presentedReactNativeVC = reactNativeVC
        // Present it
        present(reactNativeVC, animated: true)
    }
    
    func requestDataSync() -> String? {
        return "{\"token\": \"abc123\"}"
    }
    
    func handleEventFromReactNative(_ data: String) {
        print("📨 [ViewController] RN sent: \(data)")
        
        guard let jsonData = data.data(using: .utf8) else {
            print("❌ [ViewController] Failed to convert string to data")
            return
        }
        
        do {
            let event = try JSONDecoder().decode(ConnectEvent.self, from: jsonData)
            handleConnectEvent(event)
        } catch {
            print("❌ [ViewController] Failed to decode event: \(error)")
        }
    }
    
    private func handleConnectEvent(_ event: ConnectEvent) {
        guard let eventType = ConnectEventType(rawValue: event.type) else {
            print("⚠️ [ViewController] Unknown event type: \(event.type)")
            return
        }
        
        switch eventType {
        case .onComplete:
            if case .complete(let completeData) = event.data {
                handleOnComplete(authId: completeData.authId, bi: completeData.bi)
            }
            
        case .onError:
            if case .error(let errorData) = event.data {
                handleOnError(message: errorData.message)
            }
            
        case .onNoAccountFound:
            handleOnNoAccountFound()
            
        case .onClose:
            handleOnClose()
        }
    }
    
    // MARK: - Event Handlers
    
    private func handleOnComplete(authId: String, bi: String) {
        print("✅ [ViewController] onComplete - authId: \(authId), bi: \(bi)")
        dismissReactNative()
        
        // TODO: Handle successful completion
        // e.g., navigate to next screen, save data, etc.
    }
    
    private func handleOnError(message: String) {
        print("❌ [ViewController] onError - message: \(message)")
        dismissReactNative()
        
        // Show error alert
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    private func handleOnNoAccountFound() {
        print("⚠️ [ViewController] onNoAccountFound")
        dismissReactNative()
        
        // TODO: Handle no account found scenario
    }
    
    private func handleOnClose() {
        print("🚪 [ViewController] onClose")
        dismissReactNative()
    }
    
    private func dismissReactNative() {
        DispatchQueue.main.async {
            self.presentedReactNativeVC?.dismiss(animated: true)
            self.presentedReactNativeVC = nil
        }
    }
}

