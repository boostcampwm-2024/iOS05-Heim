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
  func readTotalDiaries() async throws -> [Diary]
  func saveDiary(data: Diary) async throws
  func deleteDiary(calendarDate: CalendarDate) async throws
  func fetchContinuousCount() async throws -> Int
  func fetchMonthCount() async throws -> Int
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
  
  public func readTotalDiaries() async throws -> [Diary] {
    return try await diaryRepository.readTotalDiaries()
  }
  
  public func saveDiary(data: Diary) async throws {
    try await diaryRepository.saveDiary(data: data)
  }
  
  public func deleteDiary(calendarDate: CalendarDate) async throws {
    try await diaryRepository.deleteDiary(calendarDate: calendarDate)
  }
  
  public func fetchContinuousCount() async throws -> Int {
    var count = 0
    let calendar = Calendar.current
    var currentDate = Date()
    var endDate = calendar.range(of: .day, in: .month, for: currentDate)?.count ?? Int()
    var currentDiaries: [Diary] = try await diaryRepository.readDiaries(calendarDate: currentDate.calendarDate())
    var currentDay = currentDate.calendarDate().day
    
    func countDiary(_ diaries: [Diary]) async throws {
      for diary in diaries.sorted(by: { $0.calendarDate.day > $1.calendarDate.day }) {
        if diary.calendarDate.day == currentDay {
          count += 1
        }
        
        if currentDay - 1 > 0 {
          currentDay -= 1
        } else {
          currentDate = calendar.date(byAdding: DateComponents(month: -1), to: currentDate) ?? Date()
          endDate = calendar.range(of: .day, in: .month, for: currentDate)?.count ?? Int()
          currentDay = endDate
          currentDiaries = try await diaryRepository.readDiaries(calendarDate: currentDate.calendarDate())
          try await countDiary(currentDiaries)
        }
      }
    }
    
    try await countDiary(currentDiaries)
    return count
  }
  
  public func fetchMonthCount() async throws -> Int {
    let date = Date()
    var calendarDate = date.calendarDate()
    let targetDay = calendarDate.day
    var diaries: [Diary] = try await diaryRepository.readDiaries(calendarDate: calendarDate)
    var count = diaries.count
    
    if calendarDate.day < 30 {
      guard let lastDate = Calendar.current.date(byAdding: DateComponents(month: -1), to: date) else {
        return count
      }
      
      calendarDate = lastDate.calendarDate()
      diaries = try await diaryRepository.readDiaries(calendarDate: calendarDate)
      
      for diary in diaries.reversed() where calendarDate.day >= targetDay {
        count += 1
      }
    }
    
    return count
  }
}
