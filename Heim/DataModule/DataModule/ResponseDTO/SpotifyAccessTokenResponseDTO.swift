//
//  SpotifyAccessTokenResponseDTO.swift
//  DataModule
//
//  Created by 정지용 on 11/21/24.
//

import Foundation

public struct SpotifyAccessTokenResponseDTO: Decodable {
  let accessToken: String
  let tokenType: String
  let scope: String
  let expiresIn: Int
  let refreshToken: String
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.accessToken = try container.decode(String.self, forKey: .accessToken)
    self.tokenType = try container.decode(String.self, forKey: .tokenType)
    self.scope = try container.decode(String.self, forKey: .scope)
    self.expiresIn = try container.decode(Int.self, forKey: .expiresIn)
    self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
  }
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
    case scope = "scope"
    case expiresIn = "expire_in"
    case refreshToken = "refresh_token"
  }
}
