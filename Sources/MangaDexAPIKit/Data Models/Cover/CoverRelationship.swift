//
//  CoverRelationship.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// An object found in the referenece expansion collection of a ``Cover``.
///
/// ### See
/// [Reference Expansion](https://api.mangadex.org/docs/01-concepts/reference-expansion/)
public struct CoverRelationship: Decodable, Equatable, Hashable, Identifiable, Sendable {
    /// A unique id.
    ///
    /// - Note: This is the UUID of a user or manga.
    public let id: UUID
    
    /// The type of this relationship.
    public let type: String
    
    /// The base coding keys for this struct.
    private enum CodingKeys: CodingKey {
        case id, type
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created CoverRelationship from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if a CoverRelationship cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.type = try container.decode(String.self, forKey: .type)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}


