//
//  ReadingStatusEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// An enitty representing the necessary components for fetching the reading status of a specified manga.
///
/// This entity uses a custom request type, and is thus marked as private.
struct ReadingStatusEntity: MangaDexAPIEntity {
    /// The UUID of the manga whose reading status is being retrieved.
    let id: UUID
    
    typealias ModelType = String
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/manga/\(id.uuidString.lowercased())/status"
        return components.url!
    }
    
    var requiresAuthentication: Bool { true }
}
