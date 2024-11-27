//
//  EmotionError.swift
//  Domain
//
//  Created by 정지용 on 11/25/24.
//

import Foundation

public enum EmotionError: Error {
  case noneEmotionException
  
  var description: String {
    switch self {
    case .noneEmotionException:
      return "잘못된 감정"
    }
  }
}
