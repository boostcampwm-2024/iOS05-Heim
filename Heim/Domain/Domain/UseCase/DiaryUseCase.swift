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
  func readDiary(timeStamp: String) async throws -> Diary
  func saveDiary(timeStamp: String, data: Diary) async throws
  // TODO: 인덱스 접근 고려
  func deleteDiary(timeStamp: String) async throws
}

public struct DefaultDiaryUseCase: DiaryUseCase {
  // MARK: - Properties
  public let diaryRepository: DiaryRepository

  // MARK: - Initializer
  public init(diaryRepository: DiaryRepository) {
    self.diaryRepository = diaryRepository
  }

  // MARK: - Methods
  public func readDiary(timeStamp: String) async throws -> Diary {
    return try await diaryRepository.readDiary(timeStamp: timeStamp)
  }
  
  public func saveDiary(timeStamp: String, data: Diary) async throws {
    try await diaryRepository.saveDiary(timeStamp: timeStamp, data: data)
  }
  
  public func deleteDiary(timeStamp: String) async throws {
    try await diaryRepository.deleteDiary(timeStamp: timeStamp)
  }
}
