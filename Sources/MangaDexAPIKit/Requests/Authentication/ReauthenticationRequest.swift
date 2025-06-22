//
//  File.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-12.
//

import Foundation

/// A request that fetches a new access token for a user.
///
/// This type of request should only be made if an authenticated request fails with error code 401 as  to avoid
/// wasting calls and bandwidth trying to refresh tokens every fifteen minutes.
struct ReauthenticationRequest: MangaDexAPIRequest {
    /// Fetches an entity that is virtually identical to the one returned by a login request,
    /// thus the `TokenEntity` type can be reused here.
    ///
    /// - Note: This request is also convienienty made at same endpoint as a login request,
    ///     with the only difference being the HTTP form to be filled out.
    let entity: TokenEntity
    
    /// Creates a new ReAuthenticationRequest prepopulated with a TokenEntity value.
    ///
    /// - Parameter entity: the entity to be fetched by this request., initialized by default.
    ///
    /// - Returns: a newly created `ReAuthenticationRequest`.
    init(entity: TokenEntity = TokenEntity()) {
        self.entity = entity
    }
    
    /// Fetches a new access token to be stored in the Keychain.
    ///
    /// - Throws: `KeychainError.noToken` if a refresh token cannot be found.
    /// - Throws: `KeyChainError.noPassword` if credentials cannot be found.
    /// - Throws: `AuthenticationError.invalidCredentials`  if a users credentials or refresh token cannot be properly encoded, or passed to the MangaDex API.
    private func reAuthenticate() async throws {
        let token = try KeychainManager.getToken(.refresh)
        guard let user = UserDefaults.standard.string(forKey: "loggenInUser") else { return }
        
        let credentials = try KeychainManager.get(credentials: user)
        
        guard let content = "grant_type=refresh_token&refresh_token=\(token)&client_id=\(credentials.client_id)&client_secret=\(credentials.client_secret)".data(using: .utf8) else { throw MangaDexAPIError.badRequest(context: "Request body was improperly formed.") }
        
        let data = try await post(at: entity.url, forContentType: "application/x-www-form-urlencoded", with: content)
        let result = try decode(data)
        try KeychainManager.update(token: result.access, .access, for: credentials.username)
    }
    
    typealias ModelType = Token
    
    func decode(_ data: Data) throws -> Token {
        return try JSONDecoder().decode(Token.self, from: data)
    }
    
    @discardableResult
    func execute() async throws -> Token {
        try await reAuthenticate()
        return Token()
    }
}
