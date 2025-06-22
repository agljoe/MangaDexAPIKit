//
//  ChapterEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-03-29.
//

import Foundation

/// All possible values that can be expanded when retrieving the data of a chapter.
public enum ChapterReferenceExpansion: String, ReferenceExpansion {
    /// The manga a given chapter belongs to.
    case manga = "manga"
    
    /// The group of people who translated a given chapter.
    case scanlationGroup = "scanlation_group"
    
    /// The user who uploaded a given chapter.
    case user = "user"
}

public extension Array where Element == ChapterReferenceExpansion {
    /// All available reference expansions at a /chapter endpoint.
    static var all: Self { ChapterReferenceExpansion.allCases }
    
    /// Indicates that references will not be expanded.
    static var none: Self { [] }
}

/// An entity that represents the components needed to fetch a specific chapter of a manga.
struct ChapterEntity: MangaDexAPIEntity, Expandable {
    /// The UUID of a specific chapter
    let id: UUID
    
    typealias ModelType = Chapter
    
    let expansions: [ChapterReferenceExpansion] = .all
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Server.standard.rawValue
        components.path = "/chapter/\(id.uuidString.lowercased())"
        components.queryItems = expansions.map {
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        }
        return components.url!
    }
    
    var requiresAuthentication: Bool { false }
}
