//
//  UIImage+.swift
//  Presentation
//
//  Created by 한상진 on 11/13/24.
//

import UIKit

extension UIImage {
  static func presentationAsset(named name: String, bundleClassType: AnyClass) -> UIImage {
    return UIImage(named: name, in: Bundle(for: bundleClassType), with: nil) ?? UIImage()
  }
}
