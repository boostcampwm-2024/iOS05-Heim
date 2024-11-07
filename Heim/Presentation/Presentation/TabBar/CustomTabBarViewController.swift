//
//  CustomTabBarViewController.swift
//  Presentation
//
//  Created by 박성근 on 11/7/24.
//

import UIKit
import SnapKit

public final class CustomTabBarViewController: BaseViewController<CustomTabBarViewModel> {
  // MARK: - Properties
  private let tabBarView = CustomTabBarView()
  
  // MARK: - Lifecycle
  public override func setupViews() {
    super.setupViews()
    tabBarView.delegate = self
    view.addSubview(tabBarView)
  }
  
  public override func setupLayoutConstraints() {
    super.setupLayoutConstraints()
    
    tabBarView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  public override func bindState() {
    viewModel.$state
      .sink { [weak self] state in
        self?.updateUI(with: state)
      }
      .store(in: &cancellable)
  }
}

extension CustomTabBarViewController: CustomTabBarViewDelegate {
  public func didButtonTap(
    _ item: TabBarItem
  ) {
    (item == .mic) ? viewModel.action(.micButtonTapped) : viewModel.action(.tabSelected(item))
  }
}

extension CustomTabBarViewController {
  private func updateUI(
    with state: CustomTabBarViewModel.State
  ) {
    tabBarView.setSelectedTab(state.currentTab.selectedIdx)
  }
}
