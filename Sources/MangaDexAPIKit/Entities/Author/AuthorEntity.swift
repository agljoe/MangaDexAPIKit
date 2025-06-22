//
//  AuthorEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-03-25.
//

import Foundation

/// All possible values that can be expanded when retrieving the data of an author.
public enum AuthorReferenceExpansion: String, ReferenceExpansion {
    /// The manga by an author or artist.
    case manga = "manga"
}

public extension Array where Element == AuthorReferenceExpansion {
    /// All available reference expansions at a /author endpoint.
    static var all: Self { AuthorReferenceExpansion.allCases }
    
    /// Indicates that references will not be expanded.
    static var none: Self { [] }
}

/// An entity representing the necessary components for fetching a specifed author.
///
/// - Note: This can also be used to fetch an artist.
struct AuthorEntity: MangaDexAPIEntity, Expandable {
    /// The UUID of the author being retrieved.
    let id: UUID
    
    typealias ModelType = Author
    
    let expansions: [AuthorReferenceExpansion] = .all
    
    var url: URL {
        var compontents = URLComponents()
        compontents.scheme = "https"
        compontents.host = "api.mangadex.org"
        compontents.path = "/author/\(id.uuidString.lowercased())"
        compontents.queryItems = expansions.map {
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        }
        return compontents.url!
    }
    
    var requiresAuthentication: Bool { false }
}
