//
//  HomeView.swift
//  Presentation
//
//  Created by 김미래 on 11/6/24.
//

import Domain
import UIKit
import SnapKit

public final class HomeViewController: BaseViewController<HomeViewModel>, Coordinatable {
  // MARK: - Properties
  weak var coordinator: DefaultHomeCoordinator?
  
  // MARK: - UI Components
  private let calendarView = CalendarView()
  
  private let settingButton: UIButton = {
    let button = UIButton()
    button.setImage(.settingIcon, for: .normal)
    return button
  }()
  
  // MARK: - LifeCycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupLayoutConstraints()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    viewModel.action(.fetchDiaryData(date: calendarView.provideCurrentCalendarDate()))
  }
  
  deinit {
    coordinator?.didFinish()
  }
  
  // MARK: - Methods
  public override func setupViews() {
    super.setupViews()
    
    calendarView.delegate = self
    settingButton.addTarget(self, action: #selector(settingButtonDidTap), for: .touchUpInside)
    
    view.addSubview(calendarView)
    view.addSubview(settingButton)
  }
  
  public override func setupLayoutConstraints() {
    super.setupLayoutConstraints()
    
    calendarView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    settingButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.trailing.equalToSuperview().inset(16)
    }
  }
  
  override func bindState() {
    super.bindState()
    
    viewModel.$state
      .map { $0.diaries }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.calendarView.updateDiaries($0)
      }
      .store(in: &cancellable)
  }
}

// MARK: - Private Extenion
private extension HomeViewController {
  @objc func settingButtonDidTap() {
    coordinator?.pushSettingView()
  }
}

// MARK: - CalendarDelegate
extension HomeViewController: CalendarDelegate {
  func previousMonthButtonDidTap(_ button: UIButton, date: CalendarDate) {
    viewModel.action(.fetchDiaryData(date: date))
  }
  
  func nextMonthButtonDidTap(_ button: UIButton, date: CalendarDate) {
    viewModel.action(.fetchDiaryData(date: date))
  }
  
  func collectionViewCellDidTap(
    _ collectionView: UICollectionView,
    diary: Diary?
  ) {
    guard let diary else { return }
    
    coordinator?.pushDiaryDetailView(diary: diary)
  }
}
