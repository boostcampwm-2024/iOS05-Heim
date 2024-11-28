//
//  AnalyzeResultViewModel.swift
//  Presentation
//
//  Created by 박성근 on 11/27/24.
//

import Combine
import Core
import Domain
import Foundation

final class AnalyzeResultViewModel: ViewModel {
  // MARK: - Properties
  enum Action {
    case fetchDiary
    case saveDiary
  }
  
  struct State: Equatable {
    var description: String = ""
    var content: String = ""
    var isSaved: Bool = false
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
      setupInitialState()
    case .saveDiary:
      Task {
        await handleSaveDiary()
        state.isSaved = true
      }
    }
  }
}

// MARK: - Private Extenion
private extension AnalyzeResultViewModel {
  // TODO: 현재 timeStamp를 직접 생성하여 코드가 길어져 메서드를 따로 분리
  func handleSaveDiary() async {
    // TODO: date 선언해서 파라미터로 넣는 것이 아닌 diary.id로 변경(미정)
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMddHHmmss"
    let timeStamp = dateFormatter.string(from: date)
    do {
//      try await useCase.saveDiary(timeStamp: timeStamp, data: diary)
    } catch {
      // TODO: Error Handling
    }
  }
  
  func setupInitialState() {
    // TODO:
    state.description = diary.emotion.rawValue
    state.content = diary.emotionReport.text
  }
}

