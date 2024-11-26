//
//  CustomTabBarView.swift
//  Presentation
//
//  Created by 박성근 on 11/7/24.
//

import UIKit
import SnapKit

protocol CustomTabBarViewDelegate: AnyObject {
  func buttonDidTap(_ tabBarView: CustomTabBarView, item: TabBarItems)
}

final class CustomTabBarView: UIView {
  // MARK: - Properties
  weak var delegate: CustomTabBarViewDelegate?
  
  private let tabBarView: UIView = {
    let view = UIView()
    view.backgroundColor = .primary
    view.layer.cornerRadius = Constants.tabBarCornerRadius
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    return view
  }()
  
  private let centerButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .primary
    button.tintColor = .white
    button.layer.cornerRadius = Constants.centerButtonSize / 2
    button.layer.borderWidth = Constants.centerButtonBorderWidth
    button.layer.borderColor = UIColor.white.cgColor
    button.setImage(.micIcon, for: .normal)
    return button
  }()
  
  private let buttonStackView = UIStackView()
  
  // MARK: - Initialization
  init() {
    super.init(frame: .zero)
    
    setupUI()
    setupTabButtons()
    setSelectedTab(.home)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Constants
private extension CustomTabBarView {
  enum Constants {
    static let tabBarHeightRatio: CGFloat = 0.1
    static let tabBarCornerRadius: CGFloat = 20
    static let centerButtonSize: CGFloat = 80
    static let centerButtonIconSize: CGFloat = 40
    static let centerButtonBorderWidth: CGFloat = 1
    static let centerButtonBottomOffset: CGFloat = 60
    static let buttonBottomOffset: CGFloat = -20
    static let inactiveAlpha: CGFloat = 0.5
    static let buttonTotalWidth = UIApplication.screenWidth - Self.centerButtonSize
    static let buttonWidth = Self.buttonTotalWidth / CGFloat(TabBarItems.allCases.count - 1) 
  }
  
  func setSelectedTab(_ tab: TabBarItems) {
    for tabButton in buttonStackView.arrangedSubviews {
      guard let tabButton = tabButton as? CustomTabButton,
            tabButton.tabBarItem.tab != .mic else { continue }
      let isSelected = tab == tabButton.tabBarItem.tab
      
      tabButton.tintColor = .white.withAlphaComponent(isSelected ? 1 : Constants.inactiveAlpha)
      tabButton.alpha = isSelected ? 1 : Constants.inactiveAlpha
    }
  }
  
  func setupUI() {
    addSubview(tabBarView)
    addSubview(centerButton)
    addSubview(buttonStackView)
    
    tabBarView.snp.makeConstraints {
      $0.height.equalTo(UIApplication.screenHeight * Constants.tabBarHeightRatio)
      $0.width.equalTo(UIApplication.screenWidth)
      $0.edges.equalToSuperview()
    }
    
    centerButton.snp.makeConstraints {
      $0.size.equalTo(Constants.centerButtonSize)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.bottom.equalTo(tabBarView.snp.top).offset(Constants.centerButtonBottomOffset)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  func setupTabButtons() {
    centerButton.addAction(UIAction { [weak self] _ in
      guard let self else { return }
      delegate?.buttonDidTap(self, item: .mic)
    }, for: .touchUpInside)
    
    for tabBarItem in CustomTabBarModel.tabBarItems() where tabBarItem.tab != .mic {
      let action = UIAction { [weak self] _ in
        guard let self else { return }
        setSelectedTab(tabBarItem.tab)
        delegate?.buttonDidTap(self, item: tabBarItem.tab)
      }
      
      let tabButton = CustomTabButton(tabBarItem: tabBarItem, action: action)
      tabButton.snp.makeConstraints {
        $0.width.equalTo(Constants.buttonWidth)
      }
      buttonStackView.addArrangedSubview(tabButton)
    }
    
    buttonStackView.insertArrangedSubview(centerButton, at: TabBarItems.allCases.count / 2)
  }
}
