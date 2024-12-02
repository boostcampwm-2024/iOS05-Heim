//
//  RecordViewModel.swift
//  Presentation
//
//  Created by 박성근 on 11/17/24.
//

import Combine
import Core
import Domain
import Foundation

public final class RecordViewModel: ViewModel {
  // MARK: - Properties
  public enum Action {
    case startRecording
    case stopRecording
    case refresh
    case clearError
  }
  
  public struct State: Equatable {
    var isRecording: Bool = false
    var canMoveToNext: Bool = false
    var timeText: String = "00:00"
    var isErrorPresent: Bool = false
  }
  
  @Published public var state: State
  private var recordManager: RecordManager
  private var timer: Timer?
  
  private var isPaused: Bool = false
  private var voice: Voice?
  private var recognizedText: String?
  
  // MARK: - Initializer
  public init() {
    self.state = State()
    self.recordManager = RecordManager()
  }
  
  // MARK: - Methods
  public func action(_ action: Action) {
    switch action {
    case .startRecording:
      handleStartRecording()
    case .stopRecording:
      handleStopRecording()
    case .refresh:
      handleRefresh()
    case .clearError:
      state.isErrorPresent = false
    }
  }
  
  func voiceData() -> Voice? {
    guard let voice = voice else {
      state.isErrorPresent = true
      return nil
    }
    return voice
  }
  
  func recognizedTextData() -> String? {
    recognizedText = recordManager.recognizedText
    return recognizedText
  }
}

// MARK: - Private Extenion
private extension RecordViewModel {
  func handleStartRecording() {
    do {
      try recordManager.startRecording()
      state.isRecording = true
      state.canMoveToNext = false
      startTimeObservation()
    } catch {
      state.isErrorPresent = true
      recordManager.resetAll()
    }
  }
  
  func handleStopRecording() {
    recordManager.stopRecording()
    state.isRecording = false
    state.canMoveToNext = true
    isPaused = true
    voice = recordManager.voice
    stopTimeObservation()
  }
  
  func handleRefresh() {
    recordManager.resetAll()
    stopTimeObservation()
    state = State()
  }
  
  func startTimeObservation() {
    stopTimeObservation()
    
    isPaused = false
    
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      self.state.timeText = self.recordManager.formattedTime
    }
  }
  
  func stopTimeObservation() {
    timer?.invalidate()
    timer = nil
  }
}
