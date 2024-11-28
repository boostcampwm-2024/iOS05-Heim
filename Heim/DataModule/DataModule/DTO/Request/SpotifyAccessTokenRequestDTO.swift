//
//  SpotifyAccessTokenRequestDTO.swift
//  Domain
//
//  Created by 정지용 on 11/20/24.
//

public struct SpotifyAccessTokenRequestDTO: Encodable {
  private let clientId: String
  private let grantType: String
  private let code: String
  private let redirectUri: String
  private let codeVerifier: String
  
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
