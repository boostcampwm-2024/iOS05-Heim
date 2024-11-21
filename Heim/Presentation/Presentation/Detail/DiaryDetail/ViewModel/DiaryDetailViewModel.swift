//
//  DiaryDetailViewModel.swift
//  Presentation
//
//  Created by 박성근 on 11/19/24.
//

import Combine
import Core
import Domain

final class DiaryDetailViewModel: ViewModel {
  // MARK: - Properties
  enum Action {
    case fetchDiary
    case musicRecommendation
    case heimReply
    case replayVoice
  }
  
  struct State: Equatable {
    var date: String = ""
    var description: String = ""
    var content: String = ""
  }
  
  @Published var state: State
  // private let useCase: DataStorageUseCase
  private let diary: Diary
  
  // MARK: - Initializer
  init(
    // useCase: DataStorageUseCase
    diary: Diary
  ) {
    // self.useCase = useCase
    state = State()
    self.diary = diary
  }
  
  // MARK: - Methods
  func action(_ action: Action) {
    switch action {
    case .fetchDiary:
      Task {
        await setUp()
      }
    case .musicRecommendation, .heimReply, .replayVoice:
      break
    }
  }
  
  // TODO: 기능 구현
  func setUp() async {
//    state.date = diary.date
//    state.description = diary.emotion.rawValue
//    state.content = diary.summary.text
  }
}

// MARK: - Private Extenion
private extension SettingViewModel {
  
}
