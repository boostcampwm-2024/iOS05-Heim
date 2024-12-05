//
//  DiaryDetailViewModelTests.swift
//  PresentationTests
//
//  Created by 박성근 on 12/6/24.
//

import XCTest
@testable import Presentation
import Domain

final class DiaryDetailViewModelTests: XCTestCase {
  private var sut: DiaryDetailViewModel!
  private var mockDiaryUseCase: MockDiaryUseCase!
  private var mockUserUseCase: MockUserUseCase!
  private var testDiary: Diary!
  
  override func setUp() {
    super.setUp()
    mockDiaryUseCase = MockDiaryUseCase()
    mockUserUseCase = MockUserUseCase()
    
    let testDate = CalendarDate(
      year: 2024,
      month: 12,
      day: 6,
      hour: 12,
      minute: 0,
      second: 0
    )
    
    testDiary = Diary(
      calendarDate: testDate,
      emotion: .happiness,
      emotionReport: EmotionReport(text: "Test Report"),
      voice: Voice(audioBuffer: Data()),
      summary: Summary(text: "Test Summary")
    )
    
    sut = DiaryDetailViewModel(
      diaryUseCase: mockDiaryUseCase,
      userUseCase: mockUserUseCase,
      diary: testDiary
    )
  }
  
  override func tearDown() {
    sut = nil
    mockDiaryUseCase = nil
    mockUserUseCase = nil
    testDiary = nil
    super.tearDown()
  }
  
  // MARK: - Initial State Tests
  func test_initialState() {
    XCTAssertEqual(sut.state.calendarDate, "")
    XCTAssertEqual(sut.state.emotion, "")
    XCTAssertEqual(sut.state.description, "")
    XCTAssertEqual(sut.state.content, "")
    XCTAssertFalse(sut.state.isDeleted)
    XCTAssertFalse(sut.state.isErrorPresent)
  }
  
  // MARK: - Fetch Diary Tests
  func test_givenSuccessfulResponse_whenFetchDiary_thenUpdatesState() async throws {
    // When
    sut.action(.fetchDiary)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertEqual(sut.state.calendarDate, "2024년 12월 6일")
    XCTAssertEqual(sut.state.emotion, "happiness")
    XCTAssertEqual(sut.state.content, "Test Summary")
    XCTAssertEqual(mockUserUseCase.fetchUserNameCallCount, 1)
  }
  
  func test_givenError_whenFetchDiary_thenUsesDefaultUserName() async throws {
    // Given
    mockUserUseCase.shouldThrowError = true
    
    // When
    sut.action(.fetchDiary)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertEqual(sut.userName, "User")
    XCTAssertEqual(sut.state.calendarDate, "2024년 12월 6일")
    XCTAssertEqual(sut.state.emotion, "happiness")
    XCTAssertEqual(sut.state.content, "Test Summary")
  }
  
  // MARK: - Delete Diary Tests
  func test_givenSuccessfulResponse_whenDeleteDiary_thenUpdatesState() async throws {
    // When
    sut.action(.deleteDiary)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertTrue(sut.state.isDeleted)
    XCTAssertFalse(sut.state.isErrorPresent)
    XCTAssertEqual(mockDiaryUseCase.deleteDiaryCallCount, 1)
  }
  
  func test_givenError_whenDeleteDiary_thenSetsErrorState() async throws {
    // Given
    mockDiaryUseCase.shouldThrowError = true
    
    // When
    sut.action(.deleteDiary)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertFalse(sut.state.isDeleted)
    XCTAssertTrue(sut.state.isErrorPresent)
    XCTAssertEqual(mockDiaryUseCase.deleteDiaryCallCount, 1)
  }
  
  // MARK: - Clear Error Tests
  func test_whenClearError_thenResetsErrorState() {
    // Given
    sut.state.isErrorPresent = true
    
    // When
    sut.action(.clearError)
    
    // Then
    XCTAssertFalse(sut.state.isErrorPresent)
  }
}
