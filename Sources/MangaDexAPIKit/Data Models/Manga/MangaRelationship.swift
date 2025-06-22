//
//  MangaRelationship.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// An object containing the information of a related manga.
///
/// ### See
/// ``MangaRelated``
public struct RelatedManga: Decodable, Equatable, Hashable, Identifiable, Sendable {
    /// A unique id assigned to a manga.
    public let id: UUID
    
    /// The type of this object.
    public let type: String
    
    /// A description of how this manga is related.
    public let related: String
    
    /// The base coding keys for this struct.
    private enum CodingKeys: CodingKey {
        case id, type, related
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created Related from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if a Related cannot be initialized by the given decoder.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.type = try container.decode(String.self, forKey: .type)
        self.related = try container.decode(String.self, forKey: .related)
    }
    
    public static func == (lhs: RelatedManga, rhs: RelatedManga) -> Bool {
        return lhs.id == rhs.id
    }
}

/// All possible types in a manga's reference expansion collection.
///
/// ### See
/// [Reference Expansion](https://api.mangadex.org/docs/01-concepts/reference-expansion/)
public enum MangaRelationshipType: String, Decodable {
    /// An ``Author``
    case author
    
    /// An ``Author``
    case artist
    
    /// A ``Cover``
    case cover_art
    
    /// A ``RelatedManga``
    case manga
    
    /// A ``User``
    case creator
}

/// Maps a `MangaRelationshipType` to its respective struct.
public enum MangaRelationship: Decodable, Equatable, Hashable {
    /// ``MangaRelationshipType/author``
    case author(Author)
    
    /// ``MangaRelationshipType/artist``
    case artist(Author)
    
    /// ``MangaRelationshipType/cover_art``
    case cover_art(Cover)
    
    /// ``MangaRelationshipType/manga``
    case manga(RelatedManga)
    
    /// ``MangaRelationshipType/creator``
    case creator(User)
    
    /// The base coding keys for this type.
    private enum CodingKeys: CodingKey {
        case id, type, attributes, relationships, related
    }
    
    /// The nested coding keys found through the attributes keypath.
    ///
    /// Includes all attribute coding keys for the author, cover, related manga, and user structs.
    private enum AttributesCodingKeys: CodingKey {
        case name, imageUrl, biography, twitter, pixiv, melonBook, fanBox, booth, nicoVideo, skeb, fantia, tumblr, youtube, weibo, naver, namicomi, website, volume, fileName, description, locale, createdAt, updatedAt, version, username, roles
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created MangaRelationship from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if a MangaRelationship cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let relationshipType = try container.decode(MangaRelationshipType.self, forKey: .type)
        
        switch relationshipType {
        case .author:
            self = .author(try Author(from: decoder))
        case .artist:
            self = .artist(try Author(from: decoder))
        case .cover_art:
            self = .cover_art(try Cover(from: decoder))
        case .manga:
            self = .manga(try RelatedManga(from: decoder))
        case .creator:
            self = .creator(try User(from: decoder))
        }
    }
}
