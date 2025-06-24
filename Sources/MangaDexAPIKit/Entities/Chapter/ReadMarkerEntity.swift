//
//  ReadMarkerEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-04-05.
//

import Foundation

/// An entity representing the necessary components for fetching the UUIDs chapters that
/// have be read for a specified manga.
internal struct ReadMarkerEntity: MangaDexAPIEntity {
    /// The UUID of the manga whose chapter read markers are being retrieved.
    let id: UUID
    
    typealias ModelType = [String]
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/manga/\(id.uuidString.lowercased())/read"
        return components.url!
    }
    
    var requiresAuthentication: Bool { true }
}
