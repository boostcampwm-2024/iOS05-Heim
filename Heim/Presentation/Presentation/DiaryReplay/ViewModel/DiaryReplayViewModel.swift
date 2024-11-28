//
//  DiaryReplayViewModel.swift
//  Presentation
//
//  Created by 정지용 on 11/28/24.
//

import Foundation

public final class DiaryReplayViewModel: ViewModel {
  // MARK: - Properties
  public enum Action {
    case play
    case pause
    case reset
    case updateState(data: Data)
  }
  
  public struct State {
    var recordFile: Data?
    var isPlaying: Bool = false
    var currentTime: String = "00:00"
  }
  
  @Published public var state: State
  var diaryReplayManager: DiaryReplayManager?
  private var timer: Timer?
  
  public init() {
    self.state = State()
  }
  
  public func action(_ action: Action) {
    switch action {
    case .play:
      handlePlay()
    case .pause:
      diaryReplayManager?.pause()
      state.isPlaying = false
    case .reset:
      diaryReplayManager?.reset()
      state.currentTime = "00:00"
      state.isPlaying = false
    case .updateState(let data):
      updateState(with: data)
    }
  }
  
  func startTimeObservation() {
    stopTimeObservation()
    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
      guard let self else { return }
      self.state.currentTime = self.diaryReplayManager?.currentTime ?? "00:00"
    }
  }
  
  func stopTimeObservation() {
    timer?.invalidate()
    timer = nil
  }
}

// MARK: - Private Extenion
private extension DiaryReplayViewModel {
  func updateState(with data: Data) {
    do {
      state.recordFile = data
      diaryReplayManager = try DiaryReplayManager(data: data)
      state.isPlaying = true
    } catch {
      // TODO: 사용자에게 전파
    }
  }
  
  func handlePlay() {
    Task {
      await diaryReplayManager?.play()
    }
  }
}
