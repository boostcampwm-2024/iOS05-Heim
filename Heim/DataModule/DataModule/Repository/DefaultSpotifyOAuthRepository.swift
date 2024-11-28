//
//  DefaultSpotifyOAuthRepository.swift
//  DataModule
//
//  Created by 정지용 on 11/21/24.
//

import Domain
import Foundation

public struct DefaultSpotifyOAuthRepository: SpotifyOAuthRepository {
  private let networkProvider: NetworkProvider
  private let tokenManager: TokenManager
  
  public init(
    networkProvider: NetworkProvider,
    tokenManager: TokenManager
  ) {
    self.networkProvider = networkProvider
    self.tokenManager = tokenManager
  }
  
  public func createAuthorizationURL(codeChallenge: String) throws -> URL? {
    return try networkProvider.makeURL(
      target: SpotifyOAuthAPI.authorize(
        dto: SpotifyAuthorizeRequestDTO(
          responseType: "code",
          clientId: SpotifyEnvironment.clientId,
          codeChallengeMethod: "S256",
          codeChallenge: codeChallenge,
          redirectUri: SpotifyEnvironment.redirectURI
        )
      )
    )
  }
  
  public func exchangeAccessToken(
    with code: String,
    codeVerifier: String
  ) async throws {
    let response = try await networkProvider.request(
      target: SpotifyOAuthAPI.accessToken(
        dto: SpotifyAccessTokenRequestDTO(
          clientId: SpotifyEnvironment.clientId,
          grantType: "authorization_code",
          code: code,
          redirectUri: SpotifyEnvironment.redirectURI,
          codeVerifier: codeVerifier
        )
      ),
      type: SpotifyAccessTokenResponseDTO.self
    )
    
    try tokenManager.storeTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      expiresIn: response.expiresIn
    )
  }
}
