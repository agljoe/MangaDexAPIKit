//
//  ChapterRelationship.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// All possible types in a chapters' reference expansion collection.
///
/// ### See
/// [Reference Expansion](https://api.mangadex.org/docs/01-concepts/reference-expansion/)
public enum ChapterRelationshipType: String, Decodable, Sendable {
    /// A ``ScanlationGroup``
    case scanlation_group
    
    /// A ``User``
    case user
    
    /// A ``ParentManga``
    case manga
}

/// Maps a ``ChapterRelationshipType`` to its respective struct.
public enum ChapterRelationship: Decodable, Equatable, Hashable {
    /// ``ChapterRelationshipType/scanlation_group``
    case scanlation_group(ScanlationGroup)
    
    /// ``ChapterRelationshipType/user``
    case user(User)
    
    /// ``ChapterRelationshipType/manga``
    case manga(ParentManga)
    
    /// The base coding keys for this type.
    private enum CodingKeys: CodingKey {
        case id, type, attributes, relationships
    }
    
    /// The nested codingkeys found through the attributes keypath.
    ///
    /// Includes all attribute coding keys for the scanlation group, user, and parent manga structs.
    private enum AttributeCodingKeys: CodingKey {
        case name, username, roles, locked, website, ircServer, ircChannel, discord, contactEmail, description, twitter, mangaUpdates, focusedLanguages, official, verified, inactive, exLisensed, publishDelay, createdAt, updatedAt, version, title, altTitles, originalLanguage
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created ChapterRelationship from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if a ChapterRelationship cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let relationshipType = try container.decode(ChapterRelationshipType.self, forKey: .type)
        
        switch relationshipType {
        case .scanlation_group:
            self = .scanlation_group(try ScanlationGroup(from: decoder))
        case .user:
            self = .user(try User(from: decoder))
        case .manga:
            self = .manga(try ParentManga(from: decoder))
        }
    }
}
