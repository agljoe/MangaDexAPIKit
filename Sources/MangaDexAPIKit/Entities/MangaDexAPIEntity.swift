//
//  MangaDexAPIEntity
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-11.
//

import Foundation

/// JSON encoded data that is fetchable from one of Mangadex's API endpoints.
public protocol MangaDexAPIEntity: Sendable {
    /// A model type that matches the structure of the fetched JSON data.
    associatedtype ModelType: Decodable
    
    /// The endpoint where the associated ``ModelType`` can  be fetched from.
    ///
    /// Some endpoints have an available list of query parameters, for more information check the
    /// [endpoint specifications](https://api.mangadex.org/docs/redoc.html)
    ///
    /// ### See
    /// [Reference Expansion](https://api.mangadex.org/docs/01-concepts/reference-expansion/)
    var url: URL { get }
    
    /// Indicates if a user's access token will be passed in the Bearer(token) Authorization header.
    var requiresAuthentication: Bool { get }
}
