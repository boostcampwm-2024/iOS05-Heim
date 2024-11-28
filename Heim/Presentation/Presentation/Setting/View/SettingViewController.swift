//
//  SettingViewController.swift
//  Presentation
//
//  Created by 한상진 on 11/7/24.
//

import Domain
import UIKit

final class SettingViewController: BaseViewController<SettingViewModel>, Coordinatable {
  // MARK: - Properties
  weak var coordinator: DefaultSettingCoordinator?
  
  private let settingTableView: UITableView = {
    let tableView = UITableView(frame: .zero)
    tableView.backgroundColor = .clear
    tableView.sectionHeaderTopPadding = 0
    tableView.registerCellClass(cellType: SettingTableViewCell.self)
    tableView.separatorStyle = .none
    return tableView
  }()
  
  private let settingTableViewDataSources = SettingItem.defaultItems()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.action(.fetchUserName)
    viewModel.action(.fetchSynchronizationState)
  }
  
  deinit {
    coordinator?.didFinish()
  }
  
  // MARK: - Methods
  override func setupViews() {
    super.setupViews()
    
    settingTableView.delegate = self
    settingTableView.dataSource = self
    view.addSubview(settingTableView)
  }
  
  override func setupLayoutConstraints() {
    super.setupLayoutConstraints()
    
    settingTableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bindState() {
    super.bindState()
    
    viewModel.$state
      .map { $0.userName }
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] userName in
        guard let nameCell = self?.settingTableView.cellForRow(
          at: IndexPath(row: 0, section: 0)
        ) as? SettingTableViewCell else { return }
        
        nameCell.updateUserName(userName)
      }
      .store(in: &cancellable)
  }
}

extension SettingViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    switch indexPath.row {
    case 0: // 이름
      presentNameAlert()
    case 1: // 캐시 삭제
      presentRemoveCacheAlert()
    case 2: // 데이터 초기화
      presentDataResetAlert()
    case 4: // 문의하기
      coordinator?.openQuestionURL()
    default:
      return
    }
  }
}

extension SettingViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return settingTableViewDataSources.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard indexPath.row < settingTableViewDataSources.count else { return UITableViewCell() }
    
    let imageTitle = settingTableViewDataSources[indexPath.row].icon.rawValue
    let iconImage = UIImage.presentationAsset(named: imageTitle, bundleClassType: Self.self)
    let titleText = settingTableViewDataSources[indexPath.row].title
    
    guard let cell = tableView.dequeueReusableCell(cellType: SettingTableViewCell.self, indexPath: indexPath) else {
      return UITableViewCell()
    }
    cell.configure(iconImage: iconImage, titleText: titleText)
    
    switch indexPath.row {
    case 0: // 이름
      cell.setupNameLabel(name: viewModel.state.userName)
    case 3: // 앱 버전
      cell.setupVersionLabel()
    default: 
      return cell
    }
    
    return cell
  }
}

extension SettingViewController: CloudSwitchDelegate {
  func didChangedValue(
    _ cloudSwitch: UISwitch, 
    isOn: Bool
  ) {
    // TODO: iCloud 연동 후 구현 예정
//    viewModel.action(.updateSynchronizationState(isOn))
  }
}

extension SettingViewController: Alertable {
  func presentNameAlert() {
    presentNameAlert { [weak self] textFieldText in
      self?.viewModel.action(.updateUserName(textFieldText))
    }
  }
  
  func presentRemoveCacheAlert() {
    presentAlert(
      type: .removeCache,
      leftButtonAction: {},
      rightButtonAction: { [weak self] in
        self?.viewModel.action(.removeCache)
      }
    )
  }
  
  func presentDataResetAlert() {
    presentAlert(
      type: .removeData,
      leftButtonAction: {},
      rightButtonAction: { [weak self] in
        self?.viewModel.action(.resetData)
      }
    )
  }
}
