//
//  Emotion.swift
//  Domain
//
//  Created by 정지용 on 11/18/24.
//

/// Emotion은 7개의 감정 + 오류 감정으로 이루어져 있습니다.
/// 각 7개의 감정은 분석되어 나온 결과로, 크게 신경 쓸 부분이 없습니다.
///
/// 단, `none`이라는 감정은 `init(rawValue:)`에서 발생하는 오류를 위한 기본 값이며,
/// 이 값이 발생하는 경우 예외처리를 해야 함을 참고해주세요.
public enum Emotion: String, Codable, Equatable {
  case sadness
  case happiness
  case angry
  case surprise
  case fear
  case disgust
  case neutral
  case none
  
  public init(from decoder: Decoder) throws {
    self = try Emotion(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .none
  }
}
