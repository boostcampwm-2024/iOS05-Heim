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
    case musicRecommendation
    case heimReply
    case replayVoice
    case close
  }
  
  struct State: Equatable {
    var date: String = ""
    var description: String = ""
    var content: String = ""
  }
  
  @Published var state: State
  // private let useCase: DataStorageUseCase
  private let timeStamp: String
  
  // MARK: - Initializer
  init(
    // useCase: DataStorageUseCase
    timeStamp: String
  ) {
    // self.useCase = useCase
    state = State()
    self.timeStamp = timeStamp
  }
  
  // MARK: - Methods
  func action(_ action: Action) {
    switch action {
    case .musicRecommendation, .heimReply, .replayVoice, .close:
      break
    }
  }
  
  // TODO: 기능 구현
  func setUp() async {
    state.date = timeStamp
//    do {
//      let diary = try await useCase.readDiary(timeStamp: timeStamp)
//      state.date = timeStamp // 20241121만 추출하도록
//      state.description = diary.emotion
//      state.content = diary.Summary.text
//    } catch {
//      // TODO: Error Handling
//    }
  }
}

// MARK: - Private Extenion
private extension SettingViewModel {
  
}
