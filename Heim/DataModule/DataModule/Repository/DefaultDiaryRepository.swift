//
//  DefaultDiaryRepository.swift
//  DataModule
//
//  Created by 김미래 on 11/20/24.
//

import Domain
import Foundation

public final class DefaultDiaryRepository: DiaryRepository {
  // MARK: - Properties
  private let localStorage: LocalStorage
  private let jsonEncoder = JSONEncoder()
  private let jsonDecoder = JSONDecoder()
  
  // MARK: - Initializer
  public init(localStorage: LocalStorage) {
    self.localStorage = localStorage
  }
  
  // MARK: - Methods
  public func readDiary(hashValue: String) async throws -> Diary {
    // TODO: 로직 구현 필요
    // let data = try localStorageProvider.readDiary(hashValue: hashValue)
    // return try jsonDecoder.decode(Diary.self, from: data)
    return Diary(
      emotion: .anger,
      emotionReport: EmotionReport(text: "나 화났다"),
      voice: Voice(audioBuffer: Data()),
      summary: Summary(text: "화난 거 요약")
    )
  }
  
  public func saveDiary(
    hashValue: String,
    data: Diary
  ) async throws {
    // TODO: 로직 구현 필요
    let encodedData = try jsonEncoder.encode(data)
    try localStorage.saveDiary(hashValue: hashValue, data: encodedData)
  }
  
  public func deleteDiary(hashValue: String) async throws {
    try localStorage.deleteDiary(hashValue: hashValue)
  }
}
