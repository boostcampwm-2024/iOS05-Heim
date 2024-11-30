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
    var isPlaying: Bool
  }

  let useCase: MusicUseCase
  @Published var state: State

  // MARK: - Initializer
  init(useCase: MusicUseCase) {
    self.useCase = useCase
    self.state = State(isPlaying: false)
  }

  func action(_ action: Action) {
    switch action {
    case .playMusic(let isrc):
      Task{
        await playMusic(isrc: isrc)
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
  func playMusic(isrc: String) async {
    do {
      try await useCase.play(to: isrc)
      state.isPlaying = true
    } catch {
      // TODO: Error 처리
    }
  }
  func pauseMusic() async {
    do {
      try useCase.pause()
      state.isPlaying = false
    } catch {
      // TODO: Error 처리
    }

  }
}
