//
//  MockEmotionClasffiyUseCase.swift
//  Presentation
//
//  Created by 박성근 on 12/6/24.
//

import Foundation
import Domain
@testable import Presentation

final class MockEmotionClassifyUseCase: EmotionClassifyUseCase {
  var validateCallCount = 0
  var mockEmotion: Emotion = .happiness
  var shouldThrowError = false
  
  enum MockError: Error {
    case testError
  }
  
  func validate(_ input: String) async throws -> Emotion {
    validateCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
    return mockEmotion
  }
}
