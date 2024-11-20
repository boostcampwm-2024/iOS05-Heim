//
//  ReportCoordinator.swift
//  Presentation
//
//  Created by 김미래 on 11/20/24.
//

import Core
import Domain
import UIKit

//MARK: 수정 필요
public protocol ReportCoordinator: Coordinator {}

public final class DefaultReportCoordinator: ReportCoordinator {
  // MARK: - Properties
  public var parentCoordinator: (any Coordinator)?
  public var childCoordinators: [any Coordinator]
  public var navigationController: UINavigationController

  // MARK: - Initializer
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  public func start() {
    guard let reportViewController = reportViewController() else { return }
    <#code#>
  }
  
  public func didFinish() {
    <#code#>
  }

  func reportViewController() -> ReportViewController? {
//    let reportViewController = ReportViewController()
//    guard let settingUseCase = DIContainer.shared.resolve(type: SettingUseCase.self) else { return nil }
//    let viewModel = SettingViewModel(useCase: settingUseCase)
//    let viewController = SettingViewController(viewModel: viewModel)
//    viewController.coordinator = self
    return reportViewController

  }

  
}
