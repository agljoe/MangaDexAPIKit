//
//  MangaDexAPIClient+Authentication.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// Authentication requests.
public extension MangaDexAPIClient {
    /// Authenticates a MangaDexAPi personal client .
    ///
    /// - Warning: Do not every share your personal client's secret with anyone, or store it in plain text anywhere in your projects files.
    ///
    /// - Note: MangaDexAPIKit automatically stores and encrypts your credentials in Apple's Keychain ensuring you do not have to the former.
    ///
    /// - Parameter credentials: a  `Credentials` value containing the required username, password, client ID, and client secret.
    ///
    /// - Returns: a `Result` containing an OAuth token or any errors that occured during the login operation.
    @discardableResult
    func login(with credentials: Credentials) async -> Result<Token, Error> {
        await Task {
            try await self.rateLimiter.withToken {
                try await LoginRequest(credentials: credentials).execute()
            }
        }.result
    }
    
    /// Generates a new access token using the credentials stored in the keychain.
    ///
    /// - Returns: a `Result` containing an OAuth token or any errors that occured during the reauthentication operation.
    @discardableResult
    func reauthenticate() async -> Result<Token, Error> {
        await Task {
            try await self.rateLimiter.withToken {
                try await ReauthenticationRequest().execute()
            }
        }.result
    }
}
