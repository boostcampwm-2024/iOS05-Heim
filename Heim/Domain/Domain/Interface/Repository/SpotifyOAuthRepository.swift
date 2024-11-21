//
//  SpotifyOAuthRepository.swift
//  Domain
//
//  Created by 정지용 on 11/21/24.
//

import Foundation

public protocol SpotifyOAuthRepository {
  func createAuthorizationURL(codeChallenge: String) throws -> URL?
  func exchangeAccessToken(
    with code: String,
    codeVerifier: String
  ) async throws -> Bool
}
