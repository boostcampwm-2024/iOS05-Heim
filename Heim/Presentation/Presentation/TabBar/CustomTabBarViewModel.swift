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
    case setViewControllers([UIViewController])
    case selectTab(Int)
    case centerButtonDidTap
  }
  
  public struct State {
    var currentIndex: Int
    var previousIndex: Int
    var viewControllers: [UIViewController]
    var tabItems: [(icon: String, title: String)]
    
    init(
      currentIndex: Int = 0,
      previousIndex: Int = 0,
      viewControllers: [UIViewController] = [],
      tabItems: [(icon: String, title: String)] = [
        (icon: "house.fill", title: "Home"),
        (icon: "chart.bar.fill", title: "통계")
      ]
    ) {
      self.currentIndex = currentIndex
      self.previousIndex = previousIndex
      self.viewControllers = viewControllers
      self.tabItems = tabItems
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
    case .setViewControllers(let viewControllers):
      setViewControllers(viewControllers)
      
    case .selectTab(let index):
      selectTab(at: index)
      
    case .centerButtonDidTap:
      // TODO: Center Button Action 추가
      break
    }
  }
}

extension CustomTabBarViewModel {
  private func setViewControllers(
    _ viewControllers: [UIViewController]
  ) {
    guard viewControllers.count == state.tabItems.count else {
      os_log("Failed to set view controllers: count mismatch with tab items")
      return
    }
    
    state.viewControllers = viewControllers
  }
  
  private func selectTab(
    at index: Int
  ) {
    guard state.viewControllers.indices.contains(index) else {
      os_log("Failed to select tab: index \(index) is out of bounds")
      return
    }
    
    state.previousIndex = state.currentIndex
    state.currentIndex = index
  }
}
