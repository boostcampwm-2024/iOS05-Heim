//
//  SpotifyAuthorizeRequestDTO.swift
//  Domain
//
//  Created by 정지용 on 11/20/24.
//

import Foundation

public struct SpotifyAuthorizeRequestDTO: DictionaryRepresentable {
  private let responseType: String
  private let clientId: String
  private let codeChallengeMethod: String
  private let codeChallenge: String
  private let redirectUri: String
  
  public init(
    responseType: String,
    clientId: String,
    codeChallengeMethod: String,
    codeChallenge: String,
    redirectUri: String
  ) {
    self.responseType = responseType
    self.clientId = clientId
    self.codeChallengeMethod = codeChallengeMethod
    self.codeChallenge = codeChallenge
    self.redirectUri = redirectUri
  }
  
  public var dictionary: [String : Any] {
    return self.toSnakeCaseDictionary()
  }
}
