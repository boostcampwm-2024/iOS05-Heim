//
//  HeimEmoji.swift
//  Presentation
//
//  Created by 김미래 on 11/23/24.
//

import UIKit

final class HeimEmoji: UIImageView {
  // MARK: Properties
  enum HeimEmotion {
    case sadness
    case happiness
    case angry
    case surprise
    case fear
    case disgust
    case neutral
  }

  // MARK: - Initializer
  init(icon: HeimEmotion) {
    super.init(frame: .zero)

    switch icon {
    case .disgust: self.image = .disgustIcon
    case .sadness: self.image = .sadIcon
    case .happiness: self.image = .happyIcon
    case .angry: self.image = .angryIcon
    case .surprise: self.image = .surpriseIcon
    case .fear: self.image = .fearIcon
    case .neutral: self.image = .neutralIcon
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  static func defaultEmotions() -> [HeimEmoji] {
    return [HeimEmoji(icon: .happiness),
            HeimEmoji(icon: .sadness),
            HeimEmoji(icon: .disgust),
            HeimEmoji(icon: .surprise),
            HeimEmoji(icon: .fear),
            HeimEmoji(icon: .angry),
            HeimEmoji(icon: .neutral)]
  }
}
