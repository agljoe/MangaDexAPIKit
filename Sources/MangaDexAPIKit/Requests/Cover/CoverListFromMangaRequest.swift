//
//  CoverListFromManga.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-16.
//

import Foundation

/// Shortcut to get the most recent available cover for a manga, when starting from one of its chapters.
///
/// This approach uses the least memroy and API calls, as trying to go through the /cover, or /cover{id} endpoints
/// wastes memory decoding uneeded objects, or uses extra calls fetching missing covers.
struct CoverFromMangaWrapper: Decodable {
    /// The UUID of the manga the retrieved cover belongs to.
    let parentManga: UUID
    
    /// The cover found in the reference expansion of a manga.
    let cover: Cover
    
    /// Ignore all data found in the returned manga object, and only decode the heterogenous
    /// array of JSON objects found in its relationships.
    private enum CodingKeys: CodingKey {
        case id, relationships
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Returns: a newly created Cover from the given decoder.
    ///
    /// - Throws: a `DecodingError` if a cover cannot be initalized by the given `decoder`.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.parentManga = try container.decode(UUID.self, forKey: .id)
        let relationships = try container.decode([MangaRelationship].self, forKey: .relationships)
        var covers = [Cover]()
        
        for relationship in relationships {
            switch relationship {
            case .cover_art(let cover): covers.append(cover)
            default: break
            }
        }
        
        self.cover = covers.first!
    }
}

/// Requests a list of manga, and returns all the covers found in their reference expansions.
public struct CoverListFromMangaRequest {
    /// A custom entity for this request.
    let entity: CoverFromMangaListEntity
    
    /// Creates a new instance with the given entity.
    ///
    /// - Parameter entity: a   `CoverFromMangaListEntity`
    ///
    /// - Returns: a newly created `CoverListFromMangaRequest` for the given entity.
    init(_ entity: CoverFromMangaListEntity) {
        self.entity = entity
    }
}

extension CoverListFromMangaRequest: MangaDexAPIRequest {
    public typealias ModelType = [(Cover, UUID)]
    
    public func decode(_ data: Data) throws -> [(Cover, UUID)] {
        let covers = try decoder().decode(Wrapper<[CoverFromMangaWrapper]>.self, from: data)
        return covers.data.map { ($0.cover, $0.parentManga) }
    }
    
    public func execute() async throws -> [(Cover, UUID)] {
        return try await get(from: entity.url)
    }
}
