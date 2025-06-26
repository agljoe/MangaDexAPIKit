//
//  MangaEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-03-04.
//

import Foundation

/// All possible values that can be expanded when retrieving the data of a manga.
public enum MangaReferenceExpansion: String, ReferenceExpansion {
    /// All manga related to this manga in some way.
    case manga = "manga"
    
    /// The most recent volume cover.
    case cover = "cover_art"
    
    /// The author of a manga.
    case author = "author"
    
    /// The artist of a manga.
    case artist = "artist"
    
    /// The available tag for a manga
    ///
    /// - Note: these are available by default in through the data/attributes decoding keypath.
    case tag = "tag"
    
    /// The person who created a manga's MangaDex page.
    case creator = "creator"
}

public extension Array where Element == MangaReferenceExpansion {
    /// All available reference expansions at a /cover endpoint.
    static var all: Self { MangaReferenceExpansion.allCases }
    
    /// Indicates that a manga's references will not be expanded.
    static var none: Self { [] }
}

/// An entity representing the necessary components for fetching a specifed manga.
struct MangaEntity: MangaDexAPIEntity, Expandable {
    /// The UUID of the manga being retrieved.
    let id: UUID
    
    typealias ModelType = Manga
    
    let expansions: [MangaReferenceExpansion] = [.manga, .cover, .author, .artist, .creator]
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/manga/\(id.uuidString.lowercased())"
        components.queryItems = expansions.map {
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        }
        return components.url!
    }
    
    var requiresAuthentication: Bool { false }
}
