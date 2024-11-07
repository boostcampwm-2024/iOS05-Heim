//
//  CustomTabBarViewModel.swift
//  Presentation
//
//  Created by 박성근 on 11/7/24.
//

import UIKit
import Combine
import os

final public class CustomTabBarViewModel: ViewModel {
  // MARK: - Types
  public enum Action {
    case tabSelected(TabBarItem)
    case micButtonTapped
  }
  
  public struct State {
    var currentTab: TabBarItem
    
    public init(
      currentTab: TabBarItem = .home
    ) {
      self.currentTab = currentTab
    }
  }
  
  // MARK: - Properties
  @Published private(set) public var state: State
  
  // TODO: Usecase protocol을 주입받아 사용할 수 있도록 수정
  public init() {
    self.state = State()
  }
  
  // MARK: - Action Handler
  public func action(
    _ action: Action
  ) {
    switch action {
    case .tabSelected(let tab):
      handleTabSelection(tab)
      
    case .micButtonTapped:
      handleMicButtonTapped()
    }
  }
}

extension CustomTabBarViewModel {
  private func handleTabSelection(
    _ tab: TabBarItem
  ) {
    guard tab != state.currentTab else { return }
    
    self.state.currentTab = tab
  }
  
  private func handleMicButtonTapped() {
    // TODO: Mic 버튼 클릭 시 처리할 로직 구현
  }
}
