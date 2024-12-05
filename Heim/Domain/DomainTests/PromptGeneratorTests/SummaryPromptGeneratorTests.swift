//
//  SummaryPromptGeneratorTests.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

import XCTest
@testable import Domain

final class SummaryPromptGeneratorTests: XCTestCase {
  var sut: SummaryPromptGenerator!
  
  override func setUp() {
    sut = SummaryPromptGenerator()
  }
  
  override func tearDown() {
    sut = nil
  }
  
  func test_create_a_prompt_through_generatePrompt() throws {
    // Given
    let input = "테스트 사용자 입력"
    
    // When
    let output = try sut.generatePrompt(for: input)
    
    // Then
    XCTAssert(output.contains(input))
  }
  
  func test_separate_user_input_context_by_wrapInputContext() {
    // Given
    let input = "사용자 컨텍스트"
    
    // When
    let output = sut.wrapInputContext(for: input)
    
    // Then
    XCTAssertEqual("\n$%^$%^\(input)$%^$%^", output)
  }
}
