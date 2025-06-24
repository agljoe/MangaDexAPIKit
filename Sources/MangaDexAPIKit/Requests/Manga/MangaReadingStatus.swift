//
//  MangaReadingStatus.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-04-02.
//

import Foundation

/// Wraps a returned reading status string so it can decoded.
///
/// The returned value will be a `ReadingStatus` raw value.
///
/// - Important: This entity has a custom request type, passing it with the generic request type
///              will leading to a decoding error.
private struct ReadingStatusWrapper: Decodable {
    /// A `ReadingStatus` raw value.
    let status: String
}

/// A request that returns a string describing the reading status of a manga.
public struct MangaReadingStatusRequest: MangaDexAPIRequest {
    /// The enitty whose reading status is being retrieved.
    fileprivate let entity: ReadingStatusEntity
    
    /// Craetes a new instance for the specified entity.
    ///
    ///- Parameter id: the UUID of the manga used to initialize the `ReadingStatusEntity`
    ///                 for this request.
    ///
    /// - Returns: a newly created `MangaReadingStatusRequest` for the given manga UUID.
    init(for id: UUID) {
        self.entity = ReadingStatusEntity(id: id)
    }
}

public extension MangaReadingStatusRequest {
    typealias ModelType = String
    
    func decode(_ data: Data) throws -> String {
        return try JSONDecoder().decode(ReadingStatusWrapper.self, from: data).status
    }
    
    func execute() async throws -> String {
        return try await authenticatedGet(from: self.entity.url)
    }
}

/// Wraps the returned reading status dictionary so it can be decoded.
///
/// The returned dictionary is formated such that the key is a manga's UUID string,
/// and the value is reading status.
struct ReadingStatusCollectionWrapper: Decodable { let statuses: [String: String] }

/// A request that retrieves a dictionary containing the reading status for all manga in a user's library.
public struct AllMangaReadingStatusRequest: MangaDexAPIRequest {
    public typealias ModelType = [String: String]
    
    public func decode(_ data: Data) throws -> [String : String] {
        return try JSONDecoder().decode(ReadingStatusCollectionWrapper.self, from: data).statuses
    }
    
    public func execute() async throws -> [String : String] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/manga/status"
        return try await authenticatedGet(from: components.url!)
    }
}
