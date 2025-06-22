//
//  AtHomeEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-04-03.
//

import Foundation

/// An entity representing the necessary compontents for fetching the image URLs of a specific manga.
///
/// - Important: This entity has a custom request type, passing it with the generic request type
///              will leading to a decoding error.
internal struct ChapterImageEntity: MangaDexAPIEntity {
    /// The UUID of the chapter whose images are being retrieved.
    let id: UUID
    
    typealias ModelType = AtHomeChapterComponents
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Server.standard.rawValue
        components.path = "/at-home/server/\(id.uuidString.lowercased())"
        
        if UserDefaults.standard.bool(forKey: "shouldForcePort433") {
            components.queryItems?.append(URLQueryItem(name: "forcePort443", value: "\(true)"))
        }
        
        return components.url!
    }
    
    var requiresAuthentication: Bool { false }
}
