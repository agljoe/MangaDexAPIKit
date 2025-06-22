//
//  ChapterStatisticsEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-05-03.
//

import Foundation

/// An entity representing the necessary components for fetching the statistics associated with a specific chatper.
///
/// This entity uses a custom request type, and is thus marked as private.
internal struct ChapterStatisticsEntity: MangaDexAPIEntity {
    /// The UUID of the chapter whose statistics are being retrieved.
    let id: UUID
    
    typealias ModelType = ChapterStatistics
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.scheme = Server.standard.rawValue
        components.path = "/statistics/chapter/\(id.uuidString.lowercased())"
        return components.url!
    }
    
    var requiresAuthentication: Bool { false }
}
