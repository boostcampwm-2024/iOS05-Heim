//
//  MockRecordManager.swift
//  PresentationTests
//
//  Created by 박성근 on 12/5/24.
//

import Foundation
import Presentation
import Domain

class MockRecordManager: RecordManagerProtocol {
  var recognizedText: String = ""
  var minuteAndSeconds: Int = 0
  var voice: Voice?
  
  var formattedTime: String {
    let minutes = minuteAndSeconds / 60
    let seconds = minuteAndSeconds % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  var setupSpeechCalled = false
  var startRecordingCalled = false
  var stopRecordingCalled = false
  var resetAllCalled = false
  
  func setupSpeech() async throws {
    setupSpeechCalled = true
  }
  
  func startRecording() throws {
    startRecordingCalled = true
  }
  
  func stopRecording() {
    stopRecordingCalled = true
  }
  
  func resetAll() {
    resetAllCalled = true
    recognizedText = ""
    minuteAndSeconds = 0
    voice = nil
  }
}
