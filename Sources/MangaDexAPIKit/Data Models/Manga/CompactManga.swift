//
//  CompactManga.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// A Manga that does not include any relationships.
///
/// This type is required for decoding the reference expansion of an author or artist. Since ``Manga`` are designed to alwyas fetch their expanded
/// references simply using a manga type to decode an author's reference expansion will cause a crash.
/// A compact manga can be used to create a stored manga instance given that its references are supplied to the initialized.
///
/// ### See
/// [MangaDex API Documentation](https://api.mangadex.org/docs/redoc.html#tag/Manga/operation/get-manga-id)
public struct CompactManga: Decodable, Equatable, Hashable, Identifiable, Sendable {
    /// A unique id assigned to a manga.
    public let id: UUID
    
    /// The name of a manga.
    ///
    /// - Note: This value is returned as a localized string, the key for `"title"` is usually `"en"`.
    ///
    public let title: [String: String]
    
    /// A collection of localized titles for a manga.
    public let altTitles: [[String: String]]
    
    /// A collection of localized descriptions of a manga.
    public let description: [String: String]
    
    /// Whether of not this manga is locked.
    public let isLocked: Bool
    
    /// Links to manga trackers, and official sources.
    public let links: MangaLink
    
    /// The original language of a manga.
    public let originalLanguage: String
    
    /// The final volume of a manga.
    public let lastVolume: String?
    
    /// The final chapter of a manga.
    ///
    /// - Note: Volume extras, and other bonus content can appear after the final chapter.
    public let lastChapter: String?
    
    /// The target audience of a manga.
    ///
    /// ### See
    /// ``Demographic``
    public let publicationDemographic: Demographic?

    /// The current publication status of a manga.
    ///
    /// ### See
    /// ``Status``
    public let status: Status
    
    /// The year a manga was first published,
    public  let year: Int?
    
    /// The maturity rating of a manga.
    ///
    /// ### See
    /// ``Rating``
    public let contentRating: Rating
    
    /// A boolean describing whether the first  chapter in a volume  is denoted "Ch. 1".
    public let chapterNumbersResetOnNewVolume: Bool
    
    /// A collection of languages a manga has been translated to.
    public let availableTranslatedLanguages: [String]
    
    /// The most recent chapter of a manga.
    public let latestUploadedChapter: UUID?
    
    /// A collection of tags describing the genres, themes, and content in a manga.
    public let tags: [Tag]
    
    /// The type of publication for a manga.
    public let state: String
    
    /// The date a manga was uploaded to MangaDex.
    public let createdAt: Date
    
    /// The data a manga was last modified.
    public let updatedAt: Date
    
    /// A number describing the version of a manga.
    public let version: Int
    
    /// The base coding keys for this struct.
    private enum CodingKeys: CodingKey {
        case id, attributes
    }
    
    /// The nested coding keys found through the attributes keypath.
    private enum AttributeCodingKeys: CodingKey {
        case title, altTitles, description, isLocked, links, originalLanguage, lastVolume, lastChapter, publicationDemographic, status, year, contentRating, tags, state, chapterNumbersResetOnNewVolume, createdAt, updatedAt, version, availableTranslatedLanguages, latestUploadedChapter
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created `CompactManga` from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if an CompactManga cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        
        let attributesContainer = try container.nestedContainer(keyedBy: AttributeCodingKeys.self, forKey: .attributes)
        self.title = try attributesContainer.decode([String: String].self, forKey: .title)
        self.altTitles = try attributesContainer.decode([[String: String]].self, forKey: .altTitles)
        self.description = try attributesContainer.decode([String: String].self, forKey: .description)
        self.isLocked = try attributesContainer.decode(Bool.self, forKey: .isLocked)
        self.links = try attributesContainer.decode(MangaLink.self, forKey: .links)
        self.originalLanguage = try attributesContainer.decode(String.self, forKey: .originalLanguage)
        self.lastVolume = try attributesContainer.decodeIfPresent(String.self, forKey: .lastVolume)
        self.lastChapter = try attributesContainer.decodeIfPresent(String.self, forKey: .lastChapter)
        self.publicationDemographic = try attributesContainer.decodeIfPresent(Demographic.self, forKey: .publicationDemographic)
        self.status = try attributesContainer.decode(Status.self, forKey: .status)
        self.year = try attributesContainer.decodeIfPresent(Int.self, forKey: .year)
        self.contentRating = Rating(rawValue: try attributesContainer.decode(String.self, forKey: .contentRating))!
        self.tags = try attributesContainer.decode([Tag].self, forKey: .tags)
        self.state = try attributesContainer.decode(String.self, forKey: .state)
        self.chapterNumbersResetOnNewVolume = try attributesContainer.decode(Bool.self, forKey: .chapterNumbersResetOnNewVolume)
        self.createdAt = try attributesContainer.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try attributesContainer.decode(Date.self, forKey: .updatedAt)
        
        self.version = try attributesContainer.decode(Int.self, forKey: .version)
        self.availableTranslatedLanguages = try attributesContainer.decode([String].self, forKey: .availableTranslatedLanguages)
        self.latestUploadedChapter = try attributesContainer.decodeIfPresent(UUID.self, forKey: .latestUploadedChapter)
    }
    
    public static func == (lhs: CompactManga, rhs: CompactManga) -> Bool {
        return lhs.id == rhs.id && lhs.updatedAt == rhs.updatedAt
    }
}


