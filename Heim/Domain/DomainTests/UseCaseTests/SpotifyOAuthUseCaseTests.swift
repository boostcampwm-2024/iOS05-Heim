//
//  SpotifyOAuthUseCaseTests.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

import XCTest
import CryptoKit
@testable import Domain

final class SpotifyOAuthUseCaseTests: XCTestCase {
  var sut: SpotifyOAuthUseCase!
  var mockSpotifyOAuthRepository = MockSpotifyOAuthRepository()
  
  var plainText: String!
  var hashed: String!
  
  override func setUp() {
    sut = DefaultSpotifyOAuthUseCase(repository: mockSpotifyOAuthRepository)
    (plainText, hashed) = sut.generateCodeChallenge()
  }
  
  override func tearDown() {
    sut = nil
    mockSpotifyOAuthRepository = MockSpotifyOAuthRepository()
  }
  
  func test_create_url_through_authorizationURL() throws {
    // Given
    let input: String = hashed
    
    // When
    mockSpotifyOAuthRepository.returnValue.createAuthorizationURL = URL(string: input)
    let output = try sut.authorizaionURL(hash: input)
    
    // Then
    XCTAssertEqual(output, URL(string: input))
  }
  
  func test_login_successfully_without_error() async throws {
    // Given
    let input: String = plainText
    let code = "test"
    
    // When
    try await sut.login(code: code, plainText: input)
    
    // Then
    XCTAssert(true)
  }
  
  func test_generate_code_challenge_variables_through_generateCodeChallenge() {
    // Given
    let (plainText, hashed) = sut.generateCodeChallenge()
    
    // When
    let codeChallenge = sha256Base64Encode(input: hashed)
    
    // Then
    XCTAssertEqual(codeChallenge, plainText)
  }
  
  private func sha256Base64Encode(input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let base64EncodedString = Data(hashedData).base64EncodedString()
    
    return base64EncodedString
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "_")
      .replacingOccurrences(of: "=", with: "")
  }
}
