//
//  CommonAlertView.swift
//  Presentation
//
//  Created by 한상진 on 11/13/24.
//

import UIKit

import SnapKit

final class CommonAlertView: UIView {
  // MARK: - Properties
  private let titleLabel: CommonLabel = CommonLabel(font: .bold, size: 20, textColor: .heimBlue)
  private var messageLabel: CommonLabel? = CommonLabel(font: .regular, size: LayoutConstants.defaultPadding, textColor: .black)
  
  private let labelContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.cornerRadius([.topLeft, .topRight], radius: LayoutConstants.defaultPadding)
    return view
  }()
  
  private let leftButton: CommonRectangleButton = CommonRectangleButton(
    fontStyle: .regularFont(ofSize: LayoutConstants.defaultPadding), 
    backgroundColor: .secondary,
    radius: 0
  )
  
  private var rightbutton: CommonRectangleButton? = CommonRectangleButton(
    fontStyle: .boldFont(ofSize: LayoutConstants.defaultPadding), 
    backgroundColor: .primary,
    radius: 0
  )
  
  private let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .fillEqually
    stackView.cornerRadius([.bottomLeft, .bottomRight], radius: LayoutConstants.defaultPadding)
    return stackView
  }()
  
  // MARK: - Initializer
  init(title: String, message: String, leftButtonTitle: String, rightbuttonTitle: String) {
    titleLabel.text = title
    messageLabel?.text = message
    leftButton.setTitle(leftButtonTitle, for: .normal)
    rightbutton?.setTitle(rightbuttonTitle, for: .normal)
    
    super.init(frame: .zero)
    setupViews()
    setupLayoutconstraints()
    setupLabelSpacing()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLeftButtonAction(_ action: UIAction) {
    leftButton.addAction(action, for: .touchUpInside)
  }
  
  func setupRightButtonAction(_ action: UIAction) {
    guard let rightbutton else { return }
    rightbutton.addAction(action, for: .touchUpInside)
  }
}

// MARK: - Private Extenion
private extension CommonAlertView {
  enum LayoutConstants {
    static let defaultPadding: CGFloat = 16
    static let titleLabelPadding: CGFloat = 48
    static let buttonStackViewHeightRatio: CGFloat = 0.066
  }
  
  func setupViews() {
    backgroundColor = .dim
    addSubview(labelContainerView)
    labelContainerView.addSubview(titleLabel)
    addSubview(buttonStackView)
    
    if let messageLabel, !(messageLabel.text ?? "").isEmpty {
      labelContainerView.addSubview(messageLabel)
    } else {
      messageLabel = nil
    }
    
    if (rightbutton?.titleLabel?.text ?? "").isEmpty {
      rightbutton = nil
    }
    
    [titleLabel, messageLabel]
      .forEach {
        $0?.textAlignment = .center
      }
    
    [leftButton, rightbutton]
      .compactMap { $0 }
      .forEach {
        buttonStackView.addArrangedSubview($0)
      }
  }
  
  func setupLayoutconstraints() {
    labelContainerView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(LayoutConstants.defaultPadding)
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.titleLabelPadding)
    }
    
    if let messageLabel {
      messageLabel.snp.makeConstraints {
        $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutConstants.defaultPadding)
        $0.centerX.equalToSuperview()
        $0.bottom.equalToSuperview().offset(-LayoutConstants.defaultPadding)
      }
    } else {
      titleLabel.snp.makeConstraints {
        $0.bottom.equalToSuperview().offset(-LayoutConstants.defaultPadding)
      }
    }
    
    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(labelContainerView.snp.bottom)
      $0.leading.trailing.equalTo(labelContainerView)
      $0.height.equalToSuperview().multipliedBy(LayoutConstants.buttonStackViewHeightRatio)
    }
  }
  
  func setupLabelSpacing() {
    guard let messageLabel else { return }
    messageLabel.setupLineSpacing()
  }
}
