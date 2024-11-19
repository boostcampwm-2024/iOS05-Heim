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
  // TODO: 기능필요시 추후 구현
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
    navigationController.pushViewController(recordViewController, animated: true)
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }
  
  // TODO: 프로토콜에서 추가 기능 명시 후 구현
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
