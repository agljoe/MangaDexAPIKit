//
//  CoverFromMangaListEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-04-04.
//

import Foundation

/// Same as a MangaListEntity, with the goal of fetching a list of covers.
struct CoverFromMangaListEntity: Expandable, List {
    /// The UUIDs of the manga whose covers are being retrieved.
    let ids: [UUID]
    
    /// The maximum size of the returned collection, must be in range 0...100.
    let limit: Int
    
    let offset: Int
    
    let expansions: [MangaReferenceExpansion] = [.cover, .author, .artist, .creator]
    
    /// Creates a new instance with the specified ids.
    ///
    /// - Parameters:
    ///   - ids: the UUIDs of some manga whose covers are to be fetched.
    ///   - limit: the number of covers to fetch, 10 be default.
    ///   - offset: the starting index of the collection to be fetched, 0 by default.
    ///
    /// - Returns: a newly created CoverFromMangaListEntity.
    init(
        ids: [UUID],
        limit: Int = 10,
        offset: Int = 0
    ) {
        self.ids = ids
        self.limit = limit
        self.offset = offset
    }
    
    typealias ModelType = [Cover]
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/manga"
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        
        components.queryItems?.append(contentsOf: ids.map {
            URLQueryItem(name: "ids[]", value: $0.uuidString.lowercased())
        })
        
        if let contentRating = UserDefaults.standard.object(forKey: "contentRating") as? Rating {
            components.queryItems?.append(contentsOf: contentRating.value)
        }
        
        components.queryItems?.append(contentsOf: expansions.map {
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        })
        
        return components.url!
    }
    
     var requiresAuthentication: Bool { false }
}
