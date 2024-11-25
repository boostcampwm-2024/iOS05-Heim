//
//  SceneDelegate.swift
//  Application
//
//  Created by 정지용 on 11/5/24.
//

import Core
import DataModule
import DataStorage
import Domain
import Presentation
import NetworkModule
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  // MARK: - Properties
  var window: UIWindow?
  private var navigationController: UINavigationController?
  // TODO: AppCoordinator 구현 후 적용 예정
  //  private var appCoordinator: AppCoordinator?

  // MARK: - Methods
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)

    self.navigationController = UINavigationController()
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    dependencyAssemble()
    startScene()
  }
}

  // MARK: - Private Extenion
private extension SceneDelegate {
  func dependencyAssemble() {
    dataAssemble()
    domainAssemble()
    presentationAssemble()
  }

  func dataAssemble() {
    DIContainer.shared.register(type: SettingRepository.self) { _ in
      return DefaultSettingRepository()
    }
  }

  func domainAssemble() {
    DIContainer.shared.register(type: SettingUseCase.self) { container in
      guard let settingRepository = container.resolve(type: SettingRepository.self) else {
        return
      }

      return DefaultSettingUseCase(settingRepository: settingRepository)
    }
  }

  func presentationAssemble() {
    guard let navigationController else { return }

    DIContainer.shared.register(type: SettingCoordinator.self) { _ in
      return DefaultSettingCoordinator(navigationController: navigationController)
    }
  }

  func startScene() {
    // TODO: AppCoordinator 구현 후 적용 예정
//    guard let appCoordinator = DIContainer.shared.resolve(type: AppCoordinator.self) else { return }
//    self.appCoordinator = appCoordinator
//    appCoordinator.start()
  }
}

