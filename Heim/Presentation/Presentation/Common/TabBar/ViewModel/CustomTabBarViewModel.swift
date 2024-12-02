//
//  CustomTabBarViewModel.swift
//  Presentation
//
//  Created by 한상진 on 12/2/24.
//

import Foundation
import Combine
import Domain

public final class CustomTabBarViewModel: ViewModel {
  // MARK: - Properties
  public enum Action {
    case fetchTodayDiary
  }
  
  public struct State: Equatable {
    var isEnableWriteDiary: Bool
  }
  
  let useCase: DiaryUseCase
  @Published public var state: State
  
  // MARK: - Initializer
  init(useCase: DiaryUseCase) {
    self.useCase = useCase
    state = State(isEnableWriteDiary: false)
  }
  
  // MARK: - Methods
  public func action(_ action: Action) {
    switch action {
    case .fetchTodayDiary: fetchTodayDiary()
    }
  }
}

private extension CustomTabBarViewModel {
  func fetchTodayDiary() {
    Task.detached { [weak self] in
      do {
        let date = Date()
        let todayDiary = try await self?.useCase.readDiaries(calendarDate: date.calendarDate()) ?? []
        let isEnable = todayDiary.filter { $0.calendarDate.day == date.calendarDate().day }.isEmpty
        self?.state.isEnableWriteDiary = isEnable
      } catch {
        self?.state.isEnableWriteDiary = true
      }
    }
  }
}
