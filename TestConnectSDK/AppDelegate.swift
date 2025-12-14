//
//  AppDelegate.swift
//  TestConnectSDK
//
//  Created by MahmoudShaabanAllam on 10/12/2025.
//

import UIKit
import ConnectSdkFramework
import ReactBrownfield

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize React Native - point to bundle inside ConnectSdkFramework
        guard let frameworkBundle = Bundle(identifier: "tap.ConnectSdkFramework") else {
            print("Failed to load ConnectSdkFramework bundle")
            return true
        }
        ReactNativeBrownfield.shared.bundle = frameworkBundle
        ReactNativeBrownfield.shared.startReactNative(
            onBundleLoaded: {
                print("React Native bundle loaded from framework")
            },
            launchOptions: launchOptions
        )
        
        return true
    }
    
    
}

