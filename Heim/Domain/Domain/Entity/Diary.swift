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
}
