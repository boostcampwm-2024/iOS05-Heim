//
//  SpotifyOAuthAPI.swift
//  DataModule
//
//  Created by 정지용 on 11/13/24.
//

import Domain
import Foundation

public enum SpotifyOAuthAPI {
  case authorize(dto: SpotifyAuthorizeRequestDTO)
  case accessToken(dto: SpotifyAccessTokenRequestDTO)
  case refreshToken(dto: SpotifyRefreshTokenRequestDTO)
}

extension SpotifyOAuthAPI: RequestTarget {
  public var baseURL: String {
    return "\(SpotifyEnvironment.oauthBaseURL)"
  }
  
  public var path: String {
    switch self {
    case .authorize: "/authorize"
    case .accessToken: "/api/token"
    case .refreshToken: "/api/token"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .authorize: .get
    case .accessToken: .post
    case .refreshToken: .post
    }
  }
  
  public var headers: [String: String] {
    switch self {
    case .authorize: [:]
    case .accessToken: ["Content-Type": "application/x-www-form-urlencoded"]
    case .refreshToken: ["Content-Type": "application/x-www-form-urlencoded"]
    }
  }
  
  public var body: (any Encodable)? {
    switch self {
    case .authorize:
      return nil
    case .accessToken(let dto):
      return dto
    case .refreshToken(let dto):
      return dto
    }
  }
  
  public var query: [String: Any] {
    switch self {
    case .authorize(let dto): dto.dictionary
    case .accessToken: [:]
    case .refreshToken: [:]
    }
  }
}
