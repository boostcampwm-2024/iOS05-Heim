//
//  NetworkProviderTests.swift
//  NetworkProviderTests
//
//  Created by 김미래 on 12/5/24
//

import XCTest

@testable import Domain
@testable import NetworkModule

final class NetworkProviderTests: XCTestCase {
  // MARK: - Properties
  var networkProvider: DefaultNetworkProvider!
  var mockNetworkRequestor: MockNetworkRequestor!
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
    mockNetworkRequestor = MockNetworkRequestor()
    networkProvider = DefaultNetworkProvider(requestor: mockNetworkRequestor)

    super.setUp()
  }

  override func tearDown() {
    networkProvider = nil
    mockNetworkRequestor = nil

    super.tearDown()
  }

  func test_request_sucess() async throws {
    // Given
    let urlReponse = HTTPURLResponse(url: URL(string: "http://mock.example.com")!,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)

    mockNetworkRequestor.setURLResponse(urlReponse)
    mockNetworkRequestor.setResponseData(mockData)

    let mockTarget = MockTarget.get.request

    // When
    let response = try await networkProvider.request(target: mockTarget, type: MockData.self)

    // then
    XCTAssertEqual(response.age, 1)
    XCTAssertEqual(response.name, "Heim")
  }

  func test_DecodingError() async throws {
    // Given
    let urlReponse = HTTPURLResponse(url: URL(string: "http://mock.example.com")!,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)
    mockNetworkRequestor.setURLResponse(urlReponse)
    mockNetworkRequestor.setResponseData(mockData)

    let mockTarget = MockTarget.get.request

    // When
    do {
      try await networkProvider.request(target: mockTarget, type: Int.self)
      XCTFail("Error가 발생하지 않음")
    } catch(let error) {
      guard let error = error as? NetworkError else {
        XCTFail("error가 NetworkError이 아님")
        return
      }

      // Then
      XCTAssertEqual(error, NetworkError.serverError)
    }
  }

  func test_invalidUrl() async throws {
    let mockTarget = MockTarget.get.request

    do {
      try await networkProvider.request(target: mockTarget, type: MockData.self)
      XCTFail("Error가 발생하지 않음")
    } catch(let error) {
      guard let error = error as? NetworkError else {
        XCTFail("error가 NetworkError이 아님")
        return
      }

      // THen
      XCTAssertEqual(error, NetworkError.serverError)
    }
  }

  func test_NetworkProvider_Return_invalidStatuscode() async throws {
    // Given
    let urlReponse = HTTPURLResponse(url: URL(string: "http://mock.example.com")!,
                                     statusCode: 404,
                                     httpVersion: nil,
                                     headerFields: nil)

    mockNetworkRequestor.setURLResponse(urlReponse)
    mockNetworkRequestor.setResponseData(mockData)
    let mockTarget = MockTarget.get.request

    // When
    do {
      try await networkProvider.request(target: mockTarget, type: MockData.self)
      XCTFail("Error가 발생하지 않았습니다.")
    } catch(let error) {
      guard let error = error as? NetworkError else {
        XCTFail("Error 객체가 NetworkError 타입으로 캐스팅 되지 않음")
        return
      }

      // Then
      XCTAssertEqual(error, NetworkError.clientError)
    }
  }

  func test_EmptyData() async throws {
    // Given
    let urlResponse = HTTPURLResponse(url: URL(string: "http://mock.example.com")!,
                                      statusCode: 200,
                                      httpVersion: nil,
                                      headerFields: nil)
    mockNetworkRequestor.setURLResponse(urlResponse)
    let mockTarget = MockTarget.get.request
    
    // When
    do {
      try await networkProvider.request(target: mockTarget, type: MockData.self)
    } catch(let error) {
      guard let error = error as? NetworkError else {
        XCTFail("Error 객체가 NetworkError 타입으로 캐스팅 되지 않음")
        return
      }

      // Then
      XCTAssertEqual(error, NetworkError.serverError)
    }
  }
}
