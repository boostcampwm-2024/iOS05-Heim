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
  private var recordNavigationController: UINavigationController?
  private var tabBarCoordinator: TabBarCoordinator?
  
  // MARK: - Methods
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)

    setupNavigationBar()

    self.navigationController = UINavigationController()
    self.recordNavigationController = UINavigationController()
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    dependencyAssemble()
    startScene()
  }
}

  // MARK: - Private Extenion
private extension SceneDelegate {
  func setupNavigationBar() {
    let barButtonItemAppearance = UIBarButtonItem.appearance()
    barButtonItemAppearance.setTitleTextAttributes(
      [NSAttributedString.Key.foregroundColor: UIColor.clear],
      for: .normal
    )
    barButtonItemAppearance.tintColor = .white
    
    let backImage = UIImage(named: "back")
    UINavigationBar.appearance().backIndicatorImage = backImage
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
  }
  
  func dependencyAssemble() {
    dataStorageAssemble()
    networkAssemble()
    dataAssemble()
    domainAssemble()
    presentationAssemble()
  }
  
  func dataStorageAssemble() {
    DIContainer.shared.register(type: DataStorage.self) { _ in
      return DefaultLocalStorage()
    }
    
    DIContainer.shared.register(type: KeychainStorage.self) { _ in
      return DefaultKeychainStorage()
    }
  }
  
  func networkAssemble() {
    DIContainer.shared.register(type: NetworkProvider.self) { _ in
      return DefaultNetworkProvider(requestor: URLSession.shared)
    }
    
    DIContainer.shared.register(type: TokenManager.self) { container in
      guard let keychainStorage = container.resolve(type: KeychainStorage.self) else {
        return
      }
      
      return DefaultTokenManager(keychainStorage: keychainStorage)
    }
    
    DIContainer.shared.register(type: OAuthNetworkProvider.self) { container in
      guard let tokenManager = container.resolve(type: TokenManager.self) else {
        return
      }
      
      return DefaultOAuthNetworkProvider(requestor: URLSession.shared, tokenManager: tokenManager)
    }
  }
  
  func dataAssemble() {
    DIContainer.shared.register(type: SettingRepository.self) { container in
      guard let localStorage = container.resolve(type: DataStorage.self) else {
        return
      }
      
      return DefaultSettingRepository(localStorage: localStorage)
    }
    
    DIContainer.shared.register(type: UserRepository.self) { container in
      guard let localStorage = container.resolve(type: DataStorage.self) else {
        return
      }
      
      return DefaultUserRepository(dataStorage: localStorage)
    }
    
    DIContainer.shared.register(type: DiaryRepository.self) { container in
      guard let localStorage = container.resolve(type: DataStorage.self) else {
        return
      }
      
      return DefaultDiaryRepository(dataStorage: localStorage)
    }
    
    DIContainer.shared.register(type: GenerativeAIRepository.self) { container in
      guard let networkProvider = container.resolve(type: NetworkProvider.self) else {
        return
      }
      
      return GeminiGenerativeAIRepository(networkProvider: networkProvider)
    }
    
//    DIContainer.shared.register(type: AVPlayerManager.self) { _ in
//      return DefaultAVPlayerManager()
//    }
//    
//    DIContainer.shared.register(type: MusicRepository.self) { container in
//      guard let avPlayerManager = container.resolve(type: AVPlayerManager.self) else {
//        return
//      }
//      return DefaultMusicRepository(avPlayerManager: avPlayerManager)
//    }
    
    DIContainer.shared.register(type: SpotifyRepository.self) { container in
      guard let oauthNetworkProvider = container.resolve(type: OAuthNetworkProvider.self) else {
        return
      }
      
      return DefaultSpotifyRepository(networkProvider: oauthNetworkProvider)
    }
    
    DIContainer.shared.register(type: SpotifyOAuthRepository.self) { container in
      guard let networkProvider = container.resolve(type: NetworkProvider.self),
            let tokenManager = container.resolve(type: TokenManager.self) else {
        return
      }
      
      return DefaultSpotifyOAuthRepository(networkProvider: networkProvider, tokenManager: tokenManager)
    }
  }

