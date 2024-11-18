//
//  UIView+.swift
//  Presentation
//
//  Created by 한상진 on 11/13/24.
//

import UIKit

extension UIView {
  func cornerRadius(_ corners: [UIRectCorner] = [.allCorners], radius: CGFloat) {
    layer.masksToBounds = true
    layer.cornerCurve = .continuous
    layer.cornerRadius = radius
    
    guard corners != [.allCorners] else {
      return
    }
    
    var cornerMask = CACornerMask()
    
    corners.forEach { corner in
      switch corner {
      case .topLeft:     cornerMask.insert(.layerMinXMinYCorner)
      case .topRight:    cornerMask.insert(.layerMaxXMinYCorner)
      case .bottomLeft:  cornerMask.insert(.layerMinXMaxYCorner)
      case .bottomRight: cornerMask.insert(.layerMaxXMaxYCorner)
      default: return
      }
    }
    
    layer.maskedCorners = cornerMask
  }
}
