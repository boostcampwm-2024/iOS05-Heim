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
enum Emotion: String {
  case sad = "슬픔"
  case happiness = "기쁨"
  case anger = "분노"
  case confusion = "당황"
  case fear = "공포"
  case disgust = "혐오"
  case neutrality = "중립"
  case none = "없음"
}
