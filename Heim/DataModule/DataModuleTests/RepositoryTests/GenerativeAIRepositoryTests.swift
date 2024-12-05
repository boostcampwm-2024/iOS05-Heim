//
//  GenerativeAIRepositoryTests.swift
//  DataModuleTests
//
//  Created by 정지용 on 12/6/24.
//

import XCTest
@testable import DataModule
@testable import Domain

final class GenerativeAIRepositoryTests: XCTestCase {
  var sut: GenerativeAIRepository!
  var mockNetworkProvider = MockNetworkProvider()

  override func setUp() {
    sut = GeminiGenerativeAIRepository(networkProvider: mockNetworkProvider)
  }
  
  override func tearDown() {
    sut = nil
    mockNetworkProvider = .init()
  }
  
  func test_generate_content_through_generateContent() async throws {
    // Given
    let input = "TESTPROMPT"
    let mockDTO = GeminiGenerateResponseDTO(
      candidates: [Candidate(
        content: ResponseContent(
          parts: [ResponsePart(text: input)],
          role: ""
        ),
        finishReason: ""
      )],
      usageMetadata: UsageMetadata(
        promptTokenCount: 0,
        candidatesTokenCount: 0,
        totalTokenCount: 0
      ),
      modelVersion: ""
    )
    
    // When
    mockNetworkProvider.returnValue.request = mockDTO
    let output = try await sut.generateContent(for: "")
    
    // Then
    XCTAssertEqual(output, input)
  }
}
