//
//  MusicMatchViewModel.swift
//  Presentation
//
//  Created by 김미래 on 11/27/24.
//

import Combine
import Core
import Domain

final class MusicMatchViewModel: ViewModel {
  // MARK: - Properties
  enum Action {
    case playMusic(String)
    case pauseMusic
  }

  struct State: Equatable {
    var currentTrack: String?
  }

  let useCase: MusicUseCase
  @Published var state: State

  // MARK: - Initializer
  init(useCase: MusicUseCase) {
    self.useCase = useCase
    self.state = State(currentTrack: nil)
  }

  func action(_ action: Action) {
    switch action {
    case .playMusic(let track):
      Task {
        await playMusic(track: track)
      }

    case .pauseMusic:
      Task {
        await pauseMusic()
      }
    }
  }
}

// MARK: - Private Extenion
private extension MusicMatchViewModel {
  func playMusic(track: String) async {
    do {
      try await useCase.play(to: track)
      state.currentTrack = track
      print("재생됨")
    } catch {
      // TODO: Error 처리
    }
  }
  func pauseMusic() async {
    do {
      try useCase.pause()
      print("여기까지옴")
//      state.isPlaying = false
    } catch {
      // TODO: Error 처리
      print("여기까지옴~~~~")
    }

  }
}
