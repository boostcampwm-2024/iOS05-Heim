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
    case moveToNext
  }
  
  struct State: Equatable {
    var isRecording: Bool = false
    var canMoveToNext: Bool = false
    var timeText: String = "00:00"
    var isPaused: Bool = false
  }
  
  @Published var state: State
  private var recordManager: RecordManager
  private var timer: Timer?
  
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
    case .moveToNext:
      handleMoveToNext()
    }
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
    state.isPaused = true
    stopTimeObservation()
  }
  
  func handleRefresh() {
    recordManager.resetAll()
    stopTimeObservation()
    state = State()
  }
  
  func handleMoveToNext() {
    recordManager.resetAll()
    // TODO: 다음 화면과 연결
  }
  
  func startTimeObservation() {
    stopTimeObservation()
    
    if !state.isPaused {
      state.timeText = "00:00"
    }
    state.isPaused = false
    
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
