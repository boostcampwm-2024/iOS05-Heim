//
//  SpotifyOAuthUseCase.swift
//  Domain
//
//  Created by 정지용 on 11/21/24.
//

import CryptoKit
import Foundation

protocol SpotifyOAuthUseCase {
  func authorizaionURL(hash: String) throws -> URL?
  func login(
    code authorizationCode: String,
    plainText: String
  ) async throws -> Bool
  func generateCodeChallenge() -> (
    challenge: String,
    verifier: String
  )
}

struct DefaultSpotifyOAuthUseCase: SpotifyOAuthUseCase {
  private let repository: SpotifyOAuthRepository
  
  func authorizaionURL(hash: String) throws -> URL? {
    return try repository.createAuthorizationURL(codeChallenge: "")
  }
  
  func login(
    code authorizationCode: String,
    plainText: String
  ) async throws -> Bool {
    return try await repository.exchangeAccessToken(
      with: authorizationCode,
      codeVerifier: ""
    )
  }
  
  func generateCodeChallenge() -> (
    challenge: String,
    verifier: String
  ) {
    let verifier = generateRandomString(length: 64)
    let challenge = sha256Base64Encode(input: verifier)
    
    return (challenge: challenge, verifier: verifier)
  }
}

private extension DefaultSpotifyOAuthUseCase {
  func generateRandomString(length: Int) -> String {
    let possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    let possibleCount = UInt8(possible.count)
    
    let randomString = (0..<length).compactMap { _ -> Character? in
      var randomByte: UInt8 = 0
      let result = SecRandomCopyBytes(kSecRandomDefault, 1, &randomByte)
      guard result == errSecSuccess else { return nil }
      let index = Int(randomByte % possibleCount)
      return possible[possible.index(possible.startIndex, offsetBy: index)]
    }
    
    return String(randomString)
  }
  
  func sha256Base64Encode(input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let base64EncodedString = Data(hashedData).base64EncodedString()
    
    return base64EncodedString
  }
}
