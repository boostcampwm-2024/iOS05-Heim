//
//  SpotifyRefreshTokenRequestDTO.swift
//  DataModule
//
//  Created by 정지용 on 11/27/24.
//

import Foundation

public struct SpotifyRefreshTokenRequestDTO: Encodable {
  private let grantType: String
  private let refreshToken: String
  private let clientId: String
  
  public init(
    grantType: String,
    refreshToken: String,
    clientId: String
  ) {
    self.grantType = grantType
    self.refreshToken = refreshToken
    self.clientId = clientId
  }
  
  enum CodingKeys: String, CodingKey {
    case grantType = "grant_type"
    case refreshToken = "refresh_token"
    case clientId = "client_id"
  }
}
