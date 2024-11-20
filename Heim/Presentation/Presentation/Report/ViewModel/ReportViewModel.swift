//
//  ReportViewModel.swift
//  Presentation
//
//  Created by 김미래 on 11/20/24.
//

import Combine
import Core
import Domain

final class ReportViewModel: ViewModel {

  // MARK: - Properties
  enum Action {
    case fetchEmotion
  }

  struct State: Equatable {
    var emotion: String
  }

  let usecase: ReportUseCase
  @Published var state: State

  init(usecase: ReportUseCase) {
    self.usecase = usecase
    self.state = State(emotion: "기쁨")
  }

  func action(_ action: Action) {
    switch action {
    case .fetchEmotion: fetchEmotion()
    }
  }
}

// MARK: - Private Extenion
private extension ReportViewModel {
  func fetchEmotion() {
    Task {
      do {
        let emotion = try await usecase.fetchEmotions()
        state.emotion = emotion
      } catch {
        //TODO: 에러처리
      }
    }
  }
}
