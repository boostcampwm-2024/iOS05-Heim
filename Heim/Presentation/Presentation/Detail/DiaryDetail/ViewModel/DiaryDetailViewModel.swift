//
//  DiaryDetailViewModel.swift
//  Presentation
//
//  Created by 박성근 on 11/19/24.
//

import Combine
import Core
import Domain
import Foundation

final class DiaryDetailViewModel: ViewModel {
  // MARK: - Properties
  enum Action {
    case fetchDiary
    case deleteDiary
  }
  
  struct State: Equatable {
    var date: String = ""
    var description: String = ""
    var content: String = ""
    var isDeleted: Bool = false
  }
  
  @Published var state: State
  private let useCase: DiaryUseCase
  private let diary: Diary
  
  // MARK: - Initializer
  init(
    useCase: DiaryUseCase,
    diary: Diary
  ) {
    state = State()
    self.useCase = useCase
    self.diary = diary
  }
  
  // MARK: - Methods
  func action(_ action: Action) {
    switch action {
    case .fetchDiary:
      setUp()
    case .deleteDiary:
      Task {
        await handleDeleteDiary()
        state.isDeleted = true
      }
    }
  }
}

// MARK: - Private Extenion
private extension DiaryDetailViewModel {
  // TODO: 현재 timeStamp를 직접 생성하여 코드가 길어져 메서드를 따로 분리
  func handleDeleteDiary() async {
    // TODO: date 선언해서 파라미터로 넣는 것이 아닌 diary.id로 변경(미정)
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMddHHmmss"
    let timeStamp = dateFormatter.string(from: date)
    do {
      try await useCase.deleteDiary(timeStamp: timeStamp)
    } catch {
      // TODO: Error Handling
    }
  }
  
  // TODO: 날짜 정보 초기화하는 기능 구현
  func setUp() {
    // state.date = diary.id
    state.description = diary.emotion.rawValue
    state.content = diary.summary.text
  }
}
