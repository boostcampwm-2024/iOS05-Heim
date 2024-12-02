//
//  Emotion+.swift
//  Presentation
//
//  Created by 박성근 on 11/29/24.
//

import Foundation
import Domain

extension Emotion {
  // MARK: - emotion이 @unknown으로 들어오는 경우가 없슴.
  func diaryDetailDescription(with name: String) -> String {
    switch self {
    case .sadness:
      return "\(name)님, 슬픈 하루를 보내셨군요"
    case .happiness:
      return "\(name)님, 행복한 하루를 보내셨군요"
    case .angry:
      return "\(name)님, 화가 나는 하루를 보내셨군요"
    case .surprise:
      return "\(name)님, 놀라운 하루를 보내셨군요"
    case .fear:
      return "\(name)님, 두려운 하루를 보내셨군요"
    case .disgust:
      return "\(name)님, 불쾌한 하루를 보내셨군요"
    case .neutral:
      return "\(name)님, 평온한 하루를 보내셨군요"
    case .none:
      return "\(name)님의 하루를 들려주세요"
    }
  }
}
