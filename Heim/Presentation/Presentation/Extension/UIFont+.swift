//
//  UIFont+.swift
//  Presentation
//
//  Created by 정지용 on 11/6/24.
//

import UIKit

extension UIFont {
  enum CustomFont: String {
    case regular = "SejongGeulggot"
    case bold = "KingSejongInstitute-Bold"
  }
  
  static func regularFont(
    ofSize size: CGFloat
  ) -> UIFont {
    return custom(.regular, size: size)
  }
  
  static func boldFont(
    ofSize size: CGFloat
  ) -> UIFont {
    return custom(.bold, size: size)
  }
  
  private static func custom(
    _ font: CustomFont,
    size: CGFloat
  ) -> UIFont {
    return UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
  }
}
