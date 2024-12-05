//
//  GenerativeSummaryUseCaseTests.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

import XCTest
@testable import Domain

final class GenerativeSummaryUseCaseTests: XCTestCase {
  var sut: GenerativeSummaryUseCase!
  var mockGenerativeRepository = MockGenerativeAIRepository()
  var mockGenerator = MockPromptGenerator()
  
  override func setUp() {
    sut = GeminiGenerativeSummaryUseCase(
      generativeRepository: mockGenerativeRepository,
      generator: mockGenerator
    )
  }
  
  override func tearDown() {
    sut = nil
    mockGenerativeRepository = .init()
    mockGenerator = .init()
  }
  
  func test_create_a_summary_through_generate() async throws {
    // Given
    let input = "SummaryTests"
    let generatorInput = "generator"
    let repositoryInput = "repository"
    mockGenerator.returnValue.generatePrompt = generatorInput
    mockGenerativeRepository.returnValue.generateContent = repositoryInput
    
    // When
    let output = try await sut.generate(input)
    
    // Then
    XCTAssertEqual(output, input + generatorInput + repositoryInput)
  }
}
