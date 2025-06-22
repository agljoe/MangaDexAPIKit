//
//  Credentials.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-12.
//

import Foundation

/// A collection of identifiers used to get OAuth tokens for a  user
///
/// A `Credentials` value encapsulates all user information required to login using the MangaDexApi.
///
/// The MangaDexApi requies users to login in order to create the associated OAuth access and refresh tokens.
///
/// For more information see [Personal Clients](https://api.mangadex.org/docs/02-authentication/personal-clients/).
public struct Credentials: Codable, Hashable, Sendable {
    public var username: String
    public var password: String
    public var client_id: String
    public var client_secret: String
    
    /// Creates a ``Credentials`` instance initialized with placeholder values.
    ///
    /// - Returns: A Credentials value containing only empty string.
    public init() {
        self.username = ""
        self.password = ""
        self.client_id = ""
        self.client_secret = ""
    }
    
    /// Creates a ``Credentials`` instance initalized to the given values.
    ///
    /// - Parameters:
    ///     - username: a username.
    ///     - password: a password.
    ///     - client_id: an identifier for a MangaDexAPI client.
    ///     - client_secret: a key used to authenticate a MangaDexAPI client.
    ///
    ///  - Returns: a newly created `Credentials` instance initialized with the given values.
    public init(username: String, password: String, client_id: String, client_secret: String) {
        self.username = username
        self.password = password
        self.client_id = client_id
        self.client_secret = client_secret
    }
    
    /// Sets the value of all members to empty strings.
    public mutating func reset() {
        self.username = ""
        self.password = ""
        self.client_id = ""
        self.client_secret = ""
    }
}
