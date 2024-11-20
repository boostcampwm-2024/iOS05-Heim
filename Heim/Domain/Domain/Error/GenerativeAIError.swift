//
//  GenerativeAIError.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

public enum GenerativeAIError: Error {
  case invalidEmotion
  
  public var description: String {
    switch self {
    case .invalidEmotion:
      return "감정 분석 오류"
    }
  }
}
