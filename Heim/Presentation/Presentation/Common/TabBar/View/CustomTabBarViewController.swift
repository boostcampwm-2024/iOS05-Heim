//
//  CustomTabBarViewController.swift
//  Presentation
//
//  Created by 박성근 on 11/7/24.
//

import UIKit
import SnapKit

final class CustomTabBarViewController: UIViewController, Coordinatable {
  // MARK: - Properties
  weak var coordinator: DefaultTabBarCoordinator?
  let tabBarView = CustomTabBarView()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    switchView(.home)
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
    case .mic: coordinator?.setRecordView()  
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
