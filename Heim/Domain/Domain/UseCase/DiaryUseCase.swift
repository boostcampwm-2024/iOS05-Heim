//
//  DiaryUseCase.swift
//  Domain
//
//  Created by 김미래 on 11/20/24.
//

import Foundation

public protocol DiaryUseCase {
  // MARK: - Properties
  var diaryRepository: DiaryRepository { get }

  // MARK: - Methods
  func readDiary(hashValue: String) async throws -> Diary
  func saveDiary(hashValue: String, data: Diary) async throws
  // TODO: 인덱스 접근 고려
  func deleteDiary(hashValue: String) async throws
}

public struct DefaultDiaryUseCase: DiaryUseCase {
  // MARK: - Properties
  public let diaryRepository: DiaryRepository

  // MARK: - Initializer
  public init(localStorageRepository: DiaryRepository) {
    self.diaryRepository = localStorageRepository
  }

  // MARK: - Methods
  public func readDiary(hashValue: String) async throws -> Diary {
    // TODO: repository에서 받아오는 걸로 수정 필요
    return Diary(emotion: .anger, emotionReport: EmotionReport(text: "임시파일"), voice: Voice(audioBuffer: Data()), summary: Summary(text: "임시요약"))
  }
  
  public func saveDiary(hashValue: String, data: Diary) async throws {
    // TODO: 수정 필요
  }
  
  public func deleteDiary(hashValue: String) async throws {
    // TODO: 수정 필요
  }
  

}
