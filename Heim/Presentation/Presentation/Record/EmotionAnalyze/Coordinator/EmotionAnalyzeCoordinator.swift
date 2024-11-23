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
  func start(recognizedtext: String, voice: Voice)
  func pushDiaryReportView(emotion: Emotion, heimReply: EmotionReport, voice: Voice)
}

public final class DefaultEmotionAnalyzeRecordCoordinator: EmotionAnalyzeCoordinator {
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
  
  public func start(recognizedtext: String, voice: Voice) {
    guard let viewController = createEmotionAnalyzeViewController(text: recognizedtext, voice: voice) else {
      return
    }
    navigationController.pushViewController(viewController, animated: true)
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }
  
  public func pushDiaryReportView(emotion: Emotion, heimReply: EmotionReport, voice: Voice) {
    // TODO: 분석 결과 화면으로 이동
  }
}

// MARK: - Private
private extension DefaultEmotionAnalyzeRecordCoordinator {
  func createEmotionAnalyzeViewController(text: String, voice: Voice) -> EmotionAnalyzeViewController? {
    // TODO: - TODO: GEMINI UseCase도 추가 해야함.
    guard let emotionClassfiyUseCase = DIContainer.shared.resolve(type: EmotionClassifyUseCase.self) else {
      return nil
    }
    
    // TODO: - viewModel에 추가로 인자를 생성 후 넣어줘야함.
    let viewModel = EmotionAnalyzeViewModel(
      recognizedText: text,
      voice: voice,
      classifyUseCase: emotionClassfiyUseCase
    )
    
    let viewController = EmotionAnalyzeViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
