//
//  MangaListEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-03-31.
//

import Foundation

/// An entity representing the compontents needed to fetch a collection of specified manga.
struct MangaListEntity: Expandable, List {
    /// The UUIDs of the manga being retrieved..
    let ids: [UUID]
    
    let limit: Int
    
    let offset: Int
    
    /// The direction the returned collection is sorted in.
    ///
    /// This collection can be sorted by title alphabetically, release year, creation date, latest update, lastest uploaded chapter,
    ///  follows, search relevence, or user rating.
    let order: Order
    
    /// Additional query paramters to be passed with this entity's request.
    ///
    /// This collection can be sorted by title, release year, creation date, most recently updated, most recent chapter upload, total follows, search relevence, or user rating.
    let queryItems: [URLQueryItem]?
    
    let expansions: [MangaReferenceExpansion]
    
    /// Creates a new instance with the given ids.
    ///
    /// - Parameters:
    ///     - ids: the UUIDs of some manga to fetch.
    ///     - limit: the number of chapters to fetch, 10 by default.
    ///     - offset: : the starting index of the colleciton, 0 by default.
    ///     - order: the direction of this collection's sort.
    ///     - queryItems: additional URLQuery items used when searching for manga.
    ///     - expansions: the references to expand the data of.
    ///
    /// - Returns: a newly created `MangaListEntity`.
    init(
        ids: [UUID],
        limit: Int = 10,
        offset: Int = 0,
        order: Order = Order.desc,
        queryItems: [URLQueryItem]? = nil,
        expansions: [MangaReferenceExpansion] = [.manga, .cover, .author, .artist, .creator]
    ) {
        self.ids = ids
        self.limit = limit
        self.offset = offset
        self.order = order
        self.queryItems = queryItems
        self.expansions = expansions
    }
    
    /// Convience initializer that accpects a variadic list of UUIDs.
    ///
    /// - Parameters:
    ///     - ids: the UUIDs of some manga to fetch.
    ///     - limit: the number of chapters to fetch, 10 by default.
    ///     - offset: : the starting index of the colleciton, 0 by default.
    ///     - order: the direction of this collection's sort.
    ///     - queryItems: additional URLQuery items used when searching for manga.
    ///     - expansions: the references to expand the data of.
    ///
    /// - Returns: a newly created `MangaListEntity`.
    init(
        ids: UUID...,
        limit: Int = 10,
        offset: Int = 0,
        order: Order = Order.desc,
        queryItems: [URLQueryItem]? = nil,
        expansions: [MangaReferenceExpansion] = [.manga, .cover, .author, .artist, .creator]
    ) {
        self.init(
            ids: ids,
            limit: limit,
            offset: offset,
            order: order,
            queryItems: queryItems,
            expansions: expansions
        )
    }
    
    typealias ModelType = [Manga]
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/manga"
        
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(self.limit)"),
            URLQueryItem(name: "offset", value: "\(self.offset)")
        ]
        
        components.queryItems?.append(contentsOf: ids.map {
            URLQueryItem(name: "ids[]", value: $0.uuidString.lowercased())
        })
        
        if let queryItems = self.queryItems {
            components.queryItems?.append(contentsOf: queryItems)
        } else {
            if let contentRating = Rating(rawValue: UserDefaults.standard.string(forKey: "contentRating") ?? "") {
                components.queryItems?.append(contentsOf: contentRating.value)
            }
        }
        
        components.queryItems?.append(contentsOf: expansions.map {
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        })
                                 
        return components.url!
    }
    
    var requiresAuthentication: Bool { false }
}
