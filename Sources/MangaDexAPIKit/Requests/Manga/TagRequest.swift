//
//  TagRequest.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-04-01.
//

import Foundation

/// Requests a list of all available manga tags.
public struct TagListRequest: MangaDexAPIRequest {
    public typealias ModelType = ([Tag], Int, Int)
    
    public func decode(_ data: Data) throws -> ([Tag], Int, Int) {
        let result = try JSONDecoder().decode(Wrapper<[Tag]>.self, from: data)
        return (result.data, result.offset ?? 0, result.total ?? 0)
    }
    
    public func execute() async throws -> ([Tag], Int, Int) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/manga/tag"
        return try await get(from: components.url!)
    }
}


