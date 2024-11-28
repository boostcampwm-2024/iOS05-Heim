//
//  SpotifyAPI.swift
//  DataModule
//
//  Created by 정지용 on 11/25/24.
//

import Domain
import Foundation

enum SpotifyAPI {
  case recommendations(dto: SpotifyRecommendRequestDTO)
}

extension SpotifyAPI: RequestTarget {
  var baseURL: String {
    return SpotifyEnvironment.apiBaseURL
  }
  
  var path: String {
    switch self {
    case .recommendations:
      return "/v1/recommendations"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .recommendations:
      return .get
    }
  }
  
  var headers: [String : String] {
    switch self {
    case .recommendations:
      return [:]
    }
  }
  
  var body: (any Encodable)? {
    switch self {
    case .recommendations:
      return nil
    }
  }
  
  var query: [String : Any] {
    switch self {
    case .recommendations(let dto):
      return dto.dictionary
    }
  }
}
