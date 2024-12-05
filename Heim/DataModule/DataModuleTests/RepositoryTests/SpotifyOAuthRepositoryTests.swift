//
//  SpotifyOAuthRepositoryTests.swift
//  DataModuleTests
//
//  Created by 정지용 on 12/5/24.
//

import XCTest
@testable import DataModule
@testable import Domain

final class SpotifyOAuthRepositoryTests: XCTestCase {
  var sut: SpotifyOAuthRepository!
  var mockNetworkProvider = MockNetworkProvider()
  var mockTokenManager = MockTokenManager()

  override func setUp() {
    sut = DefaultSpotifyOAuthRepository(
      networkProvider: mockNetworkProvider,
      tokenManager: mockTokenManager
    )
  }
  
  override func tearDown() {
    sut = nil
    mockNetworkProvider = .init()
    mockTokenManager = .init()
  }
  
  func test_create_authoriztion_url_through_createAuthorizationURL() throws {
    // Given
    let input = "http://testheim.kr"
    let challenge = "TESTChallenge"
    let mockURL = try mockNetworkProvider.makeURL(
      target: MockRequestTarget(
        baseURL: input,
        path: "",
        method: .get,
        headers: [:],
        query: [:]
      )
    )
    
    // When
    mockNetworkProvider.returnValue.makeURL = mockURL
    let output = try sut.createAuthorizationURL(codeChallenge: challenge)
    
    // Then
    XCTAssertEqual(output, mockURL)
  }
  
  func test_create_access_token_through_exchangeAccessToken() async throws {
    // Given
    let input = "TESTCode"
    let verifier = "TESTVerifier"
    let mockDTO = SpotifyAccessTokenResponseDTO(
      accessToken: "",
      tokenType: "",
      scope: "",
      expiresIn: 0,
      refreshToken: ""
    )
    
    // When
    do {
      mockNetworkProvider.returnValue.request = mockDTO
      try await sut.exchangeAccessToken(with: input, codeVerifier: verifier)
      
      // Then
      XCTAssert(true)
    } catch {
      XCTFail("성공해야 하는 자리")
    }
  }
}
