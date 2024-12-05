//
//  RecordCoordinator.swift
//  Presentation
//
//  Created by 박성근 on 11/17/24.
//

import Core
import Domain
import UIKit

public protocol RecordCoordinator: Coordinator {
  func pushEmotionAnalyzeView(recognizedText: String, voice: Voice)
  func provideRecordViewController() -> UINavigationController
}

public final class DefaultRecordCoordinator: RecordCoordinator {
  // MARK: - Properties
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  public var navigationController: UINavigationController
  
  // MARK: - Initialize
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  public func start() {}
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }
  
  public func pushEmotionAnalyzeView(recognizedText: String, voice: Voice) {
    guard let defaultEmotionAnalyzeCoordinator = DIContainer.shared.resolve(
      type: EmotionAnalyzeCoordinator.self
    ) else {
      return
    }
    
    addChildCoordinator(defaultEmotionAnalyzeCoordinator)
    defaultEmotionAnalyzeCoordinator.parentCoordinator = self
    defaultEmotionAnalyzeCoordinator.start(recognizedText: recognizedText, voice: voice)
  }
  
  public func provideRecordViewController() -> UINavigationController {
    guard let recordViewController = createRecordViewController() else {
      return UINavigationController()
    }
    
    navigationController.viewControllers = [recordViewController]
    
    return navigationController
  }
}

// MARK: - Private
private extension DefaultRecordCoordinator {
  func createRecordViewController() -> RecordViewController? {
    guard let recordManager = DIContainer.shared.resolve(type: RecordManagerProtocol.self) else {
      return nil
    }
    
    let viewModel = RecordViewModel(recordManager: recordManager)
    let viewController = RecordViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
