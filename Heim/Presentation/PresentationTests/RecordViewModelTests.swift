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
  private var viewModel: RecordViewModel!
  private var mockRecordManager: MockRecordManager!
  
  override func setUp() {
    super.setUp()
    mockRecordManager = MockRecordManager()
    viewModel = RecordViewModel(recordManager: mockRecordManager)
  }
  
  override func tearDown() {
    viewModel = nil
    mockRecordManager = nil
    super.tearDown()
  }
  
  // MARK: - Initial State Tests
  func test_givenNewViewModel_whenInitialized_thenStateIsCorrectlySet() {
    // Then
    XCTAssertFalse(viewModel.state.isRecording)
    XCTAssertFalse(viewModel.state.canMoveToNext)
    XCTAssertEqual(viewModel.state.timeText, "00:00")
    XCTAssertFalse(viewModel.state.isErrorPresent)
    XCTAssertTrue(viewModel.state.isAuthorized)
  }
  
  // MARK: - Recording State Tests
  func test_givenViewModel_WhenStartRecording_ThenStateUpdatesCorrectly() {
    // When
    viewModel.action(.startRecording)
    
    // Then
    XCTAssertTrue(mockRecordManager.startRecordingCalled)
    XCTAssertTrue(viewModel.state.isRecording)
    XCTAssertFalse(viewModel.state.canMoveToNext)
  }
  
  func test_GivenRecordingState_WhenStopRecording_ThenStateUpdatesCorrectly() {
    // Given
    viewModel.action(.startRecording)
    
    // When
    viewModel.action(.stopRecording)
    
    // Then
    XCTAssertTrue(mockRecordManager.stopRecordingCalled)
    XCTAssertFalse(viewModel.state.isRecording)
    XCTAssertTrue(viewModel.state.canMoveToNext)
  }
  
  func test_GivenRecordedState_WhenRefresh_ThenStateResetsToInitial() {
    // Given
    viewModel.action(.startRecording)
    viewModel.action(.stopRecording)
    
    // When
    viewModel.action(.refresh)
    
    // Then
    XCTAssertTrue(mockRecordManager.resetAllCalled)
    XCTAssertFalse(viewModel.state.isRecording)
    XCTAssertFalse(viewModel.state.canMoveToNext)
    XCTAssertEqual(viewModel.state.timeText, "00:00")
  }
  
  // MARK: - Error Handling Tests
  func test_GivenErrorState_WhenClearError_ThenErrorStateIsFalse() {
    // Given
    viewModel.state.isErrorPresent = true
    
    // When
    viewModel.action(.clearError)
    
    // Then
    XCTAssertFalse(viewModel.state.isErrorPresent)
  }
  
  func test_GivenNoVoiceData_WhenRequestVoiceData_ThenErrorStateIsTrue() {
    // Given
    mockRecordManager.voice = nil
    
    // When
    let voice = viewModel.voiceData()
    
    // Then
    XCTAssertNil(voice)
    XCTAssertTrue(viewModel.state.isErrorPresent)
  }
  
  func test_GivenViewModel_WhenRequestRecognizedText_ThenReturnsManagerText() {
    // Given
    let testText = "Test recognized text"
    mockRecordManager.recognizedText = testText
    
    // When
    let recognizedText = viewModel.recognizedTextData()
    
    // Then
    XCTAssertEqual(recognizedText, testText)
  }
  
  // MARK: - Complete Recording Flow Test
  func test_GivenInitialState_WhenPerformRecordingSequence_ThenStateTransitionsCorrectly() async {
    // Given
    XCTAssertFalse(viewModel.state.isRecording)
    XCTAssertFalse(viewModel.state.canMoveToNext)
    
    // When
    viewModel.action(.startRecording)
    
    // Then
    XCTAssertTrue(mockRecordManager.setupSpeechCalled)
    XCTAssertTrue(mockRecordManager.startRecordingCalled)
    XCTAssertTrue(viewModel.state.isRecording)
    XCTAssertFalse(viewModel.state.canMoveToNext)
    
    // When
    viewModel.action(.stopRecording)
    
    // Then
    XCTAssertTrue(mockRecordManager.stopRecordingCalled)
    XCTAssertFalse(viewModel.state.isRecording)
    XCTAssertTrue(viewModel.state.canMoveToNext)
  }
}
