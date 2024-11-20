//
//  Diary.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

public struct Diary: Codable {
  public let emotion: Emotion
  public let emotionReport: EmotionReport
  public let voice: Voice
  public let summary: Summary

  public init(emotion: Emotion, emotionReport: EmotionReport, voice: Voice, summary: Summary) {
    self.emotion = emotion
    self.emotionReport = emotionReport
    self.voice = voice
    self.summary = summary
  }
}
