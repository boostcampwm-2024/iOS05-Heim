//
//  EmotionClassfyUseCaseTests.swift
//  Domain
//
//  Created by 한상진 on 11/20/24.
//

@testable import Domain
import XCTest

final class EmotionClassfyUseCaseTests: XCTestCase {
  // MARK: - Properties
  var defaultemotionClassfyUseCase: EmotionClassifyUseCase!

  // MARK: - TestCycle
  override func setUp() {
    super.setUp()

    defaultemotionClassfyUseCase = DefaultEmotionClassifyUseCase()
  }

  override func tearDown() {
    defaultemotionClassfyUseCase = nil

    super.tearDown()
  }

  // MARK: - Methods
  func test_GivenText_WhenValidate_ThenReturnEmotion() async throws {
    // Given
    let mockTextInput = """
    오늘은 좀 힘든 날이었어. 아침에 일어나자마자 너무 피곤해서 일정을 잘 소화할 수 있을지 걱정됐어. 그래도 회사에 가서는 집중을 잘 해서 중요한 일을 마무리했어.
    점심은 그냥 간단히 먹고 오후에는 몇 가지 일이 꼬여서 조금 짜증이 났지만 퇴근 후에는 친구랑 통화하면서 기분이 좀 나아졌어. 
    오늘 하루도 끝!
    """
    
    do {
      // When
      let emotion = try await defaultemotionClassfyUseCase.validate(mockTextInput)
      
      // Then
      XCTAssertNotEqual(emotion, .none)
    } catch {
      XCTFail("감정 분석 실패")
    }
  }
}
