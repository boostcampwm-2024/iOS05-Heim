//
//  TokenManager.swift
//  DataModule
//
//  Created by 정지용 on 11/27/24.
//

import Domain
import Foundation

public protocol TokenManager {
  func isAccessTokenValid() throws
  func loadAccessToken() throws -> String
  func loadRefreshToken() throws -> String
  func storeTokens(accessToken: String, refreshToken: String, expiresIn: Int) throws
}

public struct DefaultTokenManager: TokenManager {
  private let keychainStorage: KeychainStorage
  
  public init(keychainStorage: KeychainStorage) {
    self.keychainStorage = keychainStorage
  }
  
  public func isAccessTokenValid() throws {
    let expiresIn: Date = try keychainStorage.load(attrAccount: SpotifyEnvironment.expiresInAttributeKey)
    if !(Date() < expiresIn) { throw TokenError.accessTokenExpired }
  }
  
  public func loadAccessToken() throws -> String {
    try isAccessTokenValid()
    let accessToken: String = try keychainStorage.load(attrAccount: SpotifyEnvironment.accessTokenAttributeKey)
    return accessToken
  }
  
  public func loadRefreshToken() throws -> String {
    return try keychainStorage.load(attrAccount: SpotifyEnvironment.refreshTokenAttributeKey)
  }
  
  public func storeTokens(accessToken: String, refreshToken: String, expiresIn: Int) throws {
    let expiresIn = Date().addingTimeInterval(TimeInterval(expiresIn))
    try keychainStorage.save(accessToken, attrAccount: SpotifyEnvironment.accessTokenAttributeKey)
    try keychainStorage.save(refreshToken, attrAccount: SpotifyEnvironment.refreshTokenAttributeKey)
    try keychainStorage.save(expiresIn, attrAccount: SpotifyEnvironment.expiresInAttributeKey)
  }
}
