//
//  CheckIfMangaIsFollowedRequest.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-04-29.
//

import Foundation

/// Represents a request to the /user/follows/manga/{id} endpoint.
///
/// Due to the way this specifc endpoint works the execute fuction will return false if an error was thrown
/// and the decode method will always return true.
public struct CheckIfMangaIsFollowedRequest: MangaDexAPIRequest {
    /// The UUID of the manga whose follow status is being checked.
    let id: UUID
    
    public typealias ModelType = Bool
    
    public func decode(_ data: Data) throws -> Bool {
        return true
    }
    
    public func execute() async throws -> Bool {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/user/follows/manga/\(id.uuidString.lowercased())"
    
        do {
            return try await authenticatedGet(from: components.url!)
        } catch {
            return false
        }
    }
}
