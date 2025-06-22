//
//  User.swift
//  Yomu
//
//  Created by Andrew Joe on 2024-06-04.
//

import Foundation


/// A MangaDex user.
///
/// The primary use of user types will be to display the uploader of a chapter.
///
/// ### See
/// [MangaDex Api Documentation](https://api.mangadex.org/docs/redoc.html#tag/User/operation/get-user-id)
public struct User: Identifiable, Equatable, Hashable, Decodable, Sendable {
    /// The UUID of this user.
    public let id: UUID
    
    /// The name of this user.
    ///
    /// This value should be unchangable.
    public let username: String
    
    /// The roles this user has in their respective scanlation group, or as a MangaDex staff.
    public let roles: [String]
    
    /// The number of times this user has been updatedl
    public let version: Int
    
    public let relationships: [UserRealtionship]
    
    /// The base coding keys for this struct.
    private enum CodingKeys: CodingKey {
        case id, attributes, relationships
    }
    
    /// The nested coding keys found through the attributes keypath.
    private enum AttributeCodingKeys: CodingKey {
        case username, roles, version
    }
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: the decoder to read data from.
    ///
    /// - Returns: a newly created User from the given decoder.
    ///
    /// - Throws: a ` DeodingError` if a User cannot be initialized by the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        
        let attributesContainer = try container.nestedContainer(keyedBy: AttributeCodingKeys.self, forKey: .attributes)
        self.username = try attributesContainer.decode(String.self, forKey: .username)
        self.roles = try attributesContainer.decode([String].self, forKey: .roles)
        self.version = try attributesContainer.decode(Int.self, forKey: .version)
        
        self.relationships = try container.decodeIfPresent([UserRealtionship].self, forKey: .relationships) ?? []
    }
    
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}


/// A wrapper around the relationship object implicity included in a user's reference expansion
public struct UserRealtionship: Decodable, Equatable, Hashable, Sendable {
    /// The UUID of a scanlation group.
    public let id: UUID
    
    /// A string that should always have the value "scanlation_group"
    public let type: String
    
    public static func == (lhs: UserRealtionship, rhs: UserRealtionship) -> Bool { lhs.id == rhs.id }
}
