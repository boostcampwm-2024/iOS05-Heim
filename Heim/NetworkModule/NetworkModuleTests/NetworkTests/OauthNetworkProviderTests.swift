//
//  OAuthNetworkProviderTest.swift
//  OAuthNetworkProviderTest
//
//  Created by 김미래 on 12/5/24.
//

import XCTest

@testable import DataModule
@testable import Domain
@testable import NetworkModule

final class OAuthNetworkProviderTest: XCTestCase {
  // MARK: - Properties
  var mockRequestor: MockNetworkRequestor!
  var mockTokenManager: MockTokenManager!
  var oAuthNetworkProvider: DefaultOAuthNetworkProvider!
  
  struct MockData: Codable {
    let name: String
    let age: Int
  }

  let mockData: Data? = """
    {
      "name": "Heim",
      "age": 1
    }
""".data(using: .utf8)
  
  // MARK: - TestCycle
  override func setUp() {
    mockRequestor = MockNetworkRequestor()
    super.setUp()
  }
  
  override func tearDown() {
    mockRequestor = nil
    mockTokenManager = nil
    oAuthNetworkProvider = nil
    
    super.tearDown()
  }
  
  func test_request_sucess() async throws {
    // Given
    let urlReponse = HTTPURLResponse(url: URL(string: "http://mock.example.com")!,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)
    mockTokenManager = MockTokenManager()
    mockTokenManager.accessToken = "유효 토큰"
    
    oAuthNetworkProvider = DefaultOAuthNetworkProvider(requestor: mockRequestor, tokenManager: mockTokenManager)
    
    mockRequestor.setURLResponse(urlReponse)
    mockRequestor.setResponseData(mockData)
    
    let mockTarget = MockTarget.get.request
    
    // When
    let response = try await oAuthNetworkProvider.request(target: mockTarget, type: MockData.self)
    
    // Then
    XCTAssertEqual(response.age, 1)
    XCTAssertEqual(response.name, "Heim")
  }
  
  func test_reques_serverError() async throws {
    // Given
    let urlReponse = HTTPURLResponse(url: URL(string: "http://mock.example.com")!,
                                     statusCode: 500,
                                     httpVersion: nil,
                                     headerFields: nil)
    mockTokenManager = MockTokenManager()
    mockTokenManager.accessToken = "유효 토큰"
    
    oAuthNetworkProvider = DefaultOAuthNetworkProvider(requestor: mockRequestor, tokenManager: mockTokenManager)
    
    mockRequestor.setURLResponse(urlReponse)
    mockRequestor.setResponseData(mockData)
    
    let mockTarget = MockTarget.get.request
    
    // When
    do {
      _ = try await oAuthNetworkProvider.request(target: mockTarget, type: MockData.self)
    } catch(let error) {
      guard let error = error as? NetworkError else {
        XCTFail("에러가 발생하지 않음")
        return
      }
      
      // Then
      XCTAssertEqual(error, NetworkError.serverError)
    }
  }
  
  func test_invalid_AccessToken() async throws {
    // Given
    let urlReponse = HTTPURLResponse(url: URL(string: "http://mock.example.com")!,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)
    mockTokenManager = MockTokenManager()
    
    oAuthNetworkProvider = DefaultOAuthNetworkProvider(requestor: mockRequestor, tokenManager: mockTokenManager)
    
    mockRequestor.setURLResponse(urlReponse)
    mockRequestor.setResponseData(mockData)
    
    let mockTarget = MockTarget.get.request
    
    // When
    do {
      _ = try await oAuthNetworkProvider.request(target: mockTarget, type: MockData.self)
      XCTFail("Error가 발생하지 않음")
    } catch(let error) {
      guard let error = error as? TokenError else {
        XCTFail("TokenError가 아님")
        return
      }
      
      // Then
      XCTAssertEqual(error, TokenError.accessTokenExpired)
    }
  }
}
