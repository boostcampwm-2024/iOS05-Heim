//
//  EmotionAnalyzeViewModelTests.swift
//  PresentationTests
//
//  Created by 박성근 on 12/6/24.
//

import XCTest
@testable import Presentation
import Domain

final class EmotionAnalyzeViewModelTests: XCTestCase {
  private var sut: EmotionAnalyzeViewModel!
  private var mockClassifyUseCase: MockEmotionClassifyUseCase!
  private var mockEmotionUseCase: MockGenerativeEmotionPromptUseCase!
  private var mockSummaryUseCase: MockGenerativeSummaryPromptUseCase!
  private let testRecognizedText = "Test Text"
  private let testVoice = Voice(audioBuffer: Data())
  
  override func setUp() {
    super.setUp()
    mockClassifyUseCase = MockEmotionClassifyUseCase()
    mockEmotionUseCase = MockGenerativeEmotionPromptUseCase()
    mockSummaryUseCase = MockGenerativeSummaryPromptUseCase()
    
    sut = EmotionAnalyzeViewModel(
      recognizedText: testRecognizedText,
      voice: testVoice,
      classifyUseCase: mockClassifyUseCase,
      emotionUseCase: mockEmotionUseCase,
      summaryUseCase: mockSummaryUseCase
    )
  }
  
  override func tearDown() {
    sut = nil
    mockClassifyUseCase = nil
    mockEmotionUseCase = nil
    mockSummaryUseCase = nil
    super.tearDown()
  }
  
  // MARK: - Initial State Tests
  func test_initialState() {
    XCTAssertTrue(sut.state.isAnalyzing)
    XCTAssertFalse(sut.state.isErrorPresent)
  }
  
  // MARK: - Analysis Tests
  func test_givenSuccessfulResponse_whenAnalyze_thenUpdatesState() async throws {
    // Given
    mockClassifyUseCase.mockEmotion = .happiness
    mockEmotionUseCase.mockReply = "Happy Reply"
    mockSummaryUseCase.mockSummary = "Happy Summary"
    
    // When
    sut.action(.analyze)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertFalse(sut.state.isAnalyzing)
    XCTAssertFalse(sut.state.isErrorPresent)
    XCTAssertEqual(mockClassifyUseCase.validateCallCount, 1)
    XCTAssertEqual(mockEmotionUseCase.generateCallCount, 1)
    XCTAssertEqual(mockSummaryUseCase.generateCallCount, 1)
    
    let diary = sut.diaryData()
    XCTAssertEqual(diary.emotion, .happiness)
    XCTAssertEqual(diary.emotionReport.text, "Happy Reply")
    XCTAssertEqual(diary.summary.text, "Happy Summary")
  }
  
  func test_givenClassifyError_whenAnalyze_thenSetsErrorState() async throws {
    // Given
    mockClassifyUseCase.shouldThrowError = true
    
    // When
    sut.action(.analyze)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertFalse(sut.state.isAnalyzing)
    XCTAssertTrue(sut.state.isErrorPresent)
    XCTAssertEqual(mockClassifyUseCase.validateCallCount, 1)
  }
  
  func test_givenEmotionPromptError_whenAnalyze_thenSetsErrorState() async throws {
    // Given
    mockEmotionUseCase.shouldThrowError = true
    
    // When
    sut.action(.analyze)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertFalse(sut.state.isAnalyzing)
    XCTAssertTrue(sut.state.isErrorPresent)
    XCTAssertEqual(mockEmotionUseCase.generateCallCount, 1)
  }
  
  func test_givenSummaryPromptError_whenAnalyze_thenSetsErrorState() async throws {
    // Given
    mockSummaryUseCase.shouldThrowError = true
    
    // When
    sut.action(.analyze)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    
    XCTAssertFalse(sut.state.isAnalyzing)
    XCTAssertTrue(sut.state.isErrorPresent)
    XCTAssertEqual(mockSummaryUseCase.generateCallCount, 1)
  }
}
