//
//  Token.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-12.
//

import Foundation

/// Used for categorizing tokens stored in the keychain.
@frozen
public enum TokenType: String {
    /// An access token.
    case access = "access"
    
    /// A refresh token.
    case refresh = "refresh"
}

/// A value passed in the `authorization` header of a HTTP request for authenticated OAuth calls.
///
///  MangaDex specifies that ``Token/access`` is  used for all endpoints requiring authorization headers, except when generating new access tokens.
///
///    For more information on authentication using the MangaDexApi see [Personal Clients](https://api.mangadex.org/docs/02-authentication/personal-clients/).
///
public struct Token: Codable, Hashable, Sendable {
    public let access: String
    public let refresh: String?
    
    /// Creates a Token value with access initalized as an empty string.
    ///
    /// - Returns: a Token with no access or refresh token.
    public init() {
        self.access = ""
        self.refresh = nil
    }
    
    /// Create a Token value given a specified access.
    ///
    /// - Parameters:
    ///     - access: a token value that is used for OAuth authenticated API calls.
    ///     - refresh: a token value that is used to aquire a new access token.
    ///
    /// - Returns: a newly created Token initialized to the given values.
    public init(
        access: String,
        refresh: String?
    ) {
        self.access = access
        self.refresh = refresh
    }
    
    /// Keys used to decode JSON data returned from MangaDex servers.
    private enum CodingKeys: String, CodingKey {
        case access = "access_token"
        case refresh = "refresh_token"
    }
    
    /// Creates new instance by decoding from any decoder.
    ///
    /// - Parameter decoder: the decoder to decode from.
    ///
    /// - Returns: a newly created `Token` from the given decoder.
    ///
    /// - Throws: a `DecodingError` if a token cannot be initalized by the given `decoder`.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.access = try container.decode(String.self, forKey: .access)
        self.refresh = try container.decodeIfPresent(String.self, forKey: .refresh)
    }
}
