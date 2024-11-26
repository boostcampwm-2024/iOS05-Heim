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
  private let tokenStorage: TokenStorage
  
  public init(
    networkProvider: NetworkProvider,
    tokenStorage: TokenStorage
  ) {
    self.networkProvider = networkProvider
    self.tokenStorage = tokenStorage
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
  ) async throws -> Bool {
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
    
    // TODO: Refresh 기능 추가, expires 관리
    return tokenStorage.save(
      token: response.accessToken,
      attrAccount: SpotifyEnvironment.accessTokenAttributeKey
    )
  }
}
