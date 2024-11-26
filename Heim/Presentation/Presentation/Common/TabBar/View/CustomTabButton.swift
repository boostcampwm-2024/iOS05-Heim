//
//  CustomTabButton.swift
//  Presentation
//
//  Created by 한상진 on 11/22/24.
//

import UIKit

final class CustomTabButton: UIButton {
  let tabBarItem: CustomTabBarModel
  
  // MARK: - Initializer
  init(
    tabBarItem: CustomTabBarModel,
    action: UIAction
  ) {
    self.tabBarItem = tabBarItem
    super.init(frame: .zero)
    
    configure(title: tabBarItem.title, iconTitle: tabBarItem.tab.iconTitle, action: action)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private Extenion
private extension CustomTabButton {
  enum Constants {
    static let buttonSpacing: CGFloat = 5
    static let buttonIconSize: CGFloat = 18
    static let buttonTitleSize: CGFloat = 10
  }
  
  private func configure(
    title: String, 
    iconTitle: String,
    action: UIAction
  ) {
    var configuration = UIButton.Configuration.plain()
    configuration.imagePlacement = .top
    configuration.imagePadding = Constants.buttonSpacing
    configuration.image = UIImage.presentationAsset(
      named: iconTitle, 
      bundleClassType: Self.self
    ).withConfiguration(UIImage.SymbolConfiguration(pointSize: Constants.buttonIconSize))
    
    var container = AttributeContainer()
    container.font = .regularFont(ofSize: Constants.buttonTitleSize)
    configuration.attributedTitle = AttributedString(title, attributes: container)
    
    self.configuration = configuration
    contentVerticalAlignment = .bottom
    tintColor = .white
    addAction(action, for: .touchUpInside)
  }
}
