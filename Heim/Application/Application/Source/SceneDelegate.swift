//
//  SceneDelegate.swift
//  Application
//
//  Created by 정지용 on 11/5/24.
//

import UIKit
import Presentation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (
      scene as? UIWindowScene
    ) else {
      return
    }
    
    window = UIWindow(
      windowScene: windowScene
    )
    
    let tabBarController = CustomTabBarController()
    
    let tempHomeViewController = UIViewController()
    tempHomeViewController.view.backgroundColor = .systemBlue
    
    let tempStatisticsViewController = UIViewController()
    tempStatisticsViewController.view.backgroundColor = .systemPurple
    
    tabBarController
      .setViewControllers(
        [
          tempHomeViewController,
          tempStatisticsViewController
        ]
      )
    
    window?.rootViewController = tabBarController
    window?
      .makeKeyAndVisible()
  }
}
