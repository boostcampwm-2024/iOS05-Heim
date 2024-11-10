//
//  CustomTabBarViewController.swift
//  Presentation
//
//  Created by 박성근 on 11/7/24.
//

import UIKit
import SnapKit

final class CustomTabBarViewController: BaseViewController<CustomTabBarViewModel> {
  // MARK: - Properties
  private let tabBarView = CustomTabBarView()
  
  // MARK: - Lifecycle
  override func setupViews() {
    super.setupViews()
    tabBarView.delegate = self
    view.addSubview(tabBarView)
  }
  
  override func setupLayoutConstraints() {
    super.setupLayoutConstraints()
    
    tabBarView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func bindState() {
    viewModel.$state
      .sink { [weak self] state in
        self?.updateUI(with: state)
      }
      .store(in: &cancellable)
  }
}

extension CustomTabBarViewController {
  private func updateUI(with state: CustomTabBarViewModel.State) {
    tabBarView.setSelectedTab(state.currentTab.selectedIdx)
  }
}

extension CustomTabBarViewController: CustomTabBarViewDelegate {
  func didButtonTap(_ item: TabBarItem) {
    (item == .mic) ? viewModel.action(.micButtonTapped) : viewModel.action(.tabSelected(item))
  }
}
