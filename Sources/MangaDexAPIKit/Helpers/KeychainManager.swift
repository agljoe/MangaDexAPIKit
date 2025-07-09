//
//  KeychainManager.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-12.
//

import Foundation

/// An error that occurs when storing, or retriving values from a KeyChain.
public enum KeychainError: Error {
    /// A user's credentials could not be found in the keychain.
    case userNotFound(user: String)
    
    /// A password cannot be found in the keychain.
    case noPassword
    
    /// A token cannot be found in the keychain.
    case noToken
    
    /// Password data found in the keychain is corrupted or in the wrong/incorrect forma.t
    case unexpectedPasswordData
    
    /// Token data found in the keychain is corrupted or in the wrong/incorrect format.
    case unexpecetedTokenData
    
    /// An unexpeceted error when retrieving data from the keychain.
    case unhandledError(status: OSStatus)
}

extension KeychainError: LocalizedError {
    /// The error description shown to the user when retrieving user data from the keychain fails.
    public var errorDescription: String? {
        switch self {
        case .userNotFound(let user):
            return String(localized: "User: \(user) not found in keychain.")
        case .noPassword:
            return String(localized: "No password found for user.")
        case .noToken:
            return String(localized: "No token found for user.")
        case .unexpectedPasswordData:
            return String(localized: "Unexpected or incorrectly formatted password data found.")
        case .unexpecetedTokenData:
            return String(localized: "Unexpected or incorrectly formatted token data found.")
        case .unhandledError(status: let status):
            return String(localized: "Uhandled error thrown: \(SecCopyErrorMessageString(status, nil)!)")
        }
    }
}

