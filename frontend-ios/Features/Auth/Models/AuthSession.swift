//
//  AuthSession.swift
//  CharChart
//
//  Created by Myles Slack on 2025.10.28.
//

import Foundation

///App-level auth state shim used by Views/ViewModels
///Delegates to the networking interceptor for the actual token

final class AuthSession {
    static let shared = AuthSession()
    
    private init() {}
    
    var isAuthenticated: Bool {
        AuthInterceptor.shared.hasValidToken
    }
}
