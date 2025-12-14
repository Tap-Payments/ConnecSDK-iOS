//
//  TapConnectSDKDelegate.swift
//  TapConnectSDK
//
//  Protocol defining callbacks for TapConnectSDK events
//

import Foundation

/// Delegate protocol for receiving callbacks from TapConnectSDK
public protocol TapConnectSDKDelegate: AnyObject {
    
    /// Called when the user successfully completes the connection process
    /// - Parameters:
    ///   - authId: The authentication ID returned from the connection
    ///   - bi: Additional business intelligence data
    func tapConnectDidComplete(authId: String, bi: String)
    
    /// Called when an error occurs during the connection process
    /// - Parameter message: Error message describing what went wrong
    func tapConnectDidError(message: String)
    
    /// Called when no account is found for the user
    func tapConnectDidNotFindAccount()
    
    /// Called when the user closes the Connect UI without completing
    func tapConnectDidClose()
}
