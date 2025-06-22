//
//  AuthorRelationship.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// An type of object that can be found in an author or artist's reference expansion.
///
/// This enum contains all available author reference expansions, but it does not inidicate if they will be returned when
/// requesting data.
public enum AuthorRelationshipType: String, Decodable {
    /// A ``Manga``
    case manga
}

/// Dyncamically decodes JSON objects based on their associated `AuthorRelationShipType`
public enum AuthorRelationship: Decodable, Equatable, Hashable {
    /// Decode as an `AuthorRelationshipType.manga`.
    case manga(CompactManga?)
    
    /// The base coding keys for this type.
    private enum CodingKeys: CodingKey {
        case id, type, attributes
    }
    
    /// The nested coding keys found through the attributes keypath.
    ///
    /// Includes all the same attribute coding keys as a Manga.
    private enum AttributeCodingKeys: CodingKey {
        case title, altTitles, description, isLocked, links, originalLanguage, lastVolume, lastChapter, publicationDemographic, status, year, contentRating, tags, state, chapterNumbersResetOnNewVolume, createdAt, updatedAt, version, availableTranslatedLanguages, latestUploadedChapter
    }
    
    /// Creates a new instance by decoding from the given decoer.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created AuthorRelationship from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if an AuthorRelationship cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let relationshipType = try container.decode(AuthorRelationshipType.self, forKey: .type)
        switch relationshipType { case .manga: self = .manga(try? CompactManga(from: decoder)) }
    }
}