  func domainAssemble() {
    DIContainer.shared.register(type: UserUseCase.self) { container in
      guard let userRepository = container.resolve(type: UserRepository.self) else { return }
      return DefaultUserUseCase(userRepository: userRepository)
    }
    
    DIContainer.shared.register(type: SettingUseCase.self) { container in
      guard let settingRepository = container.resolve(type: SettingRepository.self),
            let userRepository = container.resolve(type: UserRepository.self) else {
        return
      }

      return DefaultSettingUseCase(settingRepository: settingRepository, userRepository: userRepository)
    }
    
    DIContainer.shared.register(type: EmotionClassifyUseCase.self) { _ in
      return DefaultEmotionClassifyUseCase()
    }
    
    DIContainer.shared.register(type: DiaryUseCase.self) { container in
      guard let diaryRepository = container.resolve(type: DiaryRepository.self) else {
        return
      }

      return DefaultDiaryUseCase(diaryRepository: diaryRepository)
    }
    
//    DIContainer.shared.register(type: MusicUseCase.self) { container in
//      guard let spotifyRepository = container.resolve(type: SpotifyRepository.self),
//            let musicRepository = container.resolve(type: MusicRepository.self) else {
//        return
//      }
//      
//      return DefaultMusicUseCase(spotifyRepository: spotifyRepository, musicRepository: musicRepository)
//    }
    
    DIContainer.shared.register(type: SpotifyOAuthUseCase.self) { container in
      guard let spotifyOAuthRepository = container.resolve(type: SpotifyOAuthRepository.self) else {
        return
      }
      
      return DefaultSpotifyOAuthUseCase(repository: spotifyOAuthRepository)
    }
    
    DIContainer.shared.register(type: SummaryPromptGenerating.self) { _ in
      return SummaryPromptGenerator()
    }
    
    DIContainer.shared.register(type: GenerativeSummaryPromptUseCase.self) { container in
      guard let generativeAIRepository = container.resolve(type: GenerativeAIRepository.self),
            let summaryPromptGenerator = container.resolve(type: SummaryPromptGenerating.self) else {
        return
      }
      
      return GeminiGenerativeSummaryPromptUseCase(
        generativeRepository: generativeAIRepository,
        generator: summaryPromptGenerator
      )
    }
    
    DIContainer.shared.register(type: EmotionPromptGenerating.self) { _ in
      return EmotionPromptGenerator()
    }
    
    DIContainer.shared.register(type: GenerativeEmotionPromptUseCase.self) { container in
      guard let generativeAIRepository = container.resolve(type: GenerativeAIRepository.self),
            let emotionPromptGenerator = container.resolve(type: EmotionPromptGenerating.self) else {
        return
      }
      
      return GeminiGenerativeEmotionPromptUseCase(
        generativeRepository: generativeAIRepository,
        generator: emotionPromptGenerator
      )
    }
  }

  func presentationAssemble() {
    guard let navigationController else { return }
    guard let recordNavigationController else { return }
    
    DIContainer.shared.register(type: TabBarCoordinator.self) { _ in
      return DefaultTabBarCoordinator(navigationController: navigationController)
    }
    
    DIContainer.shared.register(type: SettingCoordinator.self) { _ in
      return DefaultSettingCoordinator(navigationController: navigationController)
    }
    
    DIContainer.shared.register(type: RecordCoordinator.self) { _ in
      return DefaultRecordCoordinator(navigationController: recordNavigationController)
    }
    
    DIContainer.shared.register(type: HomeCoordinator.self) { _ in
      return DefaultHomeCoordinator(navigationController: navigationController)
    }
    
    DIContainer.shared.register(type: DiaryDetailCoordinator.self) { _ in
      return DefaultDiaryDetailCoordinator(navigationController: navigationController)
    }
    
    DIContainer.shared.register(type: EmotionAnalyzeCoordinator.self) { _ in
      return DefaultEmotionAnalyzeCoordinator(navigationController: recordNavigationController)
    }
    
    DIContainer.shared.register(type: AnalyzeResultCoordinator.self) { _ in
      return DefaultAnalyzeResultCoordinator(navigationController: recordNavigationController)
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
