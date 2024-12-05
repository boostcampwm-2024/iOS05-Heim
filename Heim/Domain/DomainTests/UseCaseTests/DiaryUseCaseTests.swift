//
//  DiaryUseCaseTests.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

import XCTest
@testable import Domain

final class DiaryUseCaseTests: XCTestCase {
  var sut: DiaryUseCase!
  var mockDiaryRepository = MockDiaryRepository()
  
  override func setUp() {
    sut = DefaultDiaryUseCase(diaryRepository: mockDiaryRepository)
  }
  
  override func tearDown() {
    sut = nil
    mockDiaryRepository = MockDiaryRepository()
  }
  
  func test_fetch_diaries_through_readDiaries() async throws {
    // Given
    let input = CalendarDate(year: 1, month: 2, day: 3, hour: 4, minute: 5, second: 6)
    let mockDiary = Diary(
      calendarDate: input,
      emotion: Emotion.angry,
      emotionReport: EmotionReport(text: ""),
      voice: Voice(audioBuffer: Data()),
      summary: Summary(text: "")
    )
    
    // When
    mockDiaryRepository.returnValue.readDiaries = [mockDiary]
    let output = try await sut.readDiaries(calendarDate: input)
    
    // Then
    XCTAssertEqual(output.first!, mockDiary)
  }
  
  func test_fetch_total_diaries_through_readTotalDiaries() async throws {
    // Given
    let mockDiary = Diary(
      calendarDate: CalendarDate(year: 1, month: 2, day: 3, hour: 4, minute: 5, second: 6),
      emotion: Emotion.angry,
      emotionReport: EmotionReport(text: ""),
      voice: Voice(audioBuffer: Data()),
      summary: Summary(text: "")
    )
    
    // When
    mockDiaryRepository.returnValue.readTotalDiaries = [mockDiary]
    let output = try await sut.readTotalDiaries()
    
    // Then
    XCTAssertEqual(output, [mockDiary])
  }
  
  func test_delete_successfully_without_error() async throws {
    // Given
    let input = CalendarDate(year: 1, month: 2, day: 3, hour: 4, minute: 5, second: 6)
    
    // When
    try await sut.deleteDiary(calendarDate: input)
    
    // Then
    XCTAssert(true)
  }
  
  func test_save_successfully_without_error() async throws {
    // Given
    let mockDiary = Diary(
      calendarDate: CalendarDate(year: 1, month: 2, day: 3, hour: 4, minute: 5, second: 6),
      emotion: Emotion.angry,
      emotionReport: EmotionReport(text: ""),
      voice: Voice(audioBuffer: Data()),
      summary: Summary(text: "")
    )
    
    // When
    try await sut.saveDiary(data: mockDiary)
    
    // Then
    XCTAssert(true)
  }
}
