//
//  Chapter.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2024-06-11.
//

import Foundation

/// A chapter of a manga.
///
///  Chapter objects returned by the MangaDex do not include chapter images. See [Find a Manga's Chapters](https://api.mangadex.org/docs/04-chapter/feed/).
///
/// - Note: This structure's types are made to match the JSON data structure provided in the MangaDexAPI documentation, where
///         optionals are used to represent values that can be null.
///
///  ### See
///  [MangaDex API Documentation](https://api.mangadex.org/docs/redoc.html#tag/Chapter/operation/get-chapter-id)
public struct Chapter: Decodable, Identifiable, Sendable {
    /// A unique id assigned to a chapter.
    public let id: UUID
    
    /// The name of this chapter
    public let title: String?
    
    /// The volume a chapter belongs to.
    public let volume: String?
    
    /// A chapter's number.
    public let chapter: String?
    
    /// The number of pages in a chapter.
    public let pages: Int
    
    /// The language a chapter is in.
    public let translatedLanguage: String
    
    /// A chapter that links to an eternal source.
    public let externalURL: String?
    
    /// A number describing the how many times this chapter has been updated
    public let version: Int
    
    /// The date a chapter was uploaded to MangaDex.
    public let createdAt: Date
    
    /// The date a chapter was last modified.
    public let updatedAt: Date
    
    /// The date a chapter was published.
    public let publishAt: Date
    
    /// The date a chapter was available to read.
    public let readableAt: Date
    
    /// A group of people who translated this chapter.
    public let scanlationGroup: ScanlationGroup?
    
    /// The user who uploaded this chapter.
    public let user: User?
    
    /// The manga a chapter is from.
    public let parentManga: ParentManga?
    
    /// The base coding keys for this struct.
    private enum CodingKeys: String, CodingKey {
        case id, attributes, relationships
    }
    
    /// The nested coding keys found through the attributes keypath.
    private enum AttributeCodingKeys: String, CodingKey {
        case title, volume, chapter, pages, translatedLanguage, externalUrl, version, createdAt, updatedAt, publishAt, readableAt
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created `Chapter` from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if a Chapter cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        
        let attributesContainer = try container.nestedContainer(keyedBy: AttributeCodingKeys.self, forKey: .attributes)
        self.title = try attributesContainer.decodeIfPresent(String.self, forKey: .title)
        self.volume = try attributesContainer.decodeIfPresent(String.self, forKey: .volume)
        self.chapter = try attributesContainer.decodeIfPresent(String.self, forKey: .chapter)
        self.pages = try attributesContainer.decode(Int.self, forKey: .pages)
        self.translatedLanguage = try attributesContainer.decode(String.self, forKey: .translatedLanguage)
        self.externalURL = try attributesContainer.decodeIfPresent(String.self, forKey: .externalUrl)
        self.version = try attributesContainer.decode(Int.self, forKey: .version)
        self.createdAt = try attributesContainer.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try attributesContainer.decode(Date.self, forKey: .updatedAt)
        self.publishAt = try attributesContainer.decode(Date.self, forKey: .publishAt)
        self.readableAt = try attributesContainer.decode(Date.self, forKey: .readableAt)
        
        var scanlationGroup: ScanlationGroup?
        var uploader: User?
        var parentManga: ParentManga?
        
        do {
            let relationships = try container.decodeIfPresent([ChapterRelationship].self, forKey: .relationships)
            for relationship in relationships ?? [ChapterRelationship]() {
                switch relationship {
                case .scanlation_group(let scanlation_group):
                    scanlationGroup = scanlation_group
                case .user(let user):
                    uploader = user
                case .manga(let manga):
                    parentManga = manga
                }
            }
        }
        
        self.scanlationGroup = scanlationGroup ?? nil
        self.user = uploader ?? nil
        self.parentManga = parentManga ?? nil
    }
    
    public static func == (lhs: Chapter, rhs: Chapter) -> Bool {
        return lhs.id == rhs.id && lhs.updatedAt == rhs.updatedAt
    }
}
