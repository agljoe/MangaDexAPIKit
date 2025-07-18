//
//  CustomFeedEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-04-03.
//

import Foundation

/// An entity representing the necessary components for fetching chapters for a specifed custom manga feed.
struct CustomFeedEntity: Expandable, List {
    /// The UUID of the custom feed to fetch from.
    let id: UUID
    
    /// The maximum size of the returned collection, must be in range 0...500.
    let limit: Int
    
    /// The number of items the retuned collection is shifted from the latest available chapter in this feed.
    ///
    /// ### See
    /// [Pagnation](https://api.mangadex.org/docs/01-concepts/pagination/)
    let offset: Int
    
    let expansions: [ChapterReferenceExpansion]
    
    /// Creates a new instance with the given UUID.
    ///
    /// - Parameters:
    ///   - id: the UUID of the feed to fetch from.
    ///   - limit: the number of chapters to fetch, 100 by default.
    ///   - offset: the starting index of the colleciton, 0 by default.
    ///   - expansions: the references to expand the data of.
    ///
    /// - Returns: a newly created `CustomFeedEnttiy` for the given custom feed UUID.
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
        components.path = "list/\(id.uuidString.lowercased())/feed"
        
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
        
        if let exclucedOriginalLanuage = UserDefaults.standard.array(forKey: "excludedOriginalLanguage") as? [String] {
            components.queryItems?.append(contentsOf: exclucedOriginalLanuage.map {
                URLQueryItem(name: "excludedOriginalLanguage[]", value: $0)
            })
        }
        
        if let contentRating = UserDefaults.standard.object(forKey: "contentRating") as? Rating {
            components.queryItems?.append(contentsOf: contentRating.value)
        }
        
        if let excludedGroups = UserDefaults.standard.array(forKey: "excludedGroups") as? [String] {
            components.queryItems?.append(contentsOf: excludedGroups.map {
                URLQueryItem(name: "excludedGroups[]", value: $0)
            })
        }
        
        if let excludedUploades = UserDefaults.standard.array(forKey: "excludedUploaders") as? [String] {
            components.queryItems?.append(contentsOf: excludedUploades.map {
                URLQueryItem(name: "excludingUploaders[]", value: $0)
            })
        }
        
        components.queryItems?.append(URLQueryItem(name: "order[readableAt]", value: Order.desc.rawValue))
        
        components.queryItems?.append(contentsOf: expansions.map {
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        })
        
        return components.url!
    }
    
    var requiresAuthentication: Bool { true }
}
