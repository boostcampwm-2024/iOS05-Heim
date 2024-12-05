//
//  ReportViewModelTests.swift
//  PresentationTests
//
//  Created by 박성근 on 12/6/24.
//

import XCTest
@testable import Presentation
import Domain

final class ReportViewModelTests: XCTestCase {
  private var sut: ReportViewModel!
  private var mockUserUseCase: MockUserUseCase!
  private var mockDiaryUseCase: MockDiaryUseCase!
  private var testDiaries: [Diary]!
  
  override func setUp() {
    super.setUp()
    mockUserUseCase = MockUserUseCase()
    mockDiaryUseCase = MockDiaryUseCase()
    setupTestDiaries()
    sut = ReportViewModel(userUseCase: mockUserUseCase, diaryUseCase: mockDiaryUseCase)
  }
  
  override func tearDown() {
    sut = nil
    mockUserUseCase = nil
    mockDiaryUseCase = nil
    testDiaries = nil
    super.tearDown()
  }
  
  private func setupTestDiaries() {
    let testDate = CalendarDate(
      year: 2024,
      month: 12,
      day: 6,
      hour: 12,
      minute: 0,
      second: 0
    )
    
    testDiaries = [
      Diary(
        calendarDate: testDate,
        emotion: .happiness,
        emotionReport: EmotionReport(text: "Happy Report"),
        voice: Voice(audioBuffer: Data()),
        summary: Summary(text: "Happy Summary")
      ),
      Diary(
        calendarDate: testDate,
        emotion: .happiness,
        emotionReport: EmotionReport(text: "Another Happy Report"),
        voice: Voice(audioBuffer: Data()),
        summary: Summary(text: "Another Happy Summary")
      )
    ]
  }
  
  // MARK: - Initial State Tests
  func test_initialState() {
    XCTAssertEqual(sut.state.userName, "")
    XCTAssertEqual(sut.state.totalCount, "0")
    XCTAssertEqual(sut.state.continuousCount, "0")
    XCTAssertEqual(sut.state.monthCount, "0")
    XCTAssertTrue(sut.state.emotionCountDictionary.isEmpty)
    XCTAssertEqual(sut.state.mainEmotionTitle, "")
    XCTAssertEqual(sut.state.reply, "")
  }
  
  // MARK: - Fetch User Name Tests
  func test_givenSuccessfulResponse_whenFetchUserName_thenUpdatesState() async throws {
    // Given
    mockUserUseCase.mockUserName = "TestUser"
    
    // When
    sut.action(.fetchUserName)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertEqual(sut.state.userName, "TestUser")
    XCTAssertEqual(mockUserUseCase.fetchUserNameCallCount, 1)
  }
  
  func test_givenError_whenFetchUserName_thenSetsDefaultName() async throws {
    // Given
    mockUserUseCase.shouldThrowError = true
    
    // When
    sut.action(.fetchUserName)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertEqual(sut.state.userName, "User")
    XCTAssertEqual(mockUserUseCase.fetchUserNameCallCount, 1)
  }
  
  // MARK: - Fetch Total Count Tests
  func test_givenSuccessfulResponse_whenFetchTotalDiaryCount_thenUpdatesState() async throws {
    // Given
    mockDiaryUseCase.mockDiaries = testDiaries
    
    // When
    sut.action(.fetchTotalDiaryCount)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertEqual(sut.state.totalCount, "2")
    XCTAssertEqual(sut.state.mainEmotionTitle, "기쁨")
    XCTAssertEqual(sut.state.emotionCountDictionary[.happiness], 2)
    XCTAssertEqual(mockDiaryUseCase.readTotalDiariesCallCount, 1)
  }
  
  func test_givenError_whenFetchTotalDiaryCount_thenSetsDefaultValues() async throws {
    // Given
    mockDiaryUseCase.shouldThrowError = true
    
    // When
    sut.action(.fetchTotalDiaryCount)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertEqual(sut.state.totalCount, "0")
    XCTAssertEqual(sut.state.mainEmotionTitle, "")
    XCTAssertEqual(sut.state.emotionCountDictionary.count, 7)
    // 모든 감정의 카운트가 0인지 확인
    Emotion.allCases.filter { $0 != .none }.forEach { emotion in
      XCTAssertEqual(sut.state.emotionCountDictionary[emotion], 0)
    }
    XCTAssertEqual(mockDiaryUseCase.readTotalDiariesCallCount, 1)
  }
  
  // MARK: - Fetch Continuous Count Tests
  func test_givenSuccessfulResponse_whenFetchContinuousCount_thenUpdatesState() async throws {
    // Given
    mockDiaryUseCase.mockContinuousCount = 5
    
    // When
    sut.action(.fetchContinuousCount)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertEqual(sut.state.continuousCount, "5")
    XCTAssertEqual(mockDiaryUseCase.fetchContinuousCountCallCount, 1)
  }
  
  func test_givenError_whenFetchContinuousCount_thenSetsDefaultValue() async throws {
    // Given
    mockDiaryUseCase.shouldThrowError = true
    
    // When
    sut.action(.fetchContinuousCount)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertEqual(sut.state.continuousCount, "0")
    XCTAssertEqual(mockDiaryUseCase.fetchContinuousCountCallCount, 1)
  }
  
  // MARK: - Fetch Month Count Tests
  func test_givenSuccessfulResponse_whenFetchMonthCount_thenUpdatesState() async throws {
    // Given
    mockDiaryUseCase.mockMonthCount = 15
    
    // When
    sut.action(.fetchMonthCount)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertEqual(sut.state.monthCount, "15")
    XCTAssertEqual(mockDiaryUseCase.fetchMonthCountCallCount, 1)
  }
  
  func test_givenError_whenFetchMonthCount_thenSetsDefaultValue() async throws {
    // Given
    mockDiaryUseCase.shouldThrowError = true
    
    // When
    sut.action(.fetchMonthCount)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertEqual(sut.state.monthCount, "0")
    XCTAssertEqual(mockDiaryUseCase.fetchMonthCountCallCount, 1)
  }
}
