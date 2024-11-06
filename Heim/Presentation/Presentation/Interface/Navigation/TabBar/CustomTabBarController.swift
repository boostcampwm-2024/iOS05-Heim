//
//  TabBarController.swift
//  Presentation
//
//  Created by 박성근 on 11/7/24.
//

import UIKit
import SnapKit

public final class CustomTabBarController: UIViewController {
  // MARK: - Types
  private struct TabItem {
    let icon: String
    let title: String
    let viewController: UIViewController
  }
  
  // MARK: - UI Components
  private lazy var tabBarView: UIView = {
    let view = UIView()
    view.backgroundColor = .primary
    view.layer.cornerRadius = Constants.tabBarCornerRadius
    view.layer.maskedCorners = [
      .layerMinXMinYCorner,
      .layerMaxXMinYCorner
    ]
    return view
  }()
  
  private lazy var centerButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .primary
    button.tintColor = .white
    button.layer.cornerRadius = Constants.centerButtonSize / 2
    
    button
      .setImage(
        UIImage(
          systemName: "music.mic",
          withConfiguration: UIImage
            .SymbolConfiguration(
              pointSize: Constants.centerButtonIconSize,
              weight: .medium
            )
        ),
        for: .normal
      )
    
    button
      .addTarget(
        self,
        action: #selector(
          centerButtonDidTap
        ),
        for: .touchUpInside
      )
    return button
  }()
  
  // MARK: - Properties
  private var tabItems: [TabItem] = []
  private var tabButtons: [UIButton] = []
  private var currentIndex = 0
  private var previousIndex = 0
  
  // MARK: - Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: - Public Methods
  public func setViewControllers(
    _ viewControllers: [UIViewController]
  ) {
    guard viewControllers.count == 2 else {
      fatalError(
        "CustomTabBarController requires exactly 2 view controllers"
      )
    }
    
    tabItems = [
      TabItem(
        icon: "house.fill",
        title: "Home",
        viewController: viewControllers[0]
      ),
      TabItem(
        icon: "chart.bar.fill",
        title: "통계",
        viewController: viewControllers[1]
      )
    ]
    
    setupTabButtons()
    updateSelectedViewController()
  }
  
  // MARK: - Navigate Methods
  private func updateSelectedViewController() {
    let previousVC = tabItems[previousIndex].viewController
    
    previousVC
      .willMove(
        toParent: nil
      )
    previousVC.view
      .removeFromSuperview()
    previousVC
      .removeFromParent()
    
    let currentVC = tabItems[currentIndex].viewController
    addChild(
      currentVC
    )
    view
      .insertSubview(
        currentVC.view,
        belowSubview: tabBarView
      )
    
    currentVC.view.snp
      .makeConstraints {
        $0.edges
          .equalToSuperview()
      }
    
    currentVC
      .didMove(
        toParent: self
      )
    updateButtonAppearance()
  }
  
  private func updateButtonAppearance() {
    tabButtons
      .enumerated()
      .forEach {
        index,
        button in
        let isSelected = index == currentIndex
        button.tintColor = .white
          .withAlphaComponent(
            isSelected ? 1 : Constants.inactiveAlpha
          )
        button.alpha = isSelected ? 1 : Constants.inactiveAlpha
      }
  }
}

// MARK: - UI Setting Methods
extension CustomTabBarController {
  private func setupUI() {
    setupTabBar()
    setupCenterButton()
  }
  
  private func setupTabBar() {
    view
      .addSubview(
        tabBarView
      )
    tabBarView.snp
      .makeConstraints { make in
        make.bottom.leading.trailing
          .equalToSuperview()
        make.height
          .equalTo(
            Constants.tabBarHeight
          )
      }
  }
  
  private func setupCenterButton() {
    view
      .addSubview(
        centerButton
      )
    centerButton.snp
      .makeConstraints { make in
        make.centerX
          .equalToSuperview()
        make.bottom
          .equalTo(
            tabBarView.snp.top
          )
          .offset(
            40
          )
        make.width.height
          .equalTo(
            Constants.centerButtonSize
          )
      }
  }
  
  private func setupTabButtons() {
    let buttonWidth = view.bounds.width / 3
    
    tabItems
      .enumerated()
      .forEach {
        index,
        item in
        let button = createTabButton(
          for: item,
          at: index
        )
        tabBarView
          .addSubview(
            button
          )
        
        button.snp
          .makeConstraints { make in
            make.bottom
              .equalToSuperview()
              .offset(
                Constants.buttonBottomOffset
              )
            make.height
              .equalTo(
                Constants.buttonHeight
              )
            make.width
              .equalTo(
                buttonWidth
              )
            
            if index == 0 {
              make.leading
                .equalToSuperview()
            } else {
              make.trailing
                .equalToSuperview()
            }
          }
        
        tabButtons
          .append(
            button
          )
      }
    
    updateButtonAppearance()
  }
  
  private func createTabButton(
    for item: TabItem,
    at index: Int
  ) -> UIButton {
    let button = UIButton()
    button.tag = index
    
    var configuration = UIButton.Configuration.plain()
    configuration.imagePlacement = .top
    configuration.imagePadding = Constants.buttonSpacing
    configuration.image = UIImage(
      systemName: item.icon
    )?
      .withConfiguration(
        UIImage
          .SymbolConfiguration(
            pointSize: Constants.buttonIconSize
          )  // 18
      )
    
    var container = AttributeContainer()
    container.font = UIFont
      .regularFont(
        ofSize: Constants.buttonTitleSize
      )
    configuration.attributedTitle = AttributedString(
      item.title,
      attributes: container
    )
    
    button.configuration = configuration
    button.tintColor = .white
    button
      .addTarget(
        self,
        action: #selector(
          tabButtonDidTap
        ),
        for: .touchUpInside
      )
    
    return button
  }
}

// MARK: - Action Methods
extension CustomTabBarController {
  @objc private func tabButtonDidTap(
    _ sender: UIButton
  ) {
    previousIndex = currentIndex
    currentIndex = sender.tag
    updateSelectedViewController()
  }
  
  @objc private func centerButtonDidTap() {
    let viewController = UIViewController()
    viewController.view.backgroundColor = .primary
    viewController.modalPresentationStyle = .fullScreen
    
    let closeButton = UIButton(
      frame: .zero
    )
    closeButton
      .setImage(
        UIImage(
          systemName: "xmark.circle.fill",
          withConfiguration: UIImage
            .SymbolConfiguration(
              pointSize: 28,
              weight: .medium
            )
        ),
        for: .normal
      )
    closeButton.tintColor = .gray
    closeButton
      .addTarget(
        self,
        action: #selector(
          dismissViewController
        ),
        for: .touchUpInside
      )
    
    viewController.view
      .addSubview(
        closeButton
      )
    closeButton.snp
      .makeConstraints { make in
        make.top
          .equalTo(
            viewController.view.safeAreaLayoutGuide
          )
          .offset(
            20
          )
        make.trailing
          .equalToSuperview()
          .offset(
            -20
          )
        make.width.height
          .equalTo(
            32
          )
      }
    
    present(
      viewController,
      animated: true
    )
  }
  
  @objc private func dismissViewController() {
    dismiss(
      animated: true
    )
  }
}

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
