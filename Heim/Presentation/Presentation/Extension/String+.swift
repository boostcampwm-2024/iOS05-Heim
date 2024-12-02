//
//  String+.swift
//  Presentation
//
//  Created by 박성근 on 12/2/24.
//

extension String {
  static func recordConfigureDescription(emotion: String) -> String {
    switch emotion {
    case "sadness":
      return "힘들고 슬픈 하루를 보내셨군요..."
    case "happiness":
      return "행복한 하루를 보내셨네요!"
    case "angry":
      return "화가 나는 하루를 보내셨군요!"
    case "surprise":
      return "당황스러운 일이 있으셨나봐요!"
    case "fear":
      return "불안하고 무서운 하루를 보내셨군요..."
    case "disgust":
      return "불쾌한 일이 있으셨나봐요..."
    case "neutral":
      return "평온한 하루를 보내셨네요"
    default:
      return ""
    }
  }
}
