//
//  MockSpotifiyOAuthRepository.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

import Foundation
@testable import Domain

final class MockSpotifyOAuthRepository: SpotifyOAuthRepository {
  struct CallCount {
    var createAuthorizationURL = 0
    var exchangeAccessToken = 0
  }
  
  struct Return {
    var createAuthorizationURL: URL!
  }
  
  var callCount = CallCount()
  var returnValue = Return()
  
  func createAuthorizationURL(codeChallenge: String) throws -> URL? {
    callCount.createAuthorizationURL += 1
    return returnValue.createAuthorizationURL
  }
  
  func exchangeAccessToken(with code: String, codeVerifier: String) async throws {
    callCount.exchangeAccessToken += 1
  }
}
