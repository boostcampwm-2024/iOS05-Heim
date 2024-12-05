//
//  MockDiaryUseCase.swift
//  Presentation
//
//  Created by 박성근 on 12/6/24.
//

import Foundation
import Domain
@testable import Presentation

final class MockDiaryUseCase: DiaryUseCase {
  var diaryRepository: DiaryRepository {
    fatalError("Not implemented")
  }
  
  // MARK: - Call Counts
  var saveDiaryCallCount = 0
  var deleteDiaryCallCount = 0
  var readDiariesCallCount = 0
  var readTotalDiariesCallCount = 0
  var fetchContinuousCountCallCount = 0
  var fetchMonthCountCallCount = 0
  
  // MARK: - Mock Data
  var mockDiaries: [Diary] = []
  var mockContinuousCount: Int = 0
  var mockMonthCount: Int = 0
  var shouldThrowError = false
  
  enum MockError: Error {
    case testError
  }
  
  // MARK: - DiaryUseCase Methods
  func saveDiary(data: Diary) async throws {
    saveDiaryCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
  }
  
  func deleteDiary(calendarDate: CalendarDate) async throws {
    deleteDiaryCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
  }
  
  func readDiaries(calendarDate: CalendarDate) async throws -> [Diary] {
    readDiariesCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
    return mockDiaries
  }
  
  func readTotalDiaries() async throws -> [Diary] {
    readTotalDiariesCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
    return mockDiaries
  }
  
  func fetchContinuousCount() async throws -> Int {
    fetchContinuousCountCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
    return mockContinuousCount
  }
  
  func fetchMonthCount() async throws -> Int {
    fetchMonthCountCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
    return mockMonthCount
  }
}
