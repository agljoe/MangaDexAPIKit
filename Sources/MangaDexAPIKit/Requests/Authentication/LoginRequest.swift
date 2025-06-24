//
//  LoginRequest.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-12.
//

import Foundation

/// A request that fetches an access and refresh token for a given user.
///
/// - Important: This entity has a custom request type, passing it with the generic request type
///              will leading to a decoding error.
public struct LoginRequest: MangaDexAPIRequest {
    /// The credentials of the user logging in.
    ///
    /// A users credentials inclues thier username, password, client id, and client secret.
    let credentials: Credentials
    
    /// The entity that will be fetched by this requests execute method.
    let entity: TokenEntity
    
    /// Creates a new login request for the given credentials
    ///
    /// - Parameters:
    ///     - credentials: The credentials to be used to login.
    ///     - entity: the entity to be fetched by this request, initialized by default.
    ///
    /// - Returns: a newly created LoginRequest for the given credentials.
    init(credentials: Credentials, entity: TokenEntity = TokenEntity()) {
        self.credentials = credentials
        self.entity = entity
    }
    
    /// Logs in to the MangaDexAPI with the given credentials, stores the returned token or tokens in the Keychain if successful.
    ///
    /// - Parameter credentials: the credentials to login with.
    ///
    /// - Throws: `AuthenticationError.invalidCredentials` if a users credentials cannot be properly encoded, or passed to the MangaDex API.
    private func login(with credentials: Credentials) async throws {
        guard let content = "grant_type=password&username=\(credentials.username)&password=\(credentials.password)&client_id=\(credentials.client_id)&client_secret=\(credentials.client_secret)".data(using: .utf8) else {
            throw AuthenticationError.invalidCredentials
        }
        
        let data = try await post(at: entity.url, forContentType: "application/x-www-form-urlencoded", with: content)
        let token = try decode(data)
        try KeychainManager.store(credentials: credentials)
        try KeychainManager.store(token: token, for: credentials.username)
    }
}

public extension LoginRequest {
    typealias ModelType = Token
    
    func decode(_ data: Data) throws -> Token {
        return try JSONDecoder().decode(Token.self, from: data)
    }
    
    @discardableResult
    func execute() async throws -> Token {
        try await login(with: self.credentials)
        return Token()
    }
}
