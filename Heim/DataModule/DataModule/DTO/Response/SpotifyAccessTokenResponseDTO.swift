//
//  SpotifyAccessTokenResponseDTO.swift
//  DataModule
//
//  Created by 정지용 on 11/21/24.
//

import Foundation

public struct SpotifyAccessTokenResponseDTO: Decodable {
  public let accessToken: String
  public let tokenType: String
  public let scope: String?
  public let expiresIn: Int
  public let refreshToken: String
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
    case scope = "scope"
    case expiresIn = "expires_in"
    case refreshToken = "refresh_token"
  }
}
