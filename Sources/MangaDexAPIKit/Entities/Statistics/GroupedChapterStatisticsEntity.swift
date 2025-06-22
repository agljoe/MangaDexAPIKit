//
//  GroupedChapterStatisticsEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-05-07.
//

import Foundation

/// An entity representing the necessary compontents for fetching the statatistics of multiple chatpters.
internal struct GroupedChapterStatisticsEntity: MangaDexAPIEntity {
    /// The UUIDs of the chapters whose statistics are being retrieved.
    let ids: [UUID]
    
    typealias ModelType = ChapterStatistics
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Server.standard.rawValue
        components.path = "/statistics/chapter"
        components.queryItems = ids.map( { URLQueryItem(name: "chapter[]", value: $0.uuidString.lowercased())} )
        return components.url!
    }
    
    var requiresAuthentication: Bool { false }
}

