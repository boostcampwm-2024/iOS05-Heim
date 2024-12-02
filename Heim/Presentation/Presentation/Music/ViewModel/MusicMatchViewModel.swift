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
    case isError
  }

  struct State: Equatable {
    var isrc: String?
    var isError: Bool
  }

  let useCase: MusicUseCase
  @Published var state: State

  // MARK: - Initializer
  init(useCase: MusicUseCase) {
    self.useCase = useCase
    self.state = State(isrc: nil, isError: false)
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
    case .isError:
      state.isError = false
    }
  }
}

// MARK: - Private Extenion
private extension MusicMatchViewModel {
  func playMusic(track: String) async {
    do {
      try await useCase.play(to: track)
      state.isrc = track
    } catch {
      state.isError = true
    }
  }
  
  func pauseMusic() async {
    do {
      try useCase.pause()
    } catch {
      state.isError = true
    }
  }
}
