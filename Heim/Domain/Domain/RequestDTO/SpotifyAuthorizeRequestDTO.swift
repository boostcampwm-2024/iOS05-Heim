//
//  SpotifyAuthorizeRequestDTO.swift
//  Domain
//
//  Created by 정지용 on 11/20/24.
//

import Foundation

/// SpotifyAuthorizeRequestDTO는 query를 위한 DTO입니다.
/// 해당 프로젝트에서 query는 Dictonary로 설계되었지만,
/// 너무 많은 parameter를 사용하므로 DTO로 구현합니다.
///
/// 사용 시 인스턴스를 생성하고 .toSnakeCaseDictionary를 사용하세요.
/// - 해당 API가 요구하는 파라미터의 네이밍은 snake_case로 되어있습니다.
public struct SpotifyAuthorizeRequestDTO: Encodable {
  public let responseType: String
  public let clientId: String
  public let codeChallengeMethod: String
  public let codeChallenge: String
  public let redirectUri: String
  
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
  
  enum CodingKeys: String, CodingKey {
    case responseType = "response_type"
    case clientId = "client_id"
    case codeChallengeMethod = "code_challenge_method"
    case codeChallenge = "code_challenge"
    case redirectUri = "redirect_uri"
  }
  
  public func toSnakeCaseDictionary() -> [String: Any] {
    var dict = [String: Any]()
    let mirror = Mirror(reflecting: self)
    
    for child in mirror.children {
      if let key = child.label {
        dict[key.toSnakeCase()] = child.value
      }
    }
    return dict
  }
}

// MARK: - String extension
private extension String {
  func toSnakeCase() -> String {
    guard !isEmpty else { return self }
    var result = ""
    for char in self {
      if char.isUppercase {
        result.append("_")
        result.append(char.lowercased())
      } else {
        result.append(char)
      }
    }
    return result.trimmingCharacters(in: CharacterSet(charactersIn: "_"))
  }
}
