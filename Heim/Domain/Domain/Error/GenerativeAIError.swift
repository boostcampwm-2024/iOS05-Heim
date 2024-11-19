//
//  GenerativeAIError.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

enum GenerativeAIError: Error {
  case invalidEmotion
  
  var description: String {
    switch self {
    case .invalidEmotion:
      return "감정 분석 오류"
    }
  }
}
