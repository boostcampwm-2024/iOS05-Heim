//
//  SpotifyOAuthAPI.swift
//  DataModule
//
//  Created by 정지용 on 11/13/24.
//

import Domain
import Foundation

enum SpotifyOAuthAPI {
  case authorize(dto: SpotifyAuthorizeRequestDTO)
  case accessToken(dto: SpotifyAccessTokenRequestDTO)
}

extension SpotifyOAuthAPI: RequestTarget {
  var baseURL: String {
    return "\(SpotifyEnvironment.oauthBaseURL)"
  }
  
  var path: String {
    switch self {
    case .authorize: "/authorize"
    case .accessToken: "/api/token"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .authorize: .get
    case .accessToken: .post
    }
  }
  
  var headers: [String: String] {
    switch self {
    case .authorize: [:]
    case .accessToken: ["Content-Type": "application/x-www-form-urlencoded"]
    }
  }
  
  var body: (any Encodable)? {
    switch self {
    case .authorize:
      return nil
    case .accessToken(let dto):
      return dto
    }
  }
  
  var query: [String: Any] {
    switch self {
    case .authorize(let dto): dto.dictionary
    case .accessToken: [:]
    }
  }
}
