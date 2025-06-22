//
//  Wrappers.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-12.
//

import Foundation

/// A generic wrapper around data returned from the MangaDex API.
///
/// Endpoints that return collections of data, often include the size limit, and offset of the collection,
/// along with the number of returned items.
public struct Wrapper<T: Decodable>: Decodable {
    /// The model type contained in this wrapper
    public let data: T
    
    /// The size limit of collections returned by some endpoint.
    public let limit: Int?
    
    /// The item offset of this collection.
    public let offset: Int?
    
    /// The total number of items in returned in this collection.
    public let total: Int?
}
