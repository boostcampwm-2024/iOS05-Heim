//
//  HeimEmoji.swift
//  Presentation
//
//  Created by 김미래 on 11/23/24.
//

import Domain
import UIKit

final class HeimEmojiView: UIImageView {
  // MARK: - Initializer
  init(emotion: Emotion) {
    super.init(frame: .zero)
    
    switch emotion {
    case .disgust: self.image = .disgustIcon
    case .sadness: self.image = .sadIcon
    case .happiness: self.image = .happyIcon
    case .angry: self.image = .angryIcon
    case .surprise: self.image = .surpriseIcon
    case .fear: self.image = .fearIcon
    case .neutral: self.image = .neutralIcon
    case .none: return
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
