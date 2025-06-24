//
//  GroupedMangaStatisticsEntity.swift
//  Yomu
//
//  Created by Andrew Joe on 2025-05-07.
//

import Foundation

/// An entity representing the necessary compontents for fetching the statatistics of multiple manga.
internal struct GroupedMangaStatisticsEntity: MangaDexAPIEntity {
    /// The UUIDs of the manga whose statistics are being retrieved.
    let ids: [UUID]
    
    typealias ModelType = MangaStatistics
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/statistics/manga"
        components.queryItems = ids.map( { URLQueryItem(name: "manga[]", value: $0.uuidString.lowercased()) })
        return components.url!
    }
    
    var requiresAuthentication: Bool { false }
}
