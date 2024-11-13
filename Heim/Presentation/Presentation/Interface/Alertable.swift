//
//  Alertable.swift
//  Presentation
//
//  Created by 한상진 on 11/13/24.
//

import UIKit

protocol Alertable {}

enum AlertType {
  case removeDiary
  
  var title: String {
    switch self {
    case .removeDiary: "나의 일기가 사라져요"
    }
  }
  
  var message: String {
    switch self {
    case .removeDiary: "이 글은 더 이상 볼 수 없을텐데,\n정말 삭제하시겠어요?"
    }
  }
  
  var leftButtonTitle: String {
    switch self {
    case .removeDiary: "다음에"
    }
  }
  
  var rightButtonTitle: String {
    switch self {
    case .removeDiary: "삭제"
    }
  }
}

extension Alertable where Self: UIViewController {
  func presentAlert(
    type: AlertType,
    leftButtonAction: @escaping () -> Void,
    rightButtonAction: @escaping () -> Void = {}
  ) {
    let alertController = AlertViewController(
      title: type.title,
      message: type.message,
      leftButtonTitle: type.leftButtonTitle,
      rightbuttonTitle: type.rightButtonTitle
    )
    
    alertController.setupLeftButtonAction(leftButtonAction)
    alertController.setupRightButtonAction(rightButtonAction)
    
    alertController.modalPresentationStyle = .overCurrentContext
    alertController.modalTransitionStyle = .crossDissolve
    present(alertController, animated: true)
  }
}
