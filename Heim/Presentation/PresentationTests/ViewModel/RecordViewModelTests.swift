//
//  RecordViewModelTests.swift
//  PresentationTests
//
//  Created by 박성근 on 12/5/24.
//

import XCTest
@testable import Presentation
import Domain

final class RecordViewModelTest: XCTestCase {
  private var sut: RecordViewModel!
  private var mockRecordManager: MockRecordManager!
  
  override func setUp() {
    super.setUp()
    mockRecordManager = MockRecordManager()
    sut = RecordViewModel(recordManager: mockRecordManager)
  }
  
  override func tearDown() {
    sut = nil
    mockRecordManager = nil
    super.tearDown()
  }
  
  // MARK: - Initial State Tests
  func test_givenNewViewModel_whenInitialized_thenStateIsCorrectlySet() {
    // Then
    XCTAssertFalse(sut.state.isRecording)
    XCTAssertFalse(sut.state.canMoveToNext)
    XCTAssertEqual(sut.state.timeText, "00:00")
    XCTAssertFalse(sut.state.isErrorPresent)
    XCTAssertTrue(sut.state.isAuthorized)
  }
  
  // MARK: - Recording State Tests
  func test_givenViewModel_WhenStartRecording_ThenStateUpdatesCorrectly() {
    // When
    sut.action(.startRecording)
    
    // Then
    XCTAssertTrue(mockRecordManager.startRecordingCalled)
    XCTAssertTrue(sut.state.isRecording)
    XCTAssertFalse(sut.state.canMoveToNext)
  }
  
  func test_GivenRecordingState_WhenStopRecording_ThenStateUpdatesCorrectly() {
    // Given
    sut.action(.startRecording)
    
    // When
    sut.action(.stopRecording)
    
    // Then
    XCTAssertTrue(mockRecordManager.stopRecordingCalled)
    XCTAssertFalse(sut.state.isRecording)
    XCTAssertTrue(sut.state.canMoveToNext)
  }
  
  func test_GivenRecordedState_WhenRefresh_ThenStateResetsToInitial() {
    // Given
    sut.action(.startRecording)
    sut.action(.stopRecording)
    
    // When
    sut.action(.refresh)
    
    // Then
    XCTAssertTrue(mockRecordManager.resetAllCalled)
    XCTAssertFalse(sut.state.isRecording)
    XCTAssertFalse(sut.state.canMoveToNext)
    XCTAssertEqual(sut.state.timeText, "00:00")
  }
  
  // MARK: - Error Handling Tests
  func test_GivenErrorState_WhenClearError_ThenErrorStateIsFalse() {
    // Given
    sut.state.isErrorPresent = true
    
    // When
    sut.action(.clearError)
    
    // Then
    XCTAssertFalse(sut.state.isErrorPresent)
  }
  
  func test_GivenNoVoiceData_WhenRequestVoiceData_ThenErrorStateIsTrue() {
    // Given
    mockRecordManager.voice = nil
    
    // When
    let voice = sut.voiceData()
    
    // Then
    XCTAssertNil(voice)
    XCTAssertTrue(sut.state.isErrorPresent)
  }
  
  func test_GivenViewModel_WhenRequestRecognizedText_ThenReturnsManagerText() {
    // Given
    let testText = "Test recognized text"
    mockRecordManager.recognizedText = testText
    
    // When
    let recognizedText = sut.recognizedTextData()
    
    // Then
    XCTAssertEqual(recognizedText, testText)
  }
  
  // MARK: - Complete Recording Flow Test
  func test_GivenInitialState_WhenPerformRecordingSequence_ThenStateTransitionsCorrectly() async {
    // Given
    XCTAssertFalse(sut.state.isRecording)
    XCTAssertFalse(sut.state.canMoveToNext)
    
    // When
    sut.action(.startRecording)
    
    // Then
    XCTAssertTrue(mockRecordManager.setupSpeechCalled)
    XCTAssertTrue(mockRecordManager.startRecordingCalled)
    XCTAssertTrue(sut.state.isRecording)
    XCTAssertFalse(sut.state.canMoveToNext)
    
    // When
    sut.action(.stopRecording)
    
    // Then
    XCTAssertTrue(mockRecordManager.stopRecordingCalled)
    XCTAssertFalse(sut.state.isRecording)
    XCTAssertTrue(sut.state.canMoveToNext)
  }
}
