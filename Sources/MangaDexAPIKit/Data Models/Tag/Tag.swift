//
//  Tag.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2024-06-18.
//

import Foundation

/// A tag of a manga.
///
/// Tags describe a manga's format, genre, content, and themes.
///
/// ### See
/// [MangaDex Api Documentation](https://api.mangadex.org/docs/redoc.html#tag/Manga/operation/get-manga-tag)
public struct Tag: Codable, Equatable, Hashable, Identifiable, Sendable {
    /// The UUID of a spefic tag.
    ///
    /// For some reason every search filter tag has a unique UUID.
    public let id: UUID
    
    /// The name of this tag.
    public let name: String
    
    /// The group which this tag belongs to.
    public let group: String
    
    /// The base coding keys for this struct.
    private enum CodingKeys: CodingKey {
        case id, attributes
    }
    /// The nested coding keys found through the attributes keypath.
    private enum AttributeCodingKeys: CodingKey {
        case name, group
    }
    
    /// The nested coding key found through the name keypath.
    private enum NameCodingKeys: CodingKey {
        case en
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created `Tag` from the given decoder.
    ///
    /// - Throws: a ` DecodingError` if a Tag cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        
        let attributeContainer = try container.nestedContainer(keyedBy: AttributeCodingKeys.self, forKey: .attributes)
        let nameContainer = try attributeContainer.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        self.name = try nameContainer.decode(String.self, forKey: .en)
        
        self.group = try attributeContainer.decode(String.self, forKey: .group)
    }
    
    /// Encodes a single value with the given encoder.
    ///
    /// - Parameter encoder: the encoder to encode with.
    ///
    /// - Throws: an `EncodingError` if the given value cannot be encoded.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        
        var attributeContainer = container.nestedContainer(keyedBy: AttributeCodingKeys.self, forKey: .attributes)
        var nameContainer = attributeContainer.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        try nameContainer.encode(name, forKey: .en)
        
        try attributeContainer.encode(group, forKey: .group)
    }
    
    public static func ==(lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

