//
//  HeimEmoji.swift
//  Presentation
//
//  Created by 김미래 on 11/23/24.
//

import UIKit

class HeimEmoji: UIImageView {
  // MARK: Properties
  enum HeimEmotion {
    case sadness
    case happiness
    case angry
    case surprise
    case fear
    case disgust
    case neutral
    case none
  }

  // MARK: - Initializer
  init(icon: HeimEmotion) {
    super.init(frame: .zero)
    switch icon {
      // TODO: - 이미지 추가 후 수정 
    case .disgust: self.image = .disgustIcon
    case .sadness: self.image = .disgustIcon
    case .happiness: self.image = .disgustIcon
    case .angry: self.image = .disgustIcon
    case .surprise: self.image = .disgustIcon
    case .fear: self.image = .disgustIcon
    case .neutral: self.image = .disgustIcon
    case .none: self.image = .disgustIcon
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  static func defaultEmotions() -> [HeimEmoji] {
    return [HeimEmoji(icon: .disgust),
            HeimEmoji(icon: .disgust),
            HeimEmoji(icon: .disgust),
            HeimEmoji(icon: .disgust),
            HeimEmoji(icon: .disgust),
            HeimEmoji(icon: .disgust),
            HeimEmoji(icon: .disgust)]
  }
}
