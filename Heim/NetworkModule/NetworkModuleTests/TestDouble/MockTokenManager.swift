//
//  MockTokenManager.swift
//  NetworkModule
//
//  Created by 김미래 on 12/5/24.
//

@testable import DataModule
@testable import Domain
@testable import NetworkModule

final class MockTokenManager: TokenManager {
  struct CallCount {
    var isAccessTokenValid = 0
    var loadAccessToken = 0
    var loadRefreshToken = 0
    var storeToken = 0
  }

  var accessToken: String!
  var refreshToken: String!
  var callCount = CallCount()

  func isAccessTokenValid() throws {
    callCount.isAccessTokenValid += 1
  }

  func loadAccessToken() throws -> String {
    callCount.loadAccessToken += 1

    guard let accessToken = accessToken else {
      throw TokenError.accessTokenExpired
    }
    return accessToken
  }

  func loadRefreshToken() throws -> String {
    callCount.loadRefreshToken += 1

    guard let refreshToken = refreshToken else {
      throw TokenError.refreshTokenExpired
    }
    return refreshToken
  }

  func storeTokens(accessToken: String, refreshToken: String, expiresIn: Int) throws {
    callCount.storeToken += 1
  }
}
