//
//  ScanlationGroupEntity.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-05-02.
//

import Foundation

/// All possible values that can be expanded when retrieving the data of a scanlation group.
public enum ScanlationGroupReferenceExpansion: String, ReferenceExpansion {
    /// The leader of a scanlation group.
    case leader = "leader"
    
    /// All members of a scanlation group.
    case member = "member"
}

public extension Array where Element == ScanlationGroupReferenceExpansion {
    /// All available reference expansions at a /group endpoint.
    static var all: Self { ScanlationGroupReferenceExpansion.allCases }
    
    /// Indicates that a scanlation group's references will not be expanded.
    static var none: Self { [] }
}

/// Represents the necessary components for fetching a specific scanlation group.
struct ScanlationGroupEntity: MangaDexAPIEntity, Expandable {
    /// The UUID of the scanlation group being retrieved.
    let id: UUID
    
    typealias ModelType = ScanlationGroup
    
    let expansions: [ScanlationGroupReferenceExpansion] = .all
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = MangaDexAPIBaseURL.org.rawValue
        components.path = "/group/\(id.uuidString.lowercased())/"
        
        components.queryItems = expansions.map {
            URLQueryItem(name: "includes[]", value: $0.rawValue)
        }
        
        return components.url!
    }
    
    var requiresAuthentication: Bool { false}
}
