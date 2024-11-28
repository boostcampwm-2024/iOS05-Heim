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
  }
  
  struct State: Equatable {
    var description: String = ""
    var content: String = ""
  }
  
  @Published var state: State
  private let useCase: DiaryUseCase
  private var diary: Diary
  
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
      handleSaveDiary()
    }
  }
}

// MARK: - Private Extenion
private extension AnalyzeResultViewModel {
  func handleSaveDiary() {
    Task.detached { [weak self] in
      do {
        guard let diary = self?.diary else { return }
        try await self?.useCase.saveDiary(data: diary)
      } catch {
        // TODO: Error Handling
      }
    }
  }
  
  func setupInitialState() {
    // TODO:
    state.description = diary.emotion.rawValue
    state.content = diary.emotionReport.text
  }
}

