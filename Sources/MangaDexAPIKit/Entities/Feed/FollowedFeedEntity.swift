//
//  FollowedFeedEntity.swift
//  Yomu
//
//  Created by Andrew Joe on 2025-04-04.
//

import Foundation

/// An entity representing the necesary components for fetching chapters from a user's followed manga feed.
struct FollowedFeedEntity: Expandable, List {
    /// The maximum size of the returned collection, must be in range 0...500.
    let limit: Int
    
    /// The number of items the retuned collection is shifted from the latest available chapter in this feed.
    ///
    /// ### See
    /// [Pagnation](https://api.mangadex.org/docs/01-concepts/pagination/)
    let offset: Int
    
    let expansions: [ChapterReferenceExpansion]
    
    /// Creates a new instance with default values.
    ///
    /// - Parameters:
    ///   - limit: the number of chapters to fetch, 100 by default.
    ///   - offset: the starting index of the colleciton, 0 by default.
    ///   - expansions: the references to expand the data of.
    ///
    /// - Returns: a newly created `FollowedFeedEntity`.
    init(
        limit: Int = 100,
        offset: Int = 0,
        expansions: [ChapterReferenceExpansion] = .all
    ) {
        self.limit = limit
        self.offset = offset
        self.expansions = expansions
    }
    
    typealias ModelType = [Chapter]
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/user/follows/manga/feed"
        
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        
        if let translatedLanuage = UserDefaults.standard.array(forKey: "translatedLanguage") as? [String] {
            components.queryItems?.append(contentsOf: translatedLanuage.map {
                URLQueryItem(name: "translatedLanguage[]", value: $0)
            })
        } else {
            components.queryItems?.append(URLQueryItem(name: "translatedLanguage[]", value: "en"))
        }
        
        if let orginalLanuage = UserDefaults.standard.array(forKey: "originalLanguage") as? [String] {
            components.queryItems?.append(contentsOf: orginalLanuage.map {
                URLQueryItem(name: "originalLanguage[]", value: $0)
            })
        }
        
        if let excludedOriginalLanuage = UserDefaults.standard.array(forKey: "excludedOriginalLanguage") as? [String] {
            components.queryItems?.append(contentsOf: excludedOriginalLanuage.map {
                URLQueryItem(name: "excludedOriginalLanguage[]", value: $0)
            })
        }
        
        if let contentRating = UserDefaults.standard.string(forKey: "contentRating") {
            components.queryItems?.append(contentsOf: Rating(rawValue: contentRating)?.value ?? Rating.safe.value)
        }
        
        if let excludedGroups = UserDefaults.standard.array(forKey: "excludedGroups") as? [String] {
            components.queryItems?.append(contentsOf: excludedGroups.map {
                URLQueryItem(name: "excludedGroups[]", value: $0)
            })
        }
        
        if let excludedUploaders = UserDefaults.standard.array(forKey: "excludedUploaders") as? [String] {
            components.queryItems?.append(contentsOf: excludedUploaders.map {
                URLQueryItem(name: "excludedUploaders[]", value: $0)
            })
        }
        
        /// - Note: this weird ordering/ formating is just to stay in the same order that parameters are listed in the official documentation, which makes it
        ///         easier for me to read.
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "order[publishAt]", value: Order.desc.rawValue)
        ])
        
        components.queryItems?.append(contentsOf: expansions.map {
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        })
        
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "includeExternalUrl", value: "1"),
            URLQueryItem(name: "includeUnavailable", value: "0")
        ])
        
        return components.url!
    }
    
    var requiresAuthentication: Bool { true }
}
