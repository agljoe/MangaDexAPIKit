//
//  MangaFeedEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-04-01.
//

import Foundation

/// An entity representing the necessary components for fetching the chapters of a specified manga.
struct MangaFeedEntity: MangaDexAPIEntity, Expandable {
    /// The UUID of the manga whose chapters are being retrieved.
    let id: UUID
    
    /// The number of chapters to fetch, if this number is larger than
    /// the amount of available chapters the returned collection is simply all available
    /// chapters. This value must be in range 0...500.
    ///
    /// - Note: This value does not represent the true number of chapter in a manga, rather it
    ///         is the total number of availble chapters within the given filters, including multple languages
    ///         or duplicates.
    let limit: Int
    
    /// The number of chapters this collection is shifted from the latest chapter.
    ///
    /// ### See
    /// [Pagnation](https://api.mangadex.org/docs/01-concepts/pagination/)
    let offset: Int
    
    let expansions: [ChapterReferenceExpansion]
    
    /// Creates a new instance with the specified UUID.
    ///
    /// - Parameters:
    ///     - id:  the UUID of the manga whose chapters being fetched.
    ///     - limit: the number of chapters to fetch.
    ///     - offset: the chapter number this collection will start at.
    ///     - expansions: the references to expand the data of.
    ///
    /// - Returns: a newly created` MangaFeedEntity` for the given feed UUID.
    init(
        id: UUID,
        limit: Int = 100,
        offset: Int = 0,
        expansions: [ChapterReferenceExpansion] = .all
    ) {
        self.id = id
        self.limit = limit
        self.offset = offset
        self.expansions = expansions
    }
    
    typealias ModelType = [Chapter]
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/manga/\(id.uuidString.lowercased())/feed"
        
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")]
        
        if let translatedLanguage = UserDefaults.standard.array(forKey: "translatedLanguagee") as? [String] {
            components.queryItems?.append(contentsOf: translatedLanguage.map {
                URLQueryItem(name: "translatedLanguage[]", value: $0)
            })
        } else {
            components.queryItems?.append(URLQueryItem(name: "translatedLanguage[]", value: "en"))
        }
        
        if let excludedGroups = UserDefaults.standard.array(forKey: "excludedGroupd") as? [String] {
            components.queryItems?.append(contentsOf: excludedGroups.map {
                URLQueryItem(name: "excludedGroups[]", value: $0)
            })
        }
        
        if let excludedUploaders = UserDefaults.standard.array(forKey: "excludedUploaders") as? [String] {
            components.queryItems?.append(contentsOf: excludedUploaders.map {
                URLQueryItem(name: "excludedUploaders[]", value: $0)
            })
        }
        
        components.queryItems?.append(URLQueryItem(name: "order[chapter]", value: Order.desc.rawValue))
        
        components.queryItems?.append(contentsOf: expansions.map {
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        })
        
        return components.url!
    }
    
    var requiresAuthentication: Bool { false }
}
