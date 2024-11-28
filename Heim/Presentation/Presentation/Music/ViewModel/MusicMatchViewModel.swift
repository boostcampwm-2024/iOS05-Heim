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
    //TODO: 수정
    case playMusic
    case pauseMusic
  }

  struct State: Equatable {
    var isPlaying: Bool
  }

// TODO: UseCase 추가
  @Published var state: State

  // MARK: - Initializer
  init() {
    self.state = State(isPlaying: false)
  }

  func action(_ action: Action) {
    switch action {
    case .playMusic:
      playMusic()
    case .pauseMusic:
      pauseMusic()
    }
  }
}

// MARK: - Private Extenion
private extension MusicMatchViewModel {
  func playMusic() {}
  func pauseMusic() {}
}
