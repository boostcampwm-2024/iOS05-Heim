//
//  MockTokenManager.swift
//  DataModuleTests
//
//  Created by 정지용 on 12/5/24.
//

@testable import DataModule

final class MockTokenManager: TokenManager {
  struct CallCount {
    var isAccessTokenValid = 0
    var loadAccessToken = 0
    var loadRefreshToken = 0
    var storeTokens = 0
  }
  
  struct Return {
    var loadAccessToken: String!
    var loadRefreshToken: String!
  }
  
  var callCount = CallCount()
  var returnValue = Return()
  
  func isAccessTokenValid() throws {
    callCount.isAccessTokenValid += 1
  }
  
  func loadAccessToken() throws -> String {
    callCount.loadAccessToken += 1
    return returnValue.loadAccessToken
  }
  
  func loadRefreshToken() throws -> String {
    callCount.loadRefreshToken += 1
    return returnValue.loadRefreshToken
  }
  
  func storeTokens(accessToken: String, refreshToken: String, expiresIn: Int) throws {
    callCount.storeTokens += 1
  }
}
