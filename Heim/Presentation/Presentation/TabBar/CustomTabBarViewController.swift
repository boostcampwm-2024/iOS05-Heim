//
//  CustomTabBarViewController.swift
//  Presentation
//
//  Created by 박성근 on 11/7/24.
//

import UIKit
import SnapKit

public final class CustomTabBarController: BaseViewController<CustomTabBarViewModel> {
  // MARK: - UI Components
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
    button.setImage(
      UIImage(systemName: "music.mic", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28)),
      for: .normal
    )
    button.addTarget(self, action: #selector(centerButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Properties
  private var tabButtons: [UIButton] = []
  
  // MARK: - Lifecycle
  public override func setupViews() {
    super.setupViews()
    view.addSubview(tabBarView)
    view.addSubview(centerButton)
  }
  
  public override func setupLayoutConstraints() {
    super.setupLayoutConstraints()
    
    tabBarView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalToSuperview()
      $0.height.equalTo(Constants.tabBarHeight)
    }
    
    centerButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(tabBarView.snp.top).offset(40)
      $0.width.height.equalTo(Constants.centerButtonSize)
    }
  }
  
  // TODO: bindAction 구현
  
  override func bindState() {
    viewModel.$state
      .sink { [weak self] state in
        self?.updateUI(with: state)
      }
      .store(in: &cancellable)
  }
  
  // MARK: - Public Methods
  public func setViewControllers(
    _ viewControllers: [UIViewController]
  ) {
    viewModel.action(.setViewControllers(viewControllers))
  }
}

// MARK: - Private Methods
extension CustomTabBarController {
  private func updateUI(
    with state: CustomTabBarViewModel.State
  ) {
    setupTabButtons(state.tabItems)
    updateButtonAppearance(selectedIndex: state.currentIndex)
    updateViewController(with: state)
  }
  
  private func setupTabButtons(
    _ items: [(
      icon: String,
      title: String
    )]
  ) {
    tabButtons.forEach { $0.removeFromSuperview() }
    tabButtons.removeAll()
    
    let buttonWidth = view.bounds.width / CGFloat(items.count + 1)
    
    items.enumerated().forEach { index, item in
      let button = createTabButton(icon: item.icon, title: item.title, at: index)
      tabBarView.addSubview(button)
      
      button.addTarget(
        self,
        action: #selector(tabButtonDidTap),
        for: .touchUpInside
      )
      
      button.snp.makeConstraints { make in
        make.bottom.equalToSuperview().offset(Constants.buttonBottomOffset)
        make.height.equalTo(Constants.buttonHeight)
        make.width.equalTo(buttonWidth)
        
        if index == 0 {
          make.leading.equalToSuperview()
        } else {
          make.trailing.equalToSuperview()
        }
      }
      
      tabButtons.append(button)
    }
  }
  
  private func createTabButton(
    icon: String,
    title: String,
    at index: Int
  ) -> UIButton {
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
    
    return button
  }
  
  private func updateButtonAppearance(
    selectedIndex: Int
  ) {
    tabButtons.enumerated().forEach { index, button in
      let isSelected = index == selectedIndex
      button.tintColor = .white.withAlphaComponent(isSelected ? 1 : Constants.inactiveAlpha)
      button.alpha = isSelected ? 1 : Constants.inactiveAlpha
    }
  }
  
  private func updateViewController(
    with state: CustomTabBarViewModel.State
  ) {
    let previousViewController = state.viewControllers[state.previousIndex]
    previousViewController.willMove(toParent: nil)
    previousViewController.view.removeFromSuperview()
    previousViewController.removeFromParent()
    
    let currentViewController = state.viewControllers[state.currentIndex]
    addChild(currentViewController)
    view.insertSubview(currentViewController.view, belowSubview: tabBarView)
    
    currentViewController.view.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    currentViewController.didMove(toParent: self)
  }
  
  @objc private func tabButtonDidTap(
    _ sender: UIButton
  ) {
    viewModel.action(.selectTab(sender.tag))
  }
  
  // TODO: Coordinator 구현 후 기능 구현
  @objc private func centerButtonDidTap() {
    viewModel.action(.centerButtonDidTap)
  }
}

// MARK: - Constants
extension CustomTabBarController {
  private enum Constants {
    static let tabBarHeight: CGFloat = 90
    static let tabBarCornerRadius: CGFloat = 20
    static let centerButtonSize: CGFloat = 80
    static let centerButtonIconSize: CGFloat = 30
    static let buttonIconSize: CGFloat = 18
    static let buttonTitleSize: CGFloat = 10
    static let buttonSpacing: CGFloat = 5
    static let buttonBottomOffset: CGFloat = -20
    static let buttonHeight: CGFloat = 50
    static let inactiveAlpha: CGFloat = 0.5
  }
}
