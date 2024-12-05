//
//  AnalyzeResultViewModelTests.swift
//  PresentationTests
//
//  Created by 박성근 on 12/6/24.
//

import XCTest
@testable import Presentation
import Domain

final class AnalyzeResultViewModelTests: XCTestCase {
  private var sut: AnalyzeResultViewModel!
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
    
    sut = AnalyzeResultViewModel(
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
    XCTAssertEqual(sut.state.userName, "")
    XCTAssertEqual(sut.state.description, "")
    XCTAssertEqual(sut.state.content, "")
    XCTAssertFalse(sut.state.isErrorPresent)
  }
  
  // MARK: - Fetch Diary Tests
  func test_givenSuccessfulResponse_whenFetchDiary_thenUpdatesState() async throws {
    // When
    sut.action(.fetchDiary)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertEqual(sut.state.userName, "TestUser")
    XCTAssertEqual(sut.state.description, "happiness")
    XCTAssertEqual(sut.state.content, "Test Report")
    XCTAssertEqual(mockUserUseCase.fetchUserNameCallCount, 1)
  }
  
  func test_givenUserFetchError_whenFetchDiary_thenUsesDefaultUserName() async throws {
    // Given
    mockUserUseCase.shouldThrowError = true
    
    // When
    sut.action(.fetchDiary)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertEqual(sut.state.userName, "User")
    XCTAssertEqual(sut.state.description, "happiness")
    XCTAssertEqual(sut.state.content, "Test Report")
    XCTAssertEqual(mockUserUseCase.fetchUserNameCallCount, 1)
  }
  
  // MARK: - Save Diary Tests
  func test_givenSuccessfulResponse_whenSaveDiary_thenCompletesWithoutError() async throws {
    // When
    sut.action(.fetchDiary)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    XCTAssertFalse(sut.state.isErrorPresent)
  }
  
  // MARK: - Save Diary Tests
  func test_givenError_whenSavingDiary_thenSetsErrorState() async throws {
    // Given
    mockDiaryUseCase.shouldThrowError = true
    
    // When
    sut.action(.fetchDiary) // fetchDiary 내부에서 saveDiary가 호출됨
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    XCTAssertTrue(sut.state.isErrorPresent)
  }
  
  func test_givenSuccess_whenSavingDiary_thenDoesNotSetErrorState() async throws {
    // Given
    mockDiaryUseCase.shouldThrowError = false
    
    // When
    sut.action(.fetchDiary) // fetchDiary 내부에서 saveDiary가 호출됨
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    XCTAssertFalse(sut.state.isErrorPresent)
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
