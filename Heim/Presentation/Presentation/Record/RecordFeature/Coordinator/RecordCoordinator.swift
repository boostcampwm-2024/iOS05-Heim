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
  func pushEmotionAnalyzeView(voice: Voice?)
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
  public func start() {
    guard let recordViewController = createRecordViewController() else { return }
    recordViewController.modalPresentationStyle = .fullScreen
    navigationController.present(recordViewController, animated: true)
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }
  
  public func pushEmotionAnalyzeView(voice: Voice?) {
    // TODO: EmotionAnlyzeView와 연결
  }
}

// MARK: - Private
private extension DefaultRecordCoordinator {
  func createRecordViewController() -> RecordViewController? {
    let viewModel = RecordViewModel()
    let viewController = RecordViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
