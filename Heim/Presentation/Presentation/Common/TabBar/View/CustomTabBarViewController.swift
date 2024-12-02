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
      .map(\.recordPermissionStatus)
      .compactMap { $0 }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] status in
        self?.handleRecordPermission(status)
      }
      .store(in: &cancellable)
    
    viewModel.$state
      .map { $0.isEnableWriteDiary }
      .dropFirst()
      .filter { _ in
        self.viewModel.state.recordPermissionStatus != .denied
      }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isEnable in
        if !isEnable {
          self?.coordinator?.setRecordView()
        } else {
          self?.presentAlert(
            type: .alreadyWrittenDiary, 
            leftButtonAction: {}
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
    case .mic: viewModel.action(.startRecording)
    case .report: coordinator?.setReportView()
    }
  }
  
  private func handleRecordPermission(_ status: RecordManager.PermissionStatus) {
    switch status {
    case .authorized:
      // 권한이 있는 경우 아무 것도 하지 않음 (일기 작성 가능 여부 확인 대기)
      break
    case .notDetermined:
      coordinator?.setRecordView() // 녹음 화면에서 권한 요청
    case .denied:
      presentAlert(
        type: .permissionDenied,
        leftButtonAction: { },
        rightButtonAction: { [weak self] in
          guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
          UIApplication.shared.open(url)
          self?.viewModel.state.recordPermissionStatus = nil
        }
      )
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
