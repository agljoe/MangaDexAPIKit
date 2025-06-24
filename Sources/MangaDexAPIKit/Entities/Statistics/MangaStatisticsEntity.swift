//
//  MangaStatisticsEntity.swift
//  Yomu
//
//  Created by Andrew Joe on 2025-05-05.
//

import Foundation

/// An entity representing the necessary components for fetching the statistics associated with a specific manga.
///
/// This entity uses a custom request type, and is thus marked as private.
internal struct MangaStatisticsEntity: MangaDexAPIEntity {
    /// The UUID of the manga whose statistics are being retrieved.
    let id: UUID
    
    typealias ModelType = MangaStatistics
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/statistics/manga/\(id.uuidString.lowercased())"
        return components.url!
    }
    
    var requiresAuthentication: Bool { false }
}

