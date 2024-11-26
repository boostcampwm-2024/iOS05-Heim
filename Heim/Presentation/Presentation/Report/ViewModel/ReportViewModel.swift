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
    //TODO: 수정
    case fetchData
  }

  struct EmotionCount: Equatable {
    var sadnessCount: Int
    var happinessCount: Int
    var surpriseCount: Int
    var fearCount: Int
    var disgustCount: Int
    var neutralCount: Int
    var angryCount: Int
  }

  struct State: Equatable {
    var userName: String
    var totalCount: Int
    var sequenceCount: Int
    var monthCount: Int
    var emotionCount: EmotionCount
    var emotion: String
    var reply: String
  }

// TODO: UseCase 추가
  @Published var state: State

  // MARK: - Initializer
  // TODO: Initializer에 UseCase 추가
  init() {
    self.state = State(userName: "미래",
                       totalCount: 0,
                       sequenceCount: 0,
                       monthCount: 0,
                       emotionCount: EmotionCount(sadnessCount: 0,
                                                  happinessCount: 0,
                                                  surpriseCount: 0,
                                                  fearCount: 0,
                                                  disgustCount: 0,
                                                  neutralCount: 0,
                                                  angryCount: 0),
                       emotion: "",
                       reply: "답장이 도착하지 않았어요!")
  }

  func action(_ action: Action) {
    switch action {
    case .fetchData:
      fetchData()
    }
  }
}

// MARK: - Private Extenion
private extension ReportViewModel {
  func fetchData() {}
}
