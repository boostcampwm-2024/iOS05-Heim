//
//  DefaultOAuthNetworkProvider.swift
//  NetworkModule
//
//  Created by 정지용 on 11/27/24.
//

import Core
import Domain
import DataModule
import Foundation

public struct DefaultOAuthNetworkProvider: OAuthNetworkProvider {
  private let requestor: NetworkRequestable
  private let tokenManager: TokenManager
  
  public init(
    requestor: NetworkRequestable,
    tokenManager: TokenManager
  ) {
    self.requestor = requestor
    self.tokenManager = tokenManager
  }
  
  @discardableResult
  public func request<T: Decodable>(target: RequestTarget, type: T.Type) async throws -> T {
    try await authentication()
    let request = try target.makeURLRequest(accessToken: try tokenManager.loadAccessToken())
    let (data, response) = try await requestor.data(for: request)
    
    guard let responseDTO = try? JSONDecoder().decode(T.self, from: data) else {
      if let body = request.httpBody,
         let requestBody = String(data: body, encoding: .utf8) {
        Logger.log(message: "Request Body: \(requestBody)")
      }
      if let responseBody = String(data: data, encoding: .utf8) {
        Logger.log(message: "Response Body: \(responseBody)")
      }
      throw NetworkError.interalServerError
    }
    
    return responseDTO
  }
  
  public func makeURL(target: any RequestTarget) throws -> URL? {
    return try target.makeURLRequest().url
  }
}

private extension DefaultOAuthNetworkProvider {
  func authentication() async throws {
    do {
      try tokenManager.isAccessTokenValid()
    } catch TokenError.accessTokenExpired {
      do {
        let refreshToken = try tokenManager.loadRefreshToken()
        try await refresh(token: refreshToken)
      } catch {
        throw TokenError.refreshTokenExpired
      }
    }
  }
  
  func refresh(token: String) async throws {
    let response = try await request(
      target: SpotifyOAuthAPI.refreshToken(
        dto: SpotifyRefreshTokenRequestDTO(
          grantType: "authorization",
          refreshToken: token,
          clientId: SpotifyEnvironment.clientId
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
