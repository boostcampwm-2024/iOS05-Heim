//
//  CustomTabBarViewModel.swift
//  Presentation
//
//  Created by 박성근 on 11/7/24.
//

import Combine
import os

final class CustomTabBarViewModel: ViewModel {
  // MARK: - Types
  enum Action {
    case tabButtonDidTap(TabBarItem)
    case micButtonDidTap
  }
  
  struct State {
    var currentTab: TabBarItem
  }
  
  // MARK: - Properties
  @Published var state: State
  
  // TODO: Usecase protocol을 주입받아 사용할 수 있도록 수정
  init() {
    self.state = State(currentTab: .home)
  }
  
  // MARK: - Action Handler
  func action(_ action: Action) {
    switch action {
    case .tabButtonDidTap(let tab):
      handleTabSelection(tab)
      
    case .micButtonDidTap:
      handleMicButtonTapped()
    }
  }
}

private extension CustomTabBarViewModel {
  func handleTabSelection(_ tab: TabBarItem) {
    guard tab != state.currentTab else { return }
    
    self.state.currentTab = tab
  }
  
  func handleMicButtonTapped() {
    // TODO: Mic 버튼 클릭 시 처리할 로직 구현
  }
}
