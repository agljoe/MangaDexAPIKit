//
//  ParentManga.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// A value obtained from the reference expansion of a ``Chapter``.
///
/// A chapter's reference expansion includes the data of entire manga. In order to save some memory only specific
/// values are decoded.
///
/// ### See
/// [Reference Expansion](https://api.mangadex.org/docs/01-concepts/reference-expansion/)
public struct ParentManga: Decodable, Equatable, Hashable, Identifiable, Sendable {
    /// A unique UUID assinged to a ``Manga``.
    public let id: UUID
    
    /// The name of a ``Manga``.
    ///
    /// - Note: This value may only be romanized.
    public let title: [String: String]? // TODO: flatten to just string
    
    /// The original language of this manga.
    public let originalLanuage: String?
    
    /// The base coding keys for this struct.
    private enum CodingKeys: String, CodingKey {
        case id, attributes
    }
    
    /// The nested coding keys found through the attributes keypath.
    private enum AttributeCodingKeys: String, CodingKey {
        case title, originalLanguage
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created `ParentManga` from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if a ParentManga cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        
        if container.contains(.attributes) {
            let attributesContainer = try container.nestedContainer(keyedBy: AttributeCodingKeys.self, forKey: .attributes)
            self.title = try attributesContainer.decode([String: String].self, forKey: .title)
            self.originalLanuage = try attributesContainer.decode(String.self, forKey: .originalLanguage)
        } else {
            self.title = nil
            self.originalLanuage = nil
        }
    }
    
    public static func == (lhs: ParentManga, rhs: ParentManga) -> Bool {
         return lhs.id == rhs.id
     }
}

