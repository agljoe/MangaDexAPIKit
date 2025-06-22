//
//  Cover.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2024-06-24.
//

import Foundation

/// The cover of a manga's latest volume.
///
/// - Important: The cover image is found at the ``Cover/fileName`` endpoint.
///
/// ### See
/// [MangaDex API Documentation](https://api.mangadex.org/docs/redoc.html#tag/Cover)
public struct Cover: Decodable, Equatable, Hashable, Identifiable, Sendable {
    /// A unique id assigned to a cover.
    public let id: UUID
    
    /// The volume this is the cover of.
    public let volume: String?
    
    /// A path to a cover image.
    public let fileName: String
    
    /// A small text describing a cover.
    public let description: String?
    
    /// A time or place a cover is set in.
    public let locale: String?
    
    /// A number desctibing the version of a cover.
    public let version: Int
    
    /// The date a cover was uploaded to MangaDex.
    public let createdAt: Date
    
    /// The date a cover was last modified.
    public let updatedAt: Date
    
    /// A collection of objects related to a cover
    ///
    /// Unlike other structures, objects found in a cover's reference expainsion all have the same structure.
    ///  See ``CoverRelationship``.
    public let relationships: [CoverRelationship]?
    
    /// The base coding keys for this struct.
    private enum CodingKeys: CodingKey {
        case id, attributes, relationships
    }
    
    /// The nested coding keys found through the attributes keypath
    private enum AttributeCodingKeys: CodingKey {
        case volume, fileName, description, locale, version, createdAt, updatedAt
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created` Cover` from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if a cover cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        
        let attributesContainer = try container.nestedContainer(keyedBy: AttributeCodingKeys.self, forKey: .attributes)
        self.volume = try attributesContainer.decodeIfPresent(String.self, forKey: .volume)
        self.fileName = try attributesContainer.decode(String.self, forKey: .fileName)
        self.description = try attributesContainer.decodeIfPresent(String.self, forKey: .description)
        self.locale = try attributesContainer.decodeIfPresent(String.self, forKey: .locale)
        self.version = try attributesContainer.decode(Int.self, forKey: .version)
        self.createdAt = try attributesContainer.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try attributesContainer.decode(Date.self, forKey: .updatedAt)
        
        self.relationships = try container.decodeIfPresent([CoverRelationship].self, forKey: .relationships)
    }
    
    public static func == (lhs: Cover, rhs: Cover) -> Bool {
        return lhs.id == rhs.id && lhs.updatedAt == rhs.updatedAt
    }
}
