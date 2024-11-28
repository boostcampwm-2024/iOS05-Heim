//
//  HomeViewModel.swift
//  Presentation
//
//  Created by 한상진 on 11/27/24.
//

import Combine
import Core
import Domain

public final class HomeViewModel: ViewModel {
  // MARK: - Properties
  public enum Action {
    case fetchDiaryData(date: CalendarDate)
  }
  
  public struct State: Equatable {
    var diaries: [Diary]
  }
  
  let useCase: DiaryUseCase
  @Published public var state: State
  
  // MARK: - Initializer
  init(useCase: DiaryUseCase) {
    self.useCase = useCase
    state = State(diaries: [])
  }
  
  // MARK: - Methods
  public func action(_ action: Action) {
    switch action {
    case .fetchDiaryData(let date): fetchDiaryData(date: date)
    }
  }
}

// MARK: - Private Extenion
private extension HomeViewModel {
  func fetchDiaryData(date: CalendarDate) {
    Task.detached { [weak self] in
      do {
        let diaries = try await self?.useCase.readDiaries(calendarDate: date)
        self?.state.diaries = diaries ?? []
      } catch {
        self?.state.diaries = []
      }
    }
  }
}
