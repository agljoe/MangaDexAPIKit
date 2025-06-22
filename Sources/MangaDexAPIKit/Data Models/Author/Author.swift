//
//  Author.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2024-06-11.
//

import Foundation

/// An author or artist of a manga.
///
///  MangaDex only makes a distinction between authors, and artists with a type string.
///  The endpoint, and JSON struction is otherwise identical.
///
/// - Note: This structure's types are made to match the JSON data structure provided in the MangaDexAPI documentation, where
///          optionals are used to represent values that can be null.
///
/// ### See
/// [MangaDex Api Documentation](https://api.mangadex.org/docs/redoc.html#tag/Author/operation/get-author-id)
public struct Author: Decodable, Equatable, Hashable, Identifiable, Sendable {
    /// A unique id assigned to an author or arist.
    public let id: UUID
    
    /// Indicates if this is an author or artist.s
    public let type: String
    
    /// An author or artists full or pen name.
    ///
    /// - Note: Artist and author names given in romanji (romanized Japanese).
    public let name: String
    
    /// An image of an author or artist.
    ///
    /// - Note: MangaDex currently does not support profile pictures, so this value may not exist.
    public let imageURL: String?
    
    /// A brief description of an author or artist.
    ///
    /// - Note: An author or artist's biography may not be avialable in all languages.
    public let biography: [String: String]
    
    /// A link to an author or artist's Twitter page.
    public let twitter: String?

    /// A link to an author or artist's pixiv page.
    public let pixiv: String?
    
    /// A link to an author or artist's Melonbooks page.
    public let melonBook: String?
    
    /// A link to an author or artist's pixivFANBOX page.
    public let fanBox: String?
    
    /// A link to an author or artist's BOOTH page.
    public let booth: String?
    
    /// A link to an author or artist's Niconico channel.
    public let nicoVideo: String?
    
    /// A link to an author or artist's Skeb page.
    public let skeb: String?
    
    /// A link to an author or artist's Fantia page.
    public let fantia: String?
    
    /// A link to an author or artist's Tumblr page.
    public let tumblr: String?
    
    /// A link to an author or artist's YouTube channel.
    public let youtube: String?
    
    /// A link to an author or artist's Weibo page.
    public let weibo: String?
    
    /// A link to an author or artist's Naver page.
    public let naver: String?
    
    /// A link to an author or artist's NamiComi page.
    public let namicomi: String?
    
    /// A link to an author or artist's personal website.
    public let website: String?
    
    /// The date an author or artist's page was uploaded to MangaDex.
    public let createdAt: Date
    
    /// The date an author or artist's page was last modified.
    public let updatedAt: Date
    
    /// A number describing the number of updates an author or has had.
    public let version: Int
    
    /// An collection of manga by this author or artist.
    public let relatedManga: [CompactManga]?
    
    /// The base coding keys for this struct.
    private enum CodingKeys: CodingKey {
        case id, type, attributes, relationships
    }
    
    /// The nested coding keys found through the attributes keypath.
    private enum AttributesCodingKeys: CodingKey {
        case name, imageUrl, biography, twitter, pixiv, melonBook, fanBox, booth, nicoVideo, skeb, fantia, tumblr, youtube, weibo, naver, namicomi, website, createdAt, updatedAt, version
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created `Author` from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if an Author cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.type = try container.decode(String.self, forKey: .type)
        
        let attributesContainer = try container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
        self.name = try attributesContainer.decode(String.self, forKey: .name)
        self.imageURL = try attributesContainer.decodeIfPresent(String.self, forKey: .imageUrl)
        self.biography = try attributesContainer.decode([String: String].self, forKey: .biography)
        self.twitter = try attributesContainer.decodeIfPresent(String.self, forKey: .twitter)
        self.pixiv = try attributesContainer.decodeIfPresent(String.self, forKey: .pixiv)
        self.melonBook = try attributesContainer.decodeIfPresent(String.self, forKey: .melonBook)
        self.fanBox = try attributesContainer.decodeIfPresent(String.self, forKey: .fanBox)
        self.booth = try attributesContainer.decodeIfPresent(String.self, forKey: .booth)
        self.nicoVideo = try attributesContainer.decodeIfPresent(String.self, forKey: .nicoVideo)
        self.skeb = try attributesContainer.decodeIfPresent(String.self, forKey: .skeb)
        self.fantia = try attributesContainer.decodeIfPresent(String.self, forKey: .fantia)
        self.tumblr = try attributesContainer.decodeIfPresent(String.self, forKey: .tumblr)
        self.youtube = try attributesContainer.decodeIfPresent(String.self, forKey: .youtube)
        self.weibo = try attributesContainer.decodeIfPresent(String.self, forKey: .weibo)
        self.naver = try attributesContainer.decodeIfPresent(String.self, forKey: .naver)
        self.namicomi = try attributesContainer.decodeIfPresent(String.self, forKey: .namicomi)
        self.website = try attributesContainer.decodeIfPresent(String.self, forKey: .website)
        self.createdAt = try attributesContainer.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try attributesContainer.decode(Date.self, forKey: .updatedAt)
        
        self.version = try attributesContainer.decode(Int.self, forKey: .version)
        
        var manga: [CompactManga?] = []
        
        do {
            let relationships = try container.decodeIfPresent([AuthorRelationship].self, forKey: .relationships)
            for relationship in relationships ?? [AuthorRelationship]() {
                switch relationship { case .manga(let relatedManga): manga.append(relatedManga) }
            }
        }
        
        self.relatedManga = manga.compactMap({ $0 })
    }

    
    public static func == (lhs: Author, rhs: Author) -> Bool {
        return lhs.id == rhs.id && lhs.updatedAt == rhs.updatedAt
    }
}

