//
//  Chart.swift
//  Presentation
//
//  Created by 김미래 on 11/22/24.
//

import UIKit

enum HeimEmotion {
  case sadness
  case happiness
  case angry
  case surprise
  case fear
  case disgust
  case neutral
}
struct Chart {
  // MARK: Properties
  var value: Double
  var emotion: HeimEmotion

  // MARK: - Initializer
  init(value: Double, emotion: HeimEmotion) {
    self.value = value
    self.emotion = emotion
  }
}
