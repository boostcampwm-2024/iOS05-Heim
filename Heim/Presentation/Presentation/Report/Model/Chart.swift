//
//  Chart.swift
//  Presentation
//
//  Created by 김미래 on 11/22/24.
//

import Domain

struct Chart {
  // MARK: Properties
  let value: Double
  let emotion: Emotion

  // MARK: - Initializer
  init(value: Double, emotion: Emotion) {
    self.value = value
    self.emotion = emotion
  }
}
