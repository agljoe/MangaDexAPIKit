//
//  CoverEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-04-02.
//

import Foundation

/// All possible values that can be expanded when retrieving the data of a cover.
public enum CoverReferenceExpansion: String, ReferenceExpansion {
    /// The manga a given cover is for.
    case manga = "manga"
    
    /// The user who uploaded a given cover.
    case user = "user"
}

public extension Array where Element == CoverReferenceExpansion {
    /// All available reference expansions at a /cover endpoint.
    static var all: Self { CoverReferenceExpansion.allCases }
    
    /// All available reference expansions at a /chapter endpoint.
    static var none: Self { [] }
}

/// An entity representing the necessary components for fetching a specified cover.
struct CoverEntity: MangaDexAPIEntity, Expandable {
    /// The UUID of the cover being retrieved.
    ///
    /// MangaDexAPI documentation states that a this endpoint also accepts the UUID of a manga,
    /// but it actually on accepts a cover UUID. The UUID for the cover  of a given manga can be found in its reference expansion.
    let id: UUID
    
    typealias ModelType = Cover
    
    let expansions: [CoverReferenceExpansion] = [.manga]
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Server.standard.rawValue
        components.path = "/cover/\(id.uuidString.lowercased())"
        components.queryItems = expansions.map {
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        }
        return components.url!
    }
    
    var requiresAuthentication: Bool { false }
}
