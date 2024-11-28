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
  func readDiaries(calendarDate: CalendarDate) async throws -> [Diary]
  func saveDiary(data: Diary) async throws
  // TODO: 인덱스 접근 고려

  func deleteDiary(calendarDate: CalendarDate) async throws

}

public struct DefaultDiaryUseCase: DiaryUseCase {
  // MARK: - Properties
  public let diaryRepository: DiaryRepository

  // MARK: - Initializer
  public init(diaryRepository: DiaryRepository) {
    self.diaryRepository = diaryRepository
  }

  // MARK: - Methods
  public func readDiaries(calendarDate: CalendarDate) async throws -> [Diary] {
    return try await diaryRepository.readDiaries(calendarDate: calendarDate)
  }
  
  public func saveDiary(data: Diary) async throws {
    try await diaryRepository.saveDiary(data: data)
  }
  
  public func deleteDiary(calendarDate: CalendarDate) async throws {
    try await diaryRepository.deleteDiary(calendarDate: calendarDate)
  }

  public func countTotalDiary() async throws -> Int {
    return try await diaryRepository.countTotalDiary()
  }
}
