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
  case removeCache // 캐시 삭제
  case removeData  // 데이터 삭제
  case playError

  var title: String {
    switch self {
    case .removeDiary: "나의 일기가 사라져요"
    case .updateName: "이름을 입력하세요"
    case .removeCache: "현재 기기에 저장된 일기가\n모두 사라져요"
    case .removeData: "현재 기기에 저장된 일기가\n모두 사라져요"
    case .playError: "재생 중 오류가 발생했습니다."
    }
  }
  
  var message: String {
    switch self {
    case .removeDiary: "이 글은 더 이상 볼 수 없을텐데,\n정말 삭제하시겠어요?"
    case .updateName: ""
    case .removeCache: "현재 기기에 저장된 일기가 사라져요,\n정말 삭제하시겠어요?"
    case .removeData: "현재 기기에 저장된 일기가 사라져요,\n정말 삭제하시겠어요?"
    }
  }
  
  var leftButtonTitle: String {
    switch self {
    case .removeDiary: "다음에"
    case .updateName: "닫기"
    case .removeCache: "닫기"
    case .removeData: "닫기"
    case . playError: "확인"
    }
  }
  
  var rightButtonTitle: String {
    switch self {
    case .removeDiary: "삭제"
    case .updateName: "변경"
    case .removeCache: "확인"
    case .removeData: "확인"
    case . playError: ""
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
    
    alertView.setupLeftButtonAction(UIAction { _ in
      alertController.dismiss(animated: true)
    })
    
    alertView.setupCompleteButtonAction { textFieldText in
      alertController.dismiss(animated: true)
      completion(textFieldText)
    }
    
    present(alertController, animated: true)
  }
}
