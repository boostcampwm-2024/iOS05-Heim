//
//  EmotionClassifyUseCase.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

import CoreML

public protocol EmotionClassifyUseCase {
  func validate(_ input: String) async throws -> Emotion
}

public struct DefaultEmotionClassifyUseCase: EmotionClassifyUseCase {
  public init() {}
  
  public func validate(_ input: String) async throws -> Emotion {
    let model = try EmotionClassifier(configuration: MLModelConfiguration())
    let result = try model.prediction(text: input)
    return Emotion(rawValue: result.label) ?? .none
  }
}
