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
    var calendarDate: String = ""
    var description: String = ""
    var content: String = ""
    var isDeleted: Bool = false
    var isErrorPresent: Bool = true
  }
  
  @Published var state: State
  private let diaryUseCase: DiaryUseCase
  private let userUseCase: UserUseCase
  var userName: String = ""
  let diary: Diary
  
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
      }
    case .deleteDiary:
      Task {
        await handleDeleteDiary()
      }
    }
  }
}

// MARK: - Private Extenion
private extension DiaryDetailViewModel {
  func handleDeleteDiary() async {
    do {
      try await diaryUseCase.deleteDiary(calendarDate: diary.calendarDate)
      state.isDeleted = true
    } catch {
      state.isErrorPresent = true
    }
  }
  
  func setupInitialState() async {
    do {
      userName = try await userUseCase.fetchUserName()
      state.calendarDate = "\(diary.calendarDate.year)년 \(diary.calendarDate.month)월 \(diary.calendarDate.day)일"
      state.description = diary.emotion.diaryDetailDescription(with: userName)
      state.content = diary.summary.text
    } catch {
      userName = "User"
      state.calendarDate = "\(diary.calendarDate.year)년 \(diary.calendarDate.month)월 \(diary.calendarDate.day)일"
      state.description = diary.emotion.diaryDetailDescription(with: userName)
      state.content = diary.summary.text
    }
  }
}
