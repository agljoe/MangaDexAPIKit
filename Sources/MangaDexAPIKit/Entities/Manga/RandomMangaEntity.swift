//
//  RandomMangaEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-03-31.
//

import Foundation

/// An entity representing the necessary components for fetching a random manga.
struct RandomMangaEntity: MangaDexAPIEntity, Expandable {
    /// The UUIDs of all tags the returned manga can include.
    let includedTags: [UUID]
    
    /// How tag inclusion is applied.
    let includedTagsMode: IncludedTagsMode
    
    /// The UUIDs of all tags the returned manga cannot include.
    let excludedTags: [UUID]
    
    /// How tag exclusion is applied.
    let excludedTagsMode: ExcludedTagsMode
    
    let expansions: [MangaReferenceExpansion]
    
    /// Creates a new instance with the given tag filters, defaults both tag modes to `AND`.
    ///
    /// - Parameters:
    ///   - includedTags: The tags to include with this query.
    ///   - includedTagsMode: How the included tags are applied to the query.
    ///   - excludedTags: The tags excluded by this query.
    ///   - excludedTagsMode: How the excluded tags are applied to the query.
    ///   - expansions: the references to expand the data of.
    ///
    /// - Returns: a newly created `RandomMangaEntity`.
    init(
        includedTags: [UUID] = [],
        includedTagsMode: IncludedTagsMode = .and,
        excludedTags: [UUID] = [],
        excludedTagsMode: ExcludedTagsMode = .and,
        expansions: [MangaReferenceExpansion] =  [.manga, .cover, .author, .artist, .creator]
    ) {
        self.includedTags = includedTags
        self.includedTagsMode = includedTagsMode
        self.excludedTags = excludedTags
        self.excludedTagsMode = excludedTagsMode
        self.expansions = expansions
    }
    
    /// Convience initializer that accpects a variadic list of UUIDs.
    ///
    /// - Parameters:
    ///   - includedTags: The tags to include with this query.
    ///   - includedTagsMode: How the included tags are applied to the query.
    ///   - excludedTags: The tags excluded by this query.
    ///   - excludedTagsMode: How the excluded tags are applied to the query.
    ///   - expansions: the references to expand the data of.
    ///
    /// - Returns: a newly created` RandomMangaEntity`.
    init(
        includedTags: UUID...,
        includedTagsMode: IncludedTagsMode = .and,
        excludedTags: UUID..., excludedTagsMode: ExcludedTagsMode = .and,
        expansions: [MangaReferenceExpansion] =  [.manga, .cover, .author, .artist, .creator]
    ) {
        self.init(
            includedTags: includedTags,
            includedTagsMode: includedTagsMode,
            excludedTags: excludedTags,
            excludedTagsMode: excludedTagsMode,
            expansions: expansions
        )
    }
    
    typealias ModelType = Manga
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/manga/random"
        components.queryItems = expansions.map {
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        }
        
        if let contentRating = Rating(rawValue: UserDefaults.standard.string(forKey: "contentRating") ?? "") {
            components.queryItems?.append(contentsOf: contentRating.value)
        }
        
        if !includedTags.isEmpty {
            components.queryItems?.append(contentsOf: self.includedTags.map {
                URLQueryItem(name: "includedTags[]", value: $0.uuidString.lowercased())
            })
            components.queryItems?.append(URLQueryItem(name: "includedTagsMode", value: self.includedTagsMode.rawValue))
        }
        
        if !excludedTags.isEmpty {
            components.queryItems?.append(contentsOf: self.excludedTags.map {
                URLQueryItem(name: "excludedTags[]", value: $0.uuidString.lowercased())
            })
            components.queryItems?.append(URLQueryItem(name: "excludedTagsMode", value: self.excludedTagsMode.rawValue))
        }
        
        return components.url!
    }
    
    var requiresAuthentication: Bool { false }
}
