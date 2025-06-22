//
//  File.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-12.
//

import Foundation

/// Some JSON data containing up to two OAuth tokens, one for accessing authenitcated calls, and one for obtaining access tokens.
struct TokenEntity: MangaDexAPIEntity {
    typealias ModelType = Token?
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Server.auth.rawValue
        components.path = "/realms/mangadex/protocol/openid-connect/token"
        return components.url!
    }
    
    var requiresAuthentication: Bool { true }
}
