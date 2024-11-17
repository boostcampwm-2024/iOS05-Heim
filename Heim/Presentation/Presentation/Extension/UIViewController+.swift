//
//  UIViewController+.swift
//  Presentation
//
//  Created by 박성근 on 11/17/24.
//

import UIKit

extension UIViewController {
  func screen() -> UIScreen? {
    guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return view.window?.windowScene?.screen
    }
    
    return window.screen
  }
}
