//
//  CoverListEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-04-02.
//

import Foundation

/// An entity representing the necessary components for fetching a list of covers.
///
/// Cover lists can be fetched with a list of manga UUIDs, cover UUIDs, or a mix
/// of both.
struct CoverListEntity: Expandable, List {
    /// The UUIDs of the manga, whose covers are being retrieved.
    let mangaIDs: [UUID]?
    
    /// The UUIDs of the covers being retrieved.
    let coverIDs: [UUID]?
    
    /// The maximum size of the returned collection, must be in range 0...100
    ///
    /// - Note: The MangaDexAPI will return all available covers for all manga IDs passed with a request
    ///         for this entity.
    let limit: Int
    
    /// The number of items the returned collection is shifted from the first item when this value is zero.
    ///
    /// ### See
    /// [Pagnation](https://api.mangadex.org/docs/01-concepts/pagination/)
    let offset: Int
    
    let expansions: [CoverReferenceExpansion]
        
    /// Creates a new instance for some given manga, or  cover ids.
    ///
    /// - Parameters:
    ///     - mangaIDs: the UUIDs of some manga whose covers to fetch.
    ///     - coverIDs: the UUIDs of the covers to fetch
    ///     - limit: the number of covers to fetch,
    ///     - offset: the starting index of the colleciton  be fetch, 0 by default.
    ///     - expansions: the references to expand the data of.
    ///
    /// - Returns: a newly created `CoverListEntity`.
    init(
        mangaIDs: [UUID]? = nil,
        coverIDs: [UUID]? = nil,
        limit: Int = 10,
        offset: Int = 0,
        expansions: [CoverReferenceExpansion] = .none
    ) {
        self.mangaIDs = mangaIDs
        self.coverIDs = coverIDs
        self.limit = limit
        self.offset = offset
        self.expansions = expansions
    }
    
    /// Convience initializer that accpects a variadic list of UUIDs.
    ///
    /// - Parameters:
    ///     - mangaIDs: the UUIDs of some manga whose covers to fetch.
    ///     - coverIDs: the UUIDs of the covers to fetch
    ///     - limit: the number of covers to fetch,
    ///     - offset: the starting index of the colleciton to be fetched, 0 by default.
    ///     - expansions: the references to expand the data of.
    ///
    /// - Returns: a newly created` CoverListEntity`.
    init(
        mangaIDs: UUID...,
        coverIDs: UUID...,
        limit: Int = 10,
        offset: Int = 0,
        expansions: [CoverReferenceExpansion] = .none
    ) {
        self.init(
            mangaIDs: mangaIDs,
            coverIDs: coverIDs,
            limit: limit,
            offset: offset,
            expansions: expansions
        )
    }
    
    typealias ModelType = [Cover]
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/cover"
        
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        
        if let manga = mangaIDs {
            components.queryItems?.append(contentsOf: manga.map {
                URLQueryItem(name: "manga[]", value: $0.uuidString.lowercased())
            })
        }
        
        if let cover = coverIDs {
            components.queryItems?.append(contentsOf: cover.map {
                URLQueryItem(name: "ids[]", value: $0.uuidString.lowercased())
            })
        }
        
        components.queryItems?.append(URLQueryItem(name: "order[volume]", value: Order.desc.rawValue))
        
        components.queryItems?.append(contentsOf: expansions.map {
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        })
        
        return components.url!
    }
    
    var requiresAuthentication: Bool { false }
}
