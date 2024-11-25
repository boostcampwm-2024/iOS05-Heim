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

final class RecordViewModel: ViewModel {
  // MARK: - Properties
  enum Action {
    case startRecording
    case stopRecording
    case refresh
  }
  
  struct State {
    var isRecording: Bool = false
    var canMoveToNext: Bool = false
    var timeText: String = "00:00"
  }
  
  @Published var state: State
  private var recordManager: RecordManager
  private var timer: Timer?
  
  private var isPaused: Bool = false
  private var voice: Voice?
  
  // MARK: - Initializer
  init() {
    self.state = State()
    self.recordManager = RecordManager()
    
    Task {
      try await recordManager.setupSpeech()
    }
  }
  
  // MARK: - Methods
  func action(_ action: Action) {
    switch action {
    case .startRecording:
      handleStartRecording()
    case .stopRecording:
      handleStopRecording()
    case .refresh:
      handleRefresh()
    }
  }
  
  func voiceData() -> Voice? {
    return voice
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
      // TODO: 사용자에게 에러 전달
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
    
    if isPaused {
      state.timeText = "00:00"
    }
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
