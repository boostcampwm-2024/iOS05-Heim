//
//  DiaryRepositoryTests.swift
//  DataModuleTests
//
//  Created by 정지용 on 12/5/24.
//

import XCTest
@testable import DataModule
@testable import Domain

final class DiaryRepositoryTests: XCTestCase {
  var sut: DiaryRepository!
  var mockDataStorage = MockDataStorage()

  override func setUp() {
    sut = DefaultDiaryRepository(dataStorage: mockDataStorage)
  }
  
  override func tearDown() {
    sut = nil
    mockDataStorage = .init()
  }
  
  func test_read_diaries_through_readDiaries() async throws {
    // Given
    let input = CalendarDate(
      year: 2024,
      month: 12,
      day: 5,
      hour: 1,
      minute: 2,
      second: 3
    )
    
    let mockDiary = Diary(
      calendarDate: input,
      emotion: Emotion.angry,
      emotionReport: EmotionReport(text: ""),
      voice: Voice(audioBuffer: Data()),
      summary: Summary(text: "")
    )
    
    // When
    mockDataStorage.returnValue.readData = [mockDiary]
    let output = try await sut.readDiaries(calendarDate: input)
    
    // Then
    XCTAssertEqual(output, [mockDiary])
  }
  
  func test_delete_diary_successfully_without_error() async throws {
    // Given
    let input = CalendarDate(
      year: 2024,
      month: 12,
      day: 5,
      hour: 1,
      minute: 2,
      second: 3
    )
    
    // When
    do {
      try await sut.deleteDiary(calendarDate: input)
      
      // Then
      XCTAssert(true)
    } catch {
      XCTFail("성공해야 하는 위치")
    }
  }
  
  func test_read_all_diaries_through_readTotalDiaries() async throws {
    // Given
    let mockDiary = Diary(
      calendarDate: CalendarDate(
        year: 2024,
        month: 12,
        day: 5,
        hour: 1,
        minute: 2,
        second: 3
      ),
      emotion: Emotion.angry,
      emotionReport: EmotionReport(text: ""),
      voice: Voice(audioBuffer: Data()),
      summary: Summary(text: "")
    )
    
    // When
    mockDataStorage.returnValue.readAll = [mockDiary]
    let output = try await sut.readTotalDiaries()
    
    // Then
    XCTAssertEqual(output, [mockDiary])
  }
  
  func test_save_diary_successfully_without_error() async throws {
    // Given
    let input = Diary(
      calendarDate: CalendarDate(
        year: 2024,
        month: 12,
        day: 5,
        hour: 1,
        minute: 2,
        second: 3
      ),
      emotion: Emotion.angry,
      emotionReport: EmotionReport(text: ""),
      voice: Voice(audioBuffer: Data()),
      summary: Summary(text: "")
    )
    
    // When
    do {
      try await sut.saveDiary(data: input)
      
      // Then
      XCTAssert(true)
    } catch {
      XCTFail("성공해야 하는 위치")
    }
  }
}
