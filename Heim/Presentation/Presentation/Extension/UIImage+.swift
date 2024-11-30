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
  
  static func configureImage(emotion: String) -> UIImage {
    switch emotion {
    case "sadness":
      return .sadIcon
    case "happiness":
      return .happyIcon
    case "angry":
      return .angryIcon
    case "surprise":
      return .surpriseIcon
    case "fear":
      return .fearIcon
    case "disgust":
      return .disgustIcon
    case "neutral":
      return .neutralIcon
    default:
      return UIImage()
    }
  }
}
