//
//  TabBarCoordinator.swift
//  Presentation
//
//  Created by 한상진 on 11/21/24.
//

import Core
import Domain
import UIKit

public protocol TabBarCoordinator: Coordinator {
  func setHomeView()
  func setRecordView()
  func setReportView()
}

public final class DefaultTabBarCoordinator: TabBarCoordinator {
  // MARK: - Properties
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  public var navigationController: UINavigationController
  private var tabBarViewController: CustomTabBarViewController?

  // MARK: - Initialize
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  public func start() {
    guard let tabBarViewController = createTabBarViewController() else { return }
    self.tabBarViewController = tabBarViewController
    navigationController.viewControllers = [tabBarViewController]
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }
  
  public func setHomeView() {
    guard let defaultHomeCoordinator = DIContainer.shared.resolve(type: HomeCoordinator.self) else { return }
    addChildCoordinator(defaultHomeCoordinator)
    defaultHomeCoordinator.parentCoordinator = self
    
    guard let homeViewController = defaultHomeCoordinator.provideHomeViewController() else { return }
    addChildView(homeViewController)
  }
  
  public func setRecordView() {
    guard let defaultRecordCoordinator = DIContainer.shared.resolve(type: RecordCoordinator.self) else { return }
    addChildCoordinator(defaultRecordCoordinator)
    defaultRecordCoordinator.parentCoordinator = self
    
    let recordNavigationController = defaultRecordCoordinator.provideRecordViewController()
    recordNavigationController.modalPresentationStyle = .fullScreen
    navigationController.present(recordNavigationController, animated: true)
  }
  
  public func setReportView() {
    guard let defaultReportCoordinator = DIContainer.shared.resolve(type: ReportCoordinator.self) else { return }
    addChildCoordinator(defaultReportCoordinator)
    defaultReportCoordinator.parentCoordinator = self
    
    guard let reportViewController = defaultReportCoordinator.provideReportViewController() else { return }
    navigationController.navigationBar.isHidden = true
    addChildView(reportViewController)
  }
}

private extension DefaultTabBarCoordinator {
  func createTabBarViewController() -> CustomTabBarViewController? {
    let viewController = CustomTabBarViewController()
    viewController.coordinator = self
    return viewController
  }
  
  func addChildView(_ childViewController: UIViewController) {
    guard let tabBarViewController else { return }
    removeLastTab()
    
    childViewController.view.frame = tabBarViewController.view.bounds
    tabBarViewController.addChild(childViewController)
    tabBarViewController.view.insertSubview(childViewController.view, belowSubview: tabBarViewController.tabBarView)
  }
  
  func removeLastTab() {
    guard let lastViewController = tabBarViewController?.children.last else { return }
    lastViewController.willMove(toParent: nil)
    lastViewController.view.removeFromSuperview()
    lastViewController.removeFromParent()
  }
}
