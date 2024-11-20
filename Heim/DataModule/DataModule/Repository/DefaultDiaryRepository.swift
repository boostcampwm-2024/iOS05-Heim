//
//  DefaultDiaryRepository.swift
//  DataModule
//
//  Created by 김미래 on 11/20/24.
//

import Domain
import Foundation

public final class DefaultDiaryRepository: DiaryRepository {

  // MARK: - Methods
  public func readDiary(hashValue: String) async throws -> Diary {

    return Diary(emotion: .anger, emotionReport: EmotionReport(text: "임시파일"), voice: Voice(audioBuffer: Data()), summary: Summary(text: "임시요약"))
  }
  
  public func saveDiary(hashValue: String, data: Diary) async throws {

  }
  
  public func deleteDiary(hashValue: String) async throws {

  }
}
