//
//  UIViewController+.swift
//  Presentation
//
//  Created by 박성근 on 11/17/24.
//

import UIKit

extension UIApplication {
  static var screenSize: CGSize {
    guard let windowScene = shared.connectedScenes.first as? UIWindowScene else {
      return UIScreen.main.bounds.size
    }
    return windowScene.screen.bounds.size
  }
  
  static var screenHeight: CGFloat {
    return screenSize.height
  }
  
  static var screenWidth: CGFloat {
    return screenSize.width
  }
}
