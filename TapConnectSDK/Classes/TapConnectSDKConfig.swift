//
//  TapConnectSDKConfig.swift
//  TapConnectSDK
//
//  Configuration model for TapConnectSDK
//

import Foundation

/// Language options for the SDK UI
public enum TapConnectLanguage: String {
    case english = "en"
    case arabic = "ar"
}

/// Theme options for the SDK UI
public enum TapConnectTheme: String {
    case light = "light"
    case dark = "dark"
}

/// Configuration for initializing TapConnectSDK
public struct TapConnectSDKConfig {
    
    /// Language for the SDK UI
    public let language: TapConnectLanguage
    
    /// Theme for the SDK UI
    public let theme: TapConnectTheme
    
    /// Optional authentication token
    public let token: String?
    
    /// Custom initialization parameters
    public let additionalParams: [String: Any]?
    
    /// Initialize configuration
    /// - Parameters:
    ///   - language: Language for the SDK UI (default: .english)
    ///   - theme: Theme for the SDK UI (default: .light)
    ///   - token: Optional authentication token
    ///   - additionalParams: Additional configuration parameters
    public init(
        language: TapConnectLanguage = .english,
        theme: TapConnectTheme = .light,
        token: String? = nil,
        additionalParams: [String: Any]? = nil
    ) {
        self.language = language
        self.theme = theme
        self.token = token
        self.additionalParams = additionalParams
    }
}
