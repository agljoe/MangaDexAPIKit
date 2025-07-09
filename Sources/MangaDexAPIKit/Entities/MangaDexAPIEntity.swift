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

/// A `MangaDexAPIEntity` that is a collection of JSON objects.
///
/// - Note: Some grouped requests are not considered lists.
public protocol List: MangaDexAPIEntity {
    /// The desired maximum size of the collection.
    ///
    /// The upper bound of this value may vary between endpoints, but its minimum
    /// value is always 1.
    var limit: Int { get }
    
    /// The number of items the returned collection is shifted from the first item in a collection found at a given endpoint.
    ///
    /// ### See
    /// [Pagnation](https://api.mangadex.org/docs/01-concepts/pagination/)
    var offset: Int { get }
}
