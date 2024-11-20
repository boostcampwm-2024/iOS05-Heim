//
//  SpotifyAccessTokenRequestDTO.swift
//  Domain
//
//  Created by 정지용 on 11/20/24.
//

public struct SpotifyAccessTokenRequestDTO: Encodable {
  public let clientId: String
  public let grantType: String
  public let code: String
  public let redirectUri: String
  public let codeVerifier: String
  
  public init(
    clientId: String,
    grantType: String,
    code: String,
    redirectUri: String,
    codeVerifier: String
  ) {
    self.clientId = clientId
    self.grantType = grantType
    self.code = code
    self.redirectUri = redirectUri
    self.codeVerifier = codeVerifier
  }
  
  enum CodingKeys: String, CodingKey {
    case clientId = "client_id"
    case grantType = "grant_type"
    case code = "code"
    case redirectUri = "redirect_uri"
    case codeVerifier = "code_verifier"
  }
}
