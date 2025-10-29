//
//  AuthInterceptor.swift
//  CharChart
//
//  Created by Myles Slack on 2025.10.28.
//

import Foundation

/// Single place to store/read the access token used for requests.
/// Later, wire this to Keychain and refresh logic.
///
final class AuthInterceptor {
    static let shared = AuthInterceptor()
    private init() {}
    
    //Stor token here after login
    var accessToken: String?
    
    var hasValidToken: Bool {
        guard let t = accessToken else { return false }
        return !t.isEmpty
    }
}
