//
//  EmotionAnalyzeCoordinator.swift
//  Presentation
//
//  Created by 박성근 on 11/23/24.
//

import Core
import Domain
import UIKit

public protocol EmotionAnalyzeCoordinator: Coordinator {
  // MARK: - RecordView에서 넘어올 때 요약된 text, Voice Data를 가지고 넘어옵니다.
  func start(recognizedText: String, voice: Voice)
  func pushDiaryReportView(diary: Diary)
}

public final class DefaultEmotionAnalyzeCoordinator: EmotionAnalyzeCoordinator {
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
  
  public func start(recognizedText: String, voice: Voice) {
    guard let viewController = createEmotionAnalyzeViewController(text: recognizedText, voice: voice) else {
      return
    }
    navigationController.pushViewController(viewController, animated: true)
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }
  
  public func pushDiaryReportView(diary: Diary) {
    guard let defaultAnalyzeResultCoordinator = DIContainer.shared.resolve(type: AnalyzeResultCoordinator.self) else {
      return
    }
    
    addChildCoordinator(defaultAnalyzeResultCoordinator)
    defaultAnalyzeResultCoordinator.parentCoordinator = self
    defaultAnalyzeResultCoordinator.start(diary: diary)
  }
  
  public func backToApproachView() {
    parentCoordinator?.removeChild(self)
    parentCoordinator?.parentCoordinator?.removeChild(parentCoordinator)
    
    navigationController.dismiss(animated: true)
  }
}

// MARK: - Private
private extension DefaultEmotionAnalyzeCoordinator {
  func createEmotionAnalyzeViewController(text: String, voice: Voice) -> EmotionAnalyzeViewController? {
    guard let emotionClassfiyUseCase = DIContainer.shared.resolve(type: EmotionClassifyUseCase.self) else {
      return nil
    }
  
    guard let summaryUseCase = DIContainer.shared.resolve(type: GenerativeSummaryUseCase.self) else {
      return nil
    }
    
    guard let emotionUseCase = DIContainer.shared.resolve(type: GenerativeEmotionUseCase.self) else {
      return nil
    }
    
    let viewModel = EmotionAnalyzeViewModel(
      recognizedText: text,
      voice: voice,
      classifyUseCase: emotionClassfiyUseCase,
      emotionUseCase: emotionUseCase,
      summaryUseCase: summaryUseCase
    )
    
    let viewController = EmotionAnalyzeViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
