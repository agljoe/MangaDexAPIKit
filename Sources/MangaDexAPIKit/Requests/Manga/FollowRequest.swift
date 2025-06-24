//
//  FollowRequest.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-03-31.
//

import Foundation

/// Represents a request to add the specified manga to a user's followed manga list.
///
/// The chapters of every manga in a user's followed manga list will appear in their followed feed.
///
/// - Note: Followed manga are implicitely added to a user's library, any manga with a reading status is considered
///         part the library
public struct Follow: MangaDexAPIRequest {
    /// The UUID of the manga to follow.
    let manga: UUID
    
    /// Creates a new instance with the given UUID.
    ///
    /// - Parameter manga: The UUID of a manga.
    ///
    /// - Returns: a newly created `Follow` request for the given manga UUID.
    init(manga: UUID) {
        self.manga = manga
    }
}

public extension Follow {
    typealias ModelType = Response
    
    func decode(_ data: Data) throws -> Response {
        return try JSONDecoder().decode(Response.self, from: data)
    }
    
    func execute() async throws -> Response {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/manga/\(manga.uuidString.lowercased())/follow"
        
        return try await authenticatedGet(from: components.url!)
    }
}

/// Represents a request to remove the specified manga to a user's followed manga list.
///
/// - Note: Unfollowing a manga will not remove it from a user's library, in order to do so a manga's reading status
///         must be set to none
public struct Unfollow: MangaDexAPIRequest  {
    /// The UUID of the manga to unfollow.
    let manga: UUID
    
    /// Creates a new instance with the given UUID.
    ///
    /// - Parameter manga: The UUID of a manga.
    ///
    /// - Returns: a newly created `Unfollow` request for the given manga UUID.
    init(manga: UUID) {
        self.manga = manga
    }
}

public extension Unfollow {
    typealias ModelType = Response
    
    func decode(_ data: Data) throws -> Response {
        return try JSONDecoder().decode(Response.self, from: data)
    }
    
    func execute() async throws -> Response {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/manga/\(manga.uuidString.lowercased())/follow"
        
        return try await authenticatedDelete(at: components.url!)
    }
}
