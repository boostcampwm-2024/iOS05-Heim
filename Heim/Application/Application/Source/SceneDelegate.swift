//
//  SceneDelegate.swift
//  Application
//
//  Created by 정지용 on 11/5/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let _ = (
      scene as? UIWindowScene
    ) else {
      return
    }
  }
}
