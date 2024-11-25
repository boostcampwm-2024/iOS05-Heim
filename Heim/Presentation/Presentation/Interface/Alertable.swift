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
  case updateName
  
  var title: String {
    switch self {
    case .removeDiary: "나의 일기가 사라져요"
    case .updateName: "이름을 입력하세요"
    }
  }
  
  var message: String {
    switch self {
    case .removeDiary: "이 글은 더 이상 볼 수 없을텐데,\n정말 삭제하시겠어요?"
    case .updateName: ""
    }
  }
  
  var leftButtonTitle: String {
    switch self {
    case .removeDiary: "다음에"
    case .updateName: "닫기"
    }
  }
  
  var rightButtonTitle: String {
    switch self {
    case .removeDiary: "삭제"
    case .updateName: "변경"
    }
  }
}

extension Alertable where Self: UIViewController {
  func presentAlert(
    type: AlertType,
    leftButtonAction: @escaping () -> Void,
    rightButtonAction: @escaping () -> Void = {}
  ) {
    let alertView = CommonAlertView(
      title: type.title,
      message: type.message,
      leftButtonTitle: type.leftButtonTitle,
      rightbuttonTitle: type.rightButtonTitle
    )
    let alertController = AlertViewController(alertView: alertView)
    
    alertView.setupLeftButtonAction(UIAction { _ in
      alertController.dismiss(animated: true)
      leftButtonAction()
    })
    
    alertView.setupRightButtonAction(UIAction { _ in
      alertController.dismiss(animated: true)
      rightButtonAction()
    })
    
    present(alertController, animated: true)
  }
  
  func presentNameAlert(completion: @escaping (String) -> Void) {
    let alertView = NameAlertView(
      title: AlertType.updateName.title,
      leftButtonTitle: AlertType.updateName.leftButtonTitle,
      rightbuttonTitle: AlertType.updateName.rightButtonTitle
    )
    let alertController = AlertViewController(alertView: alertView)
    
    alertView.setupCompleteButtonAction { textFieldText in
      alertController.dismiss(animated: true)
      completion(textFieldText)
    }
    
    present(alertController, animated: true)
  }
}
