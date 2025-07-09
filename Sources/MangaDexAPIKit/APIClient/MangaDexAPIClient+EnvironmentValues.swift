//
//  File.swift
//  MangaDexAPIKit
//
//  Created by Andrew Joe on 2025-06-17.
//

import Foundation
import SwiftUI

/// If you are an MV rather than MVC/MVVM person you can easly acess an API client using `@Environment`.
public extension EnvironmentValues {
    /// Sets the default value for the request manager interacting with the MangaDexAPI.
    @Entry var apiClient: MangaDexAPIClient = MangaDexAPIClient.shared
}

/// `@Environment(\.apiClient) var mangaDexAPIClient`
public extension View {
    /// Creates a view with a `MangaDexAPIRequestManager` evironment value.
    ///
    /// - Parameter apiClient: any object that conforms to `MangaDexAPIClient`.
    ///
    /// - Returns: a view that can access an API client through its environment values.
    func apiClient(_ apiClient: MangaDexAPIClient) -> some View {
        environment(\.apiClient, apiClient)
    }
}
