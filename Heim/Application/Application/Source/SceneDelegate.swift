//
//  SceneDelegate.swift
//  Application
//
//  Created by 정지용 on 11/5/24.
//

import Core
import DataModule
import DataStorageModule
import Domain
import Presentation
import NetworkModule
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  // MARK: - Properties
  var window: UIWindow?
  private var navigationController: UINavigationController?
  private var tabBarCoordinator: TabBarCoordinator?

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
    dataStorageAssemble()
    dataAssemble()
    domainAssemble()
    presentationAssemble()
  }
  
  func dataStorageAssemble() {
    DIContainer.shared.register(type: DataStorage.self) { _ in
      return DefaultLocalStorage()
    }
  }

  func dataAssemble() {
    DIContainer.shared.register(type: SettingRepository.self) { container in
      guard let localStorage = container.resolve(type: DataStorage.self) else {
        return
      }
      
      return DefaultSettingRepository(localStorage: localStorage)
    }
    
    DIContainer.shared.register(type: DiaryRepository.self) { container in
      guard let localStorage = container.resolve(type: DataStorage.self) else {
        return
      }
      
      return DefaultDiaryRepository(dataStorage: localStorage)
    }
  }

  func domainAssemble() {
    DIContainer.shared.register(type: SettingUseCase.self) { container in
      guard let settingRepository = container.resolve(type: SettingRepository.self) else {
        return
      }

      return DefaultSettingUseCase(settingRepository: settingRepository)
    }
    
    DIContainer.shared.register(type: DiaryUseCase.self) { container in
      guard let diaryRepository = container.resolve(type: DiaryRepository.self) else {
        return
      }

      return DefaultDiaryUseCase(diaryRepository: diaryRepository)
    }
  }

  func presentationAssemble() {
    guard let navigationController else { return }
    
    DIContainer.shared.register(type: TabBarCoordinator.self) { _ in
      return DefaultTabBarCoordinator(navigationController: navigationController)
    }
    
    DIContainer.shared.register(type: SettingCoordinator.self) { _ in
      return DefaultSettingCoordinator(navigationController: navigationController)
    }
    
    DIContainer.shared.register(type: RecordCoordinator.self) { _ in
      return DefaultRecordCoordinator(navigationController: navigationController)
    }
    
    DIContainer.shared.register(type: HomeCoordinator.self) { _ in
      return DefaultHomeCoordinator(navigationController: navigationController)
    }
    
    DIContainer.shared.register(type: DiaryDetailCoordinator.self) { _ in
      return DefaultDiaryDetailCoordinator(navigationController: navigationController)
    }
    
    DIContainer.shared.register(type: ReportCoordinator.self) { _ in
      return DefaultReportCoordinator(navigationController: navigationController)
    }
  }

  func startScene() {
    guard let tabBarCoordinator = DIContainer.shared.resolve(type: TabBarCoordinator.self) else { return }
    self.tabBarCoordinator = tabBarCoordinator
    tabBarCoordinator.start()
  }
}
