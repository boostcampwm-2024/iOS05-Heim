//
//  HomeView.swift
//  Presentation
//
//  Created by 김미래 on 11/6/24.
//

import Domain
import UIKit
import SnapKit

public final class HomeViewController: UIViewController, Coordinatable {
  // MARK: - Properties
  weak var coordinator: DefaultHomeCoordinator?
  
  // MARK: - UI Components
  private let calendarView = CalendarView()
  
  private let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = .background
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
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
}

// MARK: - Private Extenion
private extension HomeViewController {
  func setupViews() {
    calendarView.delegate = self
    settingButton.addTarget(self, action: #selector(settingButtonDidTap), for: .touchUpInside)
    
    view.addSubview(backgroundImageView)
    view.addSubview(calendarView)
    view.addSubview(settingButton)
  }
  
  func setupLayoutConstraints() {
    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    calendarView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    settingButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.trailing.equalToSuperview().inset(16)
    }
  }
  
  @objc func settingButtonDidTap() {
    coordinator?.pushSettingView()
  }
}

// MARK: - CalendarDelegate
extension HomeViewController: CalendarDelegate {
  func collectionViewCellDidTap(
    _ collectionView: UICollectionView,
    diary: Diary
  ) {
    coordinator?.pushDiaryDetailView(diary: diary)
  }
}
