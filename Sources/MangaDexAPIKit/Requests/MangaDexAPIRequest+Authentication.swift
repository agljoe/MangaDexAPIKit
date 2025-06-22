//
//  File.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-12.
//

import Foundation

/// An error that occurs when making authenticated requests.
public enum AuthenticationError: Error {
    /// If a given creadentials value is unable to successfully authenticate.
    case invalidCredentials
    
    /// If authentication fails for any reason with valid credentials.
    case failedToAuthenticate(context: String)
}

extension AuthenticationError: LocalizedError {
    /// The error description shown to the user if authentication fails.
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return String(localized: "Invalid credentials")
        case .failedToAuthenticate(let context):
            return String(localized: "Failed to login, context: \(context)")
        }
    }
}

extension MangaDexAPIRequest {
    /// Performs an OAuth authenticated HTTP GET request from a server for the given `url`.
    ///
    /// OAuth authenticated Api calls requires using the authentication header which is normally a reserved by URLSession, however Apple has stated that setting this header is the
    /// only way to make OAuth requests.
    ///
    /// - Parameter url: the url for a specific sever.
    ///
    /// - Throws: a `KeychainError.noToken` if an access token cannot be found.
    /// - Throws: a corresponding `MangaDexAPIError`  if the returned status code is not 200.
    ///
    /// - Returns: a data value from the specified server.
    public func authenticatedGet(from url: URL) async throws -> ModelType {
        let token = try KeychainManager.getToken(.access)
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpShouldHandleCookies = true
        request.timeoutInterval = 120
        
        request.httpMethod = "GET"
        
        var (data, response) = try await URLSession.shared.data(for: request)
        
        if (response as? HTTPURLResponse)?.statusCode == 401 {
            let _ = try await ReauthenticationRequest().execute()
            let token = try KeychainManager.getToken(.access)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            (data, response) = try await URLSession.shared.data(for: request)
        }
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw mapError((response as! HTTPURLResponse), context: "\(String(data: data, encoding: .utf8) ?? "no context available").")
        }
        
        return try decode(data)
    }
    
    /// Performs an OAuth authenticated HTTP POST  request from a server for the given `url`.
    ///
    /// OAuth authenticated Api calls requires using the authentication header which is normally a reserved by URLSession, however Apple has stated that setting this header is the
    /// only way to make OAuth requests.
    ///
    /// - Parameters:
    ///     - url: the url for a specific sever.
    ///     - value: a string specifying the value for the `Content-Type` header field.
    ///     - content: an encoded data value passed to a specific server as the request's body.
    ///
    /// - Important: The caller is responsible for encoding the data in the correct format, ensure that the data you are passing is correctly configured for the specified server.
    ///
    ///
    /// - Throws: `KeychainError.noToken` if an access token cannot be found.
    /// - Throws: a corresponding `MangaDexAPIError`  if the returned status code is not 200.
    public func authenticatedPost(at url: URL, for value: String? = nil, with content: Data? = nil) async throws {
        let token = try KeychainManager.getToken(.access)
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(value ?? "application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        request.timeoutInterval = 120
        
        if let body = content { request.httpBody = body }
        
        request.httpMethod = "POST"
        
        var (data, response) = try await URLSession.shared.data(for: request)
        
        if (response as? HTTPURLResponse)?.statusCode == 401 {
            try await ReauthenticationRequest().execute()
            let token = try KeychainManager.getToken(.access)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            (data, response) = try await URLSession.shared.data(for: request)
        }
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw mapError((response as! HTTPURLResponse), context: "\(String(data: data, encoding: .utf8) ?? "no context available").")
        }
    }
    
    /// Performs an OAuth authenticated HTTP DELETE  at a server for the given `url`.
    ///
    /// OAuth authenticated Api calls requires using the authentication header which is normally a reserved by URLSession, however Apple has stated that setting this header is the
    /// only way to make OAuth requests.
    ///
    /// - Parameter url: the url for a specifc sever.
    ///
    /// - Warning: This may irreversibly delete data on a live server, ensure you know the endpoint requirements.
    ///
    /// - Throws: a `KeychainError.noToken` if an access token cannot be found.
    /// - Throws: a corresponding `MangaDexAPIError`  if the returned status code is not 200.
    public func authenticatedDelete(at url: URL) async throws -> ModelType {
        let token = try KeychainManager.getToken(.access)
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        request.timeoutInterval = 120
        
        request.httpMethod = "DELETE"
        
        var (data, response) = try await URLSession.shared.data(for: request)
        
        if (response as? HTTPURLResponse)?.statusCode == 401 {
            try await ReauthenticationRequest().execute()
            let token = try KeychainManager.getToken(.access)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            (data, response) = try await URLSession.shared.data(for: request)
            
        }
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw mapError((response as! HTTPURLResponse), context: "\(String(data: data, encoding: .utf8) ?? "no context available").")
        }
        
        return try decode(data)
    }
}
