//
//  AuthorListEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-03-25.
//

import Foundation

/// An entityrepresenting the necessary components for fetching a specifed collection of authors.
///
/// The returned data will be an array of `Author`
///
/// - Note: This enpoint can aslo fetch a list of artists, or mixed list of authors and artists.
struct AuthorListEntity: Expandable, List {
    /// The ids of all authors being retrieved..
    let ids: [UUID]
    
    let limit: Int
    
    let offset: Int
    
    /// The direction the returned collection is sorted in.
    ///
    /// - Note: This collection can only be sorted alphabetically by author name.
    let order: Order
    
    let expansions: [AuthorReferenceExpansion]
    
    /// Creates a new instance for some given manga, or  cover ids.
    ///
    /// - Parameters:
    ///     - ids: the UUIDs of some authors or aritsts to fetch.
    ///     - limit: the number of authors, or artists to fetch, 10 by default.
    ///     - offset: the starting index of the collection to fetch, 0 by default.
    ///     - order: the direction of the sorted collection, descending alphabetically by default.
    ///     - expansions: the references to expand the data of.
    ///
    /// - Returns: a newly created` AuthorListEntity`.
    init(ids: [UUID],
         limit: Int = 10,
         offset: Int = 0,
         order: Order = Order.desc,
         expansions: [AuthorReferenceExpansion] = .none
    ) {
        self.ids = ids
        self.limit = limit
        self.offset = offset
        self.order = order
        self.expansions = expansions
    }
    
    /// Convience initializer that accpects a variadic list of UUIDs.
    ///
    /// - Parameters:
    ///     - ids: the UUIDs of some authors or aritsts to fetch.
    ///     - limit: the number of authors, or artists to fetch, 10 by default.
    ///     - offset: the starting index of the collection, 0 by default.
    ///     - order: the direction of the sorted collection, descending alphabetically by default.
    ///     - expansions: the references to expand the data of.
    ///
    /// - Returns: a newly created` AuthorListEntity`.
    init(ids: UUID...,
         limit: Int = 10,
         offset: Int = 0,
         order: Order = Order.desc,
         expansions: [AuthorReferenceExpansion] = .none
    ) {
        self.init(
            ids: ids,
            limit: limit,
            offset: offset,
            order: order,
            expansions: expansions
        )
    }
    
    typealias ModelType = [Author]
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/author"
        
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(self.limit)"),
            URLQueryItem(name: "offset", value: "\(self.offset)")
        ]
        components.queryItems?.append(contentsOf: ids.map {
            URLQueryItem(name: "ids[]", value: $0.uuidString.lowercased())
        })
        
        components.queryItems?.append(URLQueryItem(name: "order[name]", value: self.order.rawValue))
        
        components.queryItems?.append(contentsOf: expansions.map {
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        })
        
        return components.url!
    }
    
    var requiresAuthentication: Bool { false }
}
