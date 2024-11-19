//
//  EmotionClassifyUseCase.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

import CoreML

protocol EmotionClassifyUseCase {
  func validate(_ input: String) async throws -> Emotion
}

struct DefaultEmotionClassifyUseCase: EmotionClassifyUseCase {
  func validate(_ input: String) async throws -> Emotion {
    // TODO: EmotionClassifier는 변경 예정 (현재 Mock Model)
    let model = try EmotionClassifier(configuration: MLModelConfiguration())
    let result = try model.prediction(text: input)
    return Emotion(rawValue: result.label) ?? .none
  }
}
