//
//  CustomTabBarViewController.swift
//  Presentation
//
//  Created by 박성근 on 11/7/24.
//

import UIKit
import SnapKit

final class CustomTabBarViewController: BaseViewController<CustomTabBarViewModel>, Alertable, Coordinatable {
  // MARK: - Properties
  weak var coordinator: DefaultTabBarCoordinator?
  let tabBarView = CustomTabBarView()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    switchView(.home)
  }
  
  override func bindState() {
    super.bindState()
    
    viewModel.$state
      .map { $0.isEnableWriteDiary }
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isEnable in
        if isEnable {
          self?.coordinator?.setRecordView()
        } else {
          self?.presentAlert(
            type: .alreadyWrittenDiary, 
            leftButtonAction: { }
          )
        }
      }
      .store(in: &cancellable)
  }
}

private extension CustomTabBarViewController {
  func setupUI() {
    tabBarView.delegate = self
    view.addSubview(tabBarView)
    
    tabBarView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalToSuperview()
    }
  }
  
  func switchView(_ tabBarItem: TabBarItems) {
    switch tabBarItem {
    case .home: coordinator?.setHomeView()
    case .mic: viewModel.action(.fetchTodayDiary)
    case .report: coordinator?.setReportView()
    }
  }
}

extension CustomTabBarViewController: CustomTabBarViewDelegate {
  func buttonDidTap(
    _ tabBarView: CustomTabBarView,
    item: TabBarItems
  ) {
    switchView(item)
  }
}
