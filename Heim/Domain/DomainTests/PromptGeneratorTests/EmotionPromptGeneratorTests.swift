//
//  EmotionPromptGeneratorTests.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

import XCTest
@testable import Domain

final class EmotionPromptGeneratorTests: XCTestCase {
  var sut: EmotionPromptGenerator!
  
  override func setUp() {
    sut = EmotionPromptGenerator()
  }
  
  override func tearDown() {
    sut = nil
  }
  
  func test_create_a_prompt_through_generatePrompt() throws {
    // Given
    let input = Emotion.angry.rawValue
    
    // When
    let output = try sut.generatePrompt(for: input)
    
    // Then
    let angryPrompt = """
        사용자는 지금 분노를 느끼고 있습니다. 분노는 순간적으로 우리를 압도할 수 있는 감정입니다. 
        이 감정을 가라앉히고 평온을 되찾을 수 있도록, 심호흡을 통해 긴장을 풀고 스스로를 진정시킬 수 있는 방법에 대해 조언해 주세요. 
        또한, 차분하게 현재 상황을 바라볼 수 있는 구체적인 방법을 제공하세요.
        """
    XCTAssert(output.contains(angryPrompt))
  }
  
  func test_fail_when_input_is_not_valid_emotion() throws {
    // Given
    let input = Emotion.none
    
    // When
    let emotion = Emotion(rawValue: input.rawValue)
    
    // Then
    XCTAssertThrowsError(try sut.generatePrompt(for: emotion!.rawValue))
  }
}
