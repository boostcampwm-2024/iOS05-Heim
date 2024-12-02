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
    var userName: String = ""
    var description: String = ""
    var content: String = ""
    var isErrorPresent: Bool = true
  }
  
  @Published var state: State
  private let diaryUseCase: DiaryUseCase
  private let userUseCase: UserUseCase
  private var diary: Diary
  
  // MARK: - Initializer
  init(
    diaryUseCase: DiaryUseCase,
    userUseCase: UserUseCase,
    diary: Diary
  ) {
    state = State()
    self.diaryUseCase = diaryUseCase
    self.userUseCase = userUseCase
    self.diary = diary
  }
  
  // MARK: - Methods
  func action(_ action: Action) {
    switch action {
    case .fetchDiary:
      Task {
        await setupInitialState()
        handleSaveDiary()
      }
    }
  }
}

// MARK: - Private Extenion
private extension AnalyzeResultViewModel {
  func handleSaveDiary() {
    Task.detached { [weak self] in
      do {
        guard let diary = self?.diary else { return }
        try await self?.diaryUseCase.saveDiary(data: diary)
      } catch {
        self?.state.isErrorPresent = true
      }
    }
  }
  
  func setupInitialState() async {
    do {
      state.userName = try await userUseCase.fetchUserName()
      state.description = diary.emotion.rawValue
      state.content = diary.emotionReport.text
    } catch {
      state.userName = "User"
      state.description = diary.emotion.rawValue
      state.content = diary.emotionReport.text
    }
  }
}