/// An isolated type that handles storage and retireval of a user's credentials.
public actor KeychainManager {
    /// Stores a user's credentials in the keychain.
    ///
    /// - Parameter credentials: a `Credentials` value.
    ///
    /// - Throws: a `KeychainError.unexpectedPasswordData` if the given credentials could not be encrypted.
    /// - Throws: a `KeychainError.unhandledError` if the given credentials could not be stored in the keychain.
    internal static func store(credentials: Credentials) throws {
        guard let password = credentials.password.data(using: String.Encoding.utf8),
                let secret = credentials.client_secret.data(using: String.Encoding.utf8)
        else { throw KeychainError.unexpectedPasswordData }
        
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: credentials.username,
            kSecAttrServer as String: "\(MangaDexAPIBaseURL.org.rawValue)/\(credentials.username)",
            kSecValueData as String: password
        ]
        
        let passwordStatus = SecItemCopyMatching(passwordQuery as CFDictionary, nil)
        if (passwordStatus == errSecItemNotFound) {
            let status = SecItemAdd(passwordQuery as CFDictionary, nil)
            guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        }
        
        let secretQuery: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: credentials.client_id,
            kSecAttrServer as String: "\(MangaDexAPIBaseURL.auth.rawValue)/\(credentials.username)",
            kSecValueData as String: secret
        ]
        
        let secretStatus = SecItemCopyMatching(secretQuery as CFDictionary, nil)
        if (secretStatus == errSecItemNotFound) {
            let status = SecItemAdd(secretQuery as CFDictionary, nil)
            guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        }
        
        UserDefaults.standard.set(credentials.username, forKey: "loggedInUser")
    }
    
    /// Stores a token associated with an account, and its type.
    ///
    /// - Parameters:
    ///   - token: a `Token` value.
    ///   - user: the username of the account associated with this token.
    ///
    /// - Throws: a `KeychainError.unexpectedTokenData` if the given token could not be encrypted.
    /// - Throws: a `KeychainError.unhandledError` if the given token could not be stored in the keychain.
    internal static func store(token: Token, for user: String) throws {
        guard let access = token.access.data(using: String.Encoding.utf8) else { throw KeychainError.unexpecetedTokenData }
        
        let accessQuery: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: "\(user)/\(access)",
            kSecAttrServer as String: "\(MangaDexAPIBaseURL.auth.rawValue)/access",
            kSecValueData as String: access
        ]
        
        let accessStatus = SecItemCopyMatching(accessQuery as CFDictionary, nil)
        if (accessStatus == errSecItemNotFound) {
            let status = SecItemAdd(accessQuery as CFDictionary, nil)
            guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        }
        
        if let token = token.refresh {
            guard let refresh = token.data(using: String.Encoding.utf8) else { throw KeychainError.unexpecetedTokenData }
            
            let refreshQuery: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrAccount as String: "\(user)/\(refresh)",
                kSecAttrServer as String: "\(MangaDexAPIBaseURL.auth.rawValue)/refresh",
                kSecValueData as String: refresh
            ]
            
            let refreshStatus = SecItemCopyMatching(refreshQuery as CFDictionary, nil)
            if (refreshStatus == errSecItemNotFound) {
                let status = SecItemAdd(refreshQuery as CFDictionary, nil)
                guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
            }
        }
    }
    
    /// Retrieves the logged user's credentials from the keychain.
    ///
    /// - Returns: a `Credentials` value containing the logged user's username, password, client ID, and client secret.
    ///
    /// - Throws: `KeyhchainError.noPassword` if no associated password is found.
    /// - Throws: `KeyhchainError.unhandledError` if retrival fails.
    /// - Throws: `KeyhchainError.unexpectedPasswordData` if returned password is not associated with the specified server.
    internal static func get(credentials user: String) throws -> Credentials {
        let passwordQuery: [String: Any] =  [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "\(MangaDexAPIBaseURL.org.rawValue)/\(user)",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var passwordItem: CFTypeRef?
        let passwordStatus = SecItemCopyMatching(passwordQuery as CFDictionary, &passwordItem)
        guard passwordStatus != errSecItemNotFound else { throw KeychainError.noPassword }
        guard passwordStatus == errSecSuccess else { throw KeychainError.unhandledError(status: passwordStatus) }
        
        guard let existingPassword = passwordItem as? [String : Any],
            let passwordData = existingPassword[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingPassword[kSecAttrAccount as String] as? String
        else { throw KeychainError.unexpectedPasswordData }
        
        let secretQuery: [String: Any] =  [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "\(MangaDexAPIBaseURL.auth.rawValue)/\(user)",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var secretItem: CFTypeRef?
        let secretStatus = SecItemCopyMatching(secretQuery as CFDictionary, &secretItem)
        guard secretStatus != errSecItemNotFound else { throw KeychainError.noPassword }
        guard secretStatus == errSecSuccess else { throw KeychainError.unhandledError(status: secretStatus) }
        
        guard let existingSecret = secretItem as? [String : Any],
            let secretData = existingSecret[kSecValueData as String] as? Data,
            let secret = String(data: secretData, encoding: String.Encoding.utf8),
            let clientID = existingSecret[kSecAttrAccount as String] as? String
        else { throw KeychainError.unexpectedPasswordData  }
        
        return Credentials(username: account, password: password, client_id: clientID, client_secret: secret)
    }
    
    /// Retrives a type of token associated with an account.
    ///
    /// - Parameter type: the type for a given token.
    ///
    /// - Throws: `KeyhchainError.noToken` if no associated token is found.
    /// - Throws: `KeyhchainError.unhandledError` if retrival fails.
    /// - Throws: `KeyhchainError.unexpectedTokenData` if returned token is not the correct type.
    ///
    /// - Returns: A unencoded token string.
    internal static func getToken(_ type: TokenType) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "\(MangaDexAPIBaseURL.auth.rawValue)/\(type.rawValue)",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noToken }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingIem = item as? [String : Any],
            let data = existingIem[kSecValueData as String] as? Data,
            let token = String(data: data, encoding: String.Encoding.utf8),
            let _ = existingIem[kSecAttrAccount as String] as? String
        else { throw KeychainError.unexpecetedTokenData }
        
        return token
    }
    
    /// Updates the value of a token in Keychain.
    ///
    /// - Parameters:
    ///   - token: the value of an OAuth token.
    ///   - type: the type for a given token.
    ///   - account: the user associated with a token.
    ///
    ///
    /// - Throws: `KeyhchainError.noToken` if no associated token is found.
    /// - Throws: `KeyhchainError.unhandledError` if updating fails.
    internal static func update(token: String, _ type: TokenType, for account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "\(MangaDexAPIBaseURL.auth.rawValue)/\(type.rawValue)",
        ]
        
        guard let token = token.data(using: String.Encoding.utf8) else { throw KeychainError.unexpecetedTokenData }
        let attributes: [String: Any] = [
            kSecAttrAccount as String: "\(account)/\(type.rawValue)",
            kSecValueData as String: token
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.noToken }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    /// Removes a users credentials from the Keychain.
    ///
    /// - Parameter user: the username of the account whose credentials are being removed.
    ///
    /// - Throws: a `KeychainError.userNotFound` if the specified user's credentials could not be found in the keychain.
    /// - Throws: a `KeychainError.unhandledError` if any items could not be deleted from the keychain.
    public static func remove(credentials user: String) throws {
        guard let user = try? get(credentials: user).username else { throw KeychainError.userNotFound(user: user) }
        
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "\(MangaDexAPIBaseURL.auth.rawValue)/\(user)"
        ]
        
        let passwordStatus = SecItemDelete(passwordQuery as CFDictionary)
        guard passwordStatus == errSecSuccess else { throw KeychainError.unhandledError(status: passwordStatus) }
        
        let secretQuery: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "\(MangaDexAPIBaseURL.auth.rawValue)/\(user)"
        ]
            
        let secretStatus = SecItemDelete(secretQuery as CFDictionary)
        guard secretStatus == errSecSuccess else { throw KeychainError.unhandledError(status: secretStatus) }
        
        let accessQuery: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "\(MangaDexAPIBaseURL.auth.rawValue)/\(TokenType.access.rawValue)"
        
        ]
        
        let accessStatus = SecItemDelete(accessQuery as CFDictionary)
        guard accessStatus == errSecSuccess else { throw KeychainError.unhandledError(status: accessStatus) }
        
        let refreshQuery: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "\(MangaDexAPIBaseURL.auth.rawValue)/\(TokenType.refresh.rawValue)"
        ]
        
        let refreshStatus = SecItemDelete(refreshQuery as CFDictionary)
        guard refreshStatus == errSecSuccess else { throw KeychainError.unhandledError(status: refreshStatus) }
    }
    
    
    /// Removes all items from the Keychain.
    ///
    /// - Warning: This action cannot be undone.
    public static func reset() {
        [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity].forEach {
            let status = SecItemDelete([
                kSecClass: $0,
                kSecAttrSynchronizable: kSecAttrSynchronizableAny
            ] as CFDictionary)
            if status != errSecSuccess && status != errSecItemNotFound {
                print("Error deleting user from keychain")
            }
        }
    }
}
