//
//  CustomTabBarView.swift
//  Presentation
//
//  Created by 박성근 on 11/7/24.
//

import UIKit
import SnapKit

enum TabBarItem {
  // TODO: TabBar Coordinator에서 선언 후 사용할 예정
  case home
  case mic
  case statistic
  
  var selectedIdx: Int {
    switch self {
    case .home: return 0
    case .mic: return 1
    case .statistic: return 2
    }
  }
}

protocol CustomTabBarViewDelegate: AnyObject {
  func buttonDidTap(_ tabBarView: CustomTabBarView, _ item: TabBarItem)
}

final class CustomTabBarView: UIView {
  // MARK: - Properties
  weak var delegate: CustomTabBarViewDelegate?
  private var tabButtons: [UIButton] = []
  
  private let tabBarView: UIView = {
    let view = UIView()
    view.backgroundColor = .primary
    view.layer.cornerRadius = Constants.tabBarCornerRadius
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    return view
  }()
  
  private lazy var centerButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .primary
    button.tintColor = .white
    button.layer.cornerRadius = Constants.centerButtonSize / 2
    button.layer.borderWidth = Constants.centerButtonBorderWidth
    button.layer.borderColor = UIColor.white.cgColor
    button.setImage(
      // TODO: #9 브랜치 병합 시 수정
      UIImage(
        systemName: "music.mic",
        withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.centerButtonSize)
      ),
      for: .normal
    )
    button.addTarget(self, action: #selector(centerButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Initialization
  init() {
    super.init(frame: .zero)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI Setting
  private func setupUI() {
    addSubview(tabBarView)
    addSubview(centerButton)
    
    setupConstraints()
    setupTabButtons()
  }
  
  private func setupConstraints() {
    tabBarView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalToSuperview()
      $0.height.equalTo(Constants.tabBarHeight)
    }
    
    centerButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(tabBarView.snp.top).offset(Constants.centerButtonBottomOffset)
      $0.width.height.equalTo(Constants.centerButtonSize)
    }
  }
  
  private func setupTabButtons() {
    // TODO: #9 브랜치 병합 시 수정
    let items = [
      (icon: "house.fill", title: "홈"),
      (icon: "chart.bar.fill", title: "통계")
    ]
    
    let buttonWidth = UIScreen.main.bounds.width / 3
    
    items.enumerated().forEach { index, item in
      let button = createTabButton(icon: item.icon, title: item.title, at: index)
      tabBarView.addSubview(button)
      
      button.snp.makeConstraints {
        $0.bottom.equalToSuperview().offset(Constants.buttonBottomOffset)
        $0.height.equalTo(Constants.buttonHeight)
        $0.width.equalTo(buttonWidth)
        
        if index == 0 {
          $0.leading.equalToSuperview()
        } else {
          $0.trailing.equalToSuperview()
        }
      }
      
      tabButtons.append(button)
    }
    
    updateButtonAppearance(selectedIndex: 0)
  }
  
  private func createTabButton(icon: String, title: String, at index: Int) -> UIButton {
    let button = UIButton()
    button.tag = index
    
    var configuration = UIButton.Configuration.plain()
    configuration.imagePlacement = .top
    configuration.imagePadding = Constants.buttonSpacing
    configuration.image = UIImage(systemName: icon)?.withConfiguration(
      UIImage.SymbolConfiguration(pointSize: Constants.buttonIconSize)
    )
    
    var container = AttributeContainer()
    container.font = .regularFont(ofSize: Constants.buttonTitleSize)
    configuration.attributedTitle = AttributedString(title, attributes: container)
    
    button.configuration = configuration
    button.tintColor = .white
    button.addTarget(self, action: #selector(tabButtonDidTap), for: .touchUpInside)
    
    return button
  }
  
  // MARK: - Public Methods
  public func setSelectedTab(_ index: Int) {
    updateButtonAppearance(selectedIndex: index)
  }
  
  // MARK: - Private Methods
  private func updateButtonAppearance(selectedIndex: Int) {
    tabButtons.enumerated().forEach { index, button in
      let isSelected = index == selectedIndex
      button.tintColor = .white.withAlphaComponent(isSelected ? 1 : Constants.inactiveAlpha)
      button.alpha = isSelected ? 1 : Constants.inactiveAlpha
    }
  }
  
  // MARK: - Action Methods
  @objc private func tabButtonDidTap(_ sender: UIButton) {
    let item: TabBarItem = sender.tag == 0 ? .home : .statistic
    delegate?.buttonDidTap(self, item)
    updateButtonAppearance(selectedIndex: sender.tag)
  }
  
  @objc private func centerButtonDidTap() {
    delegate?.buttonDidTap(self, .mic)
  }
}

// MARK: - Constants
private extension CustomTabBarView {
  enum Constants {
    static let tabBarHeight: CGFloat = 90
    static let tabBarCornerRadius: CGFloat = 20
    static let centerButtonSize: CGFloat = 80
    static let centerButtonIconSize: CGFloat = 40
    static let centerButtonBorderWidth: CGFloat = 1
    static let centerButtonBottomOffset: CGFloat = 60
    static let buttonIconSize: CGFloat = 18
    static let buttonTitleSize: CGFloat = 10
    static let buttonSpacing: CGFloat = 5
    static let buttonBottomOffset: CGFloat = -20
    static let buttonHeight: CGFloat = 50
    static let inactiveAlpha: CGFloat = 0.5
  }
}
