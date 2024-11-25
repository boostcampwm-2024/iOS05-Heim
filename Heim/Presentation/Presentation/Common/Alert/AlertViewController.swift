//
//  AlertViewController.swift
//  Presentation
//
//  Created by 한상진 on 11/13/24.
//

import UIKit

import SnapKit

final class AlertViewController: UIViewController {
  // MARK: - Properties
  private let alertView: CommonAlertView
  
  // MARK: - Initializer
  init(
    title: String, 
    message: String, 
    leftButtonTitle: String, 
    rightbuttonTitle: String
  ) {
    alertView = CommonAlertView(
      title: title,
      message: message,
      leftButtonTitle: leftButtonTitle,
      rightbuttonTitle: rightbuttonTitle
    )
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(alertView)
    setupAlertView()
  }
  
  // MARK: - Methods
  func setupLeftButtonAction(_ action: @escaping () -> Void) {
    let action = UIAction { [weak self] _ in 
      action()
      self?.dismiss(animated: false)
    }
    alertView.setupLeftButtonAction(action)
  }
  
  func setupRightButtonAction(_ action: @escaping () -> Void) {
    let action = UIAction { [weak self] _ in 
      action()
      self?.dismiss(animated: false)
    }
    alertView.setupRightButtonAction(action)
  }
}

// MARK: - Private Extenion
private extension AlertViewController {
  func setupAlertView() {
    view.addSubview(alertView)
    
    alertView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
